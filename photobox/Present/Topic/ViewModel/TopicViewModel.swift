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
        
        var byKorean: String {
            switch self {
            case .golden:
                "골든 아워"
            case .business:
                "비즈니스 및 업무"
            case .architect:
                "건축 및 인테리어"
            }
        }
    }
    
    var userNickname = UserDefaultsService.shared.getValue(for: .nickname)
    var userProfileImage = UserDefaultsService.shared.getValue(for: .profileImage)
    var userMbti = UserDefaultsService.shared.getValue(for: .mbti)
    var selectedIndex = (-1, -1)
    
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
            self.selectedIndex = (-1, -1)
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
            Task {
                // 1. 사진 정보를 정확하게 확인
                let result = await networkManager?.fetch(by: .detail(id: photo.photoId), of: Photo.self)
                
                switch result {
                case .success(let success):
                    // 2. 이미지 로컬에 저장
                    let saveResult = fileManageService?.saveImage(for: photo.url, by: photo.photoId)
                    
                    // 2-1. 이미지 로컬에 저장 상태에 따라 분기
                    switch saveResult {
                        // 2-2. 이미지 로컬에 저장 상태 성공
                    case .success(_):
                        // 3. 로컬 db에 레코드 생성
                        DispatchQueue.main.async {
                            let dbResult = self.likedPhotoRepository?.addLikedPhoto(
                                for: LikedPhoto(
                                    id: success.id,
                                    ownerName: success.user.username,
                                    ownerImage: success.user.profile_image.small,
                                    ownerCreatedAt: success.created_at,
                                    width: success.width,
                                    height: success.height,
                                    views: success.views,
                                    downloads: success.downloads
                                )
                            )
                            // 3-1. 로컬 db에 레코드 생성에 따른 분기
                            switch dbResult {
                                // 3-2. 로컬 db에 레코드 생성 성공
                            case .success(let success):
                                self.likeButtonOutput.value = success
                                DispatchQueue.main.async {
                                    self.didLoadOutput.value = self.didLoadOutput.value.map {
                                        $0.map {
                                            SearchedPhotoOutput(photoId: $0.photoId, url: $0.url, likes: $0.likes, isLiked: self.validatingIsLikedImage(by: $0.photoId))
                                        }
                                    }
                                }
                                // 3-2. 로컬 db에 레코드 생성 실패
                            case .failure(let failure):
                                self.failureOutput.value = failure.rawValue
                            case nil:
                                break
                            }
                        }
                        // 2-2. 이미지 로컬에 저장 상태 실패
                    case .failure(let failure):
                        failureOutput.value = failure.rawValue
                    case nil:
                        break
                    }
                case .failure(let failure):
                    failureOutput.value = failure.rawValue
                case .none:
                    break
                }
            }
        }
    }
    
    private func validatingIsLikedImage(by imageId: String) -> Bool {
        return (likedPhotoRepository?.getLikedPhotoById(for: imageId)) != nil
    }
}
