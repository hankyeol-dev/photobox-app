//
//  TopicViewModel.swift
//  photobox
//
//  Created by 강한결 on 7/24/24.
//

import Foundation

final class TopicViewModel: ViewModelProtocol {
    
    weak var networkManager: NetworkService?
    weak var fileManageService: FileManageService?
    weak var likedPhotoRepository: LikedPhotoRepository?
    
    enum SectionKind: String, CaseIterable {
        case golden = "golden-hour"
        case business = "business-work"
        case architect = "architecture-interior"
    }
    
    var userNickname = UserDefaultsService.shared.getValue(for: .nickname)
    var userProfileImage = UserDefaultsService.shared.getValue(for: .profileImage)
    var userMbti = UserDefaultsService.shared.getValue(for: .mbti)
    
    // MARK: Input
    var didLoadInput = Observable<Void?>(nil)
    var likeButtonInput = Observable<SearchedPhotoOutput?>(nil)
    
    // MARK: Output
    var didLoadOutput = Observable<[[SearchedPhotoOutput]]>([[], [] , []])
    var likeButtonOutput = Observable<String>("")
    var failureOutput = Observable<String>("")
    
    init(
        networkManager: NetworkService,
        fileManageService: FileManageService,
        likedPhotoRepository: LikedPhotoRepository
    ) {
        self.networkManager = networkManager
        self.fileManageService = fileManageService
        self.likedPhotoRepository = likedPhotoRepository
        
        bindingInput()
    }
    
    func bindingInput() {
        didLoadInput.bindingWithoutInitCall { [weak self] _ in
            guard let self else { return }
            self.bindingDidLoadOutput()
            self.userProfileImage = UserDefaultsService.shared.getValue(for: .profileImage)
        }
        likeButtonInput.bindingWithoutInitCall { [weak self] photo in
            guard let self else { return }
            self.photoLikeHandler(for: photo)
        }

    }
    
    private func bindingDidLoadOutput() {
        let group = DispatchGroup()
        
        SectionKind.allCases.enumerated().forEach { (idx, value) in
            group.enter()
            DispatchQueue.global().async(group: group) {
                self.networkManager?.fetch(
                    by: .topic(topicName: value.rawValue),
                    of: [Photo].self
                ) { [weak self] result in
                    guard let self else { return }
                    switch result {
                    case .success(let result):
                        DispatchQueue.main.async {
                            self.didLoadOutput.value[idx] = result.map {
                                SearchedPhotoOutput(
                                    photoId: $0.id, url: $0.urls.regular!, likes: $0.likes, isLiked: self.validatingIsLikedImage(by: $0.id)
                                )
                            }
                        }
                        group.leave()
                    case .failure(let result):
                        self.failureOutput.value = result.rawValue
                        group.leave()
                    }
                }
            }
        }
    }
    
    
    private func photoLikeHandler(for photo: SearchedPhotoOutput?) {
        guard let photo else { return }
        
        if photo.isLiked {
            // 이미 좋아요된 사진이라면 -> 좋아요 취소
            // 사진을 먼저 삭제
            let removeResult = fileManageService?.removeImage(for: photo.photoId)
            
            switch removeResult {
            case .success(_):
                let dbResult = likedPhotoRepository?.deleteLikedPhotoById(by: photo.photoId)
                
                switch dbResult {
                case .success(let success):
                    likeButtonOutput.value = success
                    DispatchQueue.main.async {
                        self.didLoadOutput.value = self.didLoadOutput.value.map {
                            $0.map {
                                SearchedPhotoOutput(photoId: $0.photoId, url: $0.url, likes: $0.likes, isLiked: self.validatingIsLikedImage(by: $0.photoId))
                            }
                        }
                    }
                case .failure(let failure):
                    failureOutput.value = failure.rawValue
                case nil:
                    break
                }
            case .failure(let failure):
                failureOutput.value = failure.rawValue
            case nil:
                break
            }
            
        } else {
            // 좋아요 되지 않은 사진이라면,
            // 사진을 먼저 저장
            let saveResult = fileManageService?.saveImage(for: photo.url, by: photo.photoId)
            
            switch saveResult {
            case .success(_):
                let dbResult =  likedPhotoRepository?.addLikedPhoto(for: LikedPhoto(id: photo.photoId))
                
                switch dbResult {
                case .success(let success):
                    likeButtonOutput.value = success
                    DispatchQueue.main.async {
                        self.didLoadOutput.value = self.didLoadOutput.value.map {
                            $0.map {
                                SearchedPhotoOutput(photoId: $0.photoId, url: $0.url, likes: $0.likes, isLiked: self.validatingIsLikedImage(by: $0.photoId))
                            }
                        }
                    }
                case .failure(let failure):
                    failureOutput.value = failure.rawValue
                case nil:
                    break
                }
                
            case .failure(let failure):
                failureOutput.value = failure.rawValue
            case nil:
                break
            }
        }
        
        
        
    }
    
    private func validatingIsLikedImage(by imageId: String) -> Bool {
        return (likedPhotoRepository?.getLikedPhotoById(for: imageId)) != nil
    }
}
