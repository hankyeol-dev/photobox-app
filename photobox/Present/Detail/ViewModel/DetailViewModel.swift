//
//  DetailViewModel.swift
//  photobox
//
//  Created by 강한결 on 7/27/24.
//

import Foundation

final class DetailViewModel: ViewModelProtocol {
    
    weak var networkManager: NetworkService?
    weak var repository: LikedPhotoRepository?
    weak var fileManager: FileManageService?
    
    private var photoId = ""
    
    // MARK: Input
    var didLoadInput = Observable("")
    var likeButtonInput = Observable<Void?>(nil)
    
    // MARK: Output
    var didLoadOutput = Observable<DetailOutput?>(nil)
    var failureOutput = Observable("")
    
    init(
        networkManager: NetworkService,
        repository: LikedPhotoRepository,
        fileManager: FileManageService
    ) {
        self.networkManager = networkManager
        self.repository = repository
        self.fileManager = fileManager
        
        bindingInput()
    }
    
    func bindingInput() {
        didLoadInput.bindingWithoutInitCall { [weak self] photoId in
            guard let self else { return }
            self.photoId = photoId
            self.fetchPhoto(by: photoId)
        }
        
        likeButtonInput.bindingWithoutInitCall { [weak self] _ in
            guard let self else { return }
            self.photoLikeHandler()
        }
        
    }
    
    private func fetchPhoto(by photoId: String) {
        Task {
            let result = await networkManager?.fetch(
                by: .detail(id: photoId),
                of: Photo.self
            )
            
            switch result {
            case .success(let success):
                DispatchQueue.main.async {
                    self.didLoadOutput.value = DetailOutput(
                        photo: success,
                        isLiked: self.validatingIsLikedImage(by: success.id)
                    )
                }
            case .failure(let failure):
                DispatchQueue.main.async {
                    if self.validatingIsLikedImage(by: photoId) {
                        
                        guard let dbResult = self.repository?.getLikedPhotoById(for: photoId) else {
                            self.failureOutput.value = "검색 결과를 찾을 수 없습니다."
                            return
                        }
                        
                        let getResult = self.fileManager?.getImage(for: dbResult.id)
                        
                        switch getResult {
                        case .success(let success):
                            self.didLoadOutput.value = DetailOutput(
                                photo: Photo(
                                    id: dbResult.id,
                                    created_at: dbResult.ownerCreatedAt,
                                    width: dbResult.width,
                                    height: dbResult.height,
                                    urls: PhotoUrls(
                                        regular: success, small: nil
                                    ),
                                    user: PhotoOwner(
                                        username: dbResult.ownerName,
                                        profile_image: PhotoUrls(
                                            regular: nil,
                                            small: dbResult.ownerImage)
                                    ),
                                    likes: 0,
                                    views: dbResult.views,
                                    downloads: dbResult.views
                                ),
                                isLiked: true
                            )
                        case .failure(_):
                            self.failureOutput.value = "검색 결과를 찾을 수 없습니다."
                        case nil:
                            break
                        }
                        
                        
                    } else {
                        self.failureOutput.value = failure.rawValue
                    }
                }
            case nil:
                break
            }
        }
    }
    
    private func validatingIsLikedImage(by photoId: String) -> Bool {
        return (repository?.getLikedPhotoById(for: photoId)) != nil
    }
    
    private func photoLikeHandler() {
        let id = didLoadInput.value
        guard let isLiked = didLoadOutput.value?.isLiked,
        let url = didLoadOutput.value?.photo.urls.regular else {
            failureOutput.value = "뭔가 잘못되었어요 :("
            return
        }
        
        if isLiked {
            let removeResult = fileManager?.removeImage(for: id)
            
            switch removeResult {
            case .success(_):
                DispatchQueue.main.async {
                    let dbResult = self.repository?.deleteLikedPhotoById(by: id)
                    
                    switch dbResult {
                    case .success(_):
                        self.didLoadOutput.value?.isLiked = false
                    case .failure(let failure):
                        self.failureOutput.value = failure.rawValue
                    case .none:
                        break
                    }
                }
            case .failure(let failure):
                failureOutput.value = failure.rawValue
            case nil:
                break
            }
        } else {
            Task {
                let result = await networkManager?.fetch(by: .detail(id: photoId), of: Photo.self)
                
                switch result {
                case .success(let success):
                    let saveResult = fileManager?.saveImage(for: url, by: id)
                    
                    switch saveResult {
                    case .success(_):
                        DispatchQueue.main.async {
                            let dbResult = self.repository?.addLikedPhoto(
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
                            
                            switch dbResult {
                            case .success(_):
                                self.didLoadOutput.value?.isLiked = true
                            case .failure(let failure):
                                self.failureOutput.value = failure.rawValue
                            case .none:
                                break
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
    }
}
