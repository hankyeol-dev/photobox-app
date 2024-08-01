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
    
    var userNickname = UserDefaultsService.shared.getValue(for: .nickname)
    var userProfileImage = UserDefaultsService.shared.getValue(for: .profileImage)
    var userMbti = UserDefaultsService.shared.getValue(for: .mbti)
    var selectedIndex = (-1, -1)
    var topicTitles: [String] = []
    
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
            self.topicTitles = []
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
        
        SectionKind.randomThree.enumerated().forEach { [weak self] (idx, value) in
            guard let self else { return }
            
            group.enter()
            self.topicTitles.append(value.byKorean)
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
        guard let fileManageService, let likedPhotoRepository else { return }
        
        if photo.isLiked {
            // 이미 좋아요된 사진이라면 -> 좋아요 취소
            // 사진을 먼저 삭제
            disLikeHandler(
                fileManager: fileManageService,
                repository: likedPhotoRepository,
                by: photo.photoId
            ) { [weak self] result in
                
                guard let self else { return }
                
                switch result {
                case .success(let success):
                    likeButtonOutput.value = success
                    didLoadOutput.value = didLoadOutput.value.map {
                        $0.map {
                            SearchedPhotoOutput(
                                photoId: $0.photoId,
                                url: $0.url,
                                likes: $0.likes,
                                isLiked: self.validatingIsLikedImage(by: $0.photoId))
                        }
                    }
                case .failure(let failure):
                    if type(of: failure) == LikedPhotoRepository.RepositoryError.self {
                        failureOutput.value = (failure as! LikedPhotoRepository.RepositoryError).rawValue
                    }
                    
                    if type(of: failure) == FileManageService.FileManageError.self {
                        failureOutput.value = (failure as! FileManageService.FileManageError).rawValue
                    }
                }
            }
        } else {
            likeHandler(
                fileManager: fileManageService,
                repository: likedPhotoRepository,
                for: photo.url,
                by: photo.photoId
            ) { [weak self] result in
                
                guard let self else { return }
                
                switch result {
                case .success(let success):
                    self.likeButtonOutput.value = success
                    DispatchQueue.main.async {
                        self.didLoadOutput.value = self.didLoadOutput.value.map {
                            $0.map {
                                SearchedPhotoOutput(photoId: $0.photoId, url: $0.url, likes: $0.likes, isLiked: self.validatingIsLikedImage(by: $0.photoId))
                            }
                        }
                    }
                case .failure(let failure):
                    if type(of: failure) == LikedPhotoRepository.RepositoryError.self {
                        self.failureOutput.value = (failure as! LikedPhotoRepository.RepositoryError).rawValue
                    }
                    
                    if type(of: failure) == FileManageService.FileManageError.self {
                        self.failureOutput.value = (failure as! FileManageService.FileManageError).rawValue
                    }
                    
                    if type(of: failure) == NetworkService.NetworkErrors.self {
                        self.failureOutput.value = (failure as! NetworkService.NetworkErrors).rawValue
                    }
                }
                
            }
        }
    }
    
    private func validatingIsLikedImage(by imageId: String) -> Bool {
        return (likedPhotoRepository?.getLikedPhotoById(for: imageId)) != nil
    }
    
//    func disLikeHandler(
//        fileManager: FileManageService,
//        repository: LikedPhotoRepository,
//        by photoId: String,
//        handler: @escaping (Result<String, any Error>) -> Void
//    ) {
//        let removeResult = fileManager.removeImage(for: photoId)
//        
//        switch removeResult {
//        case .success(_):
//            DispatchQueue.main.async {
//                let dbResult = repository.deleteLikedPhotoById(by: photoId)
//                
//                switch dbResult {
//                case .success(let success):
//                    handler(.success(success))
//                case .failure(let failure):
//                    handler(.failure(failure))
//                }
//            }
//        case .failure(let failure):
//            handler(.failure(failure))
//        }
//    }
//    
//    func likeHandler(
//        fileManager: FileManageService,
//        repository: LikedPhotoRepository,
//        for photoUrl: String,
//        by photoId: String,
//        handler: @escaping (Result<String, any Error>) -> Void
//    ) {
//        Task {
//            let networkResult = await NetworkService.shared.fetch(by: .detail(id: photoId), of: Photo.self)
//            
//            switch networkResult {
//            case .success(let success):
//                let saveResult = fileManager.saveImage(for: photoUrl, by: photoId)
//                
//                switch saveResult {
//                case .success(_):
//                    DispatchQueue.main.async {
//                        let dbResult = self.likedPhotoRepository?.addLikedPhoto(
//                            for: LikedPhoto(
//                                id: success.id,
//                                ownerName: success.user.username,
//                                ownerImage: success.user.profile_image.small,
//                                ownerCreatedAt: success.created_at,
//                                width: success.width,
//                                height: success.height,
//                                views: success.views,
//                                downloads: success.downloads
//                            )
//                        )
//                        switch dbResult {
//                        case .success(let successString):
//                            handler(.success(successString))
//                        case .failure(let failure):
//                            handler(.failure(failure))
//                        case .none:
//                            break
//                        }
//                    }
//                case .failure(let failure):
//                    handler(.failure(failure))
//                }
//            case .failure(let failure):
//                handler(.failure(failure))
//            }
//        }
//    }
}
