//
//  RandomViewModel.swift
//  photobox
//
//  Created by 강한결 on 7/28/24.
//

import Foundation

final class RandomViewModel: ViewModelProtocol {
    
    weak var repository: LikedPhotoRepository?
    weak var fileManager: FileManageService?
    weak var networkManager: NetworkService?
    
    var likeButtonIndex = -1
    
    // MARK: Input
    var didLoadInput = Observable<Void?>(nil)
    var likeButtonTouchInput = Observable<Int>(-1)
    
    // MARK: Output
    var didLoadOutput = Observable<[DetailOutput]>([])
    var likeButtonTouchOutput = Observable("")
    var failureOutput = Observable("")
    
    init(
        repository: LikedPhotoRepository,
        fileManager: FileManageService,
        networkManager: NetworkService
    ) {
        self.repository = repository
        self.fileManager = fileManager
        self.networkManager = networkManager
        
        bindingInput()
    }
    
    
    func bindingInput() {
        didLoadInput.bindingWithoutInitCall { [weak self] _ in
            guard let self else { return }
            self.likeButtonIndex = -1
            self.bindingDidLoadOutput()
        }
        likeButtonTouchInput.bindingWithoutInitCall { [weak self] tag in
            guard let self else { return }
            self.likeButtonIndex = tag
            self.bindingLikeButtonOutput(by: tag)
        }
    }
    
    
    private func bindingDidLoadOutput() {
        Task {
            let result = await networkManager?.fetch(by: .random, of: [Photo].self)
            
            switch result {
            case .success(let success):
                DispatchQueue.main.async {
                    self.didLoadOutput.value = success.map {
                        DetailOutput(photo: $0, isLiked: self.validatingIsLikedImage(by: $0.id))
                    }
                }
            case .failure(let failure):
                failureOutput.value = failure.rawValue
            case .none:
                break
            }
        }
    }
    
    private func bindingLikeButtonOutput(by tag: Int) {
        let target = didLoadOutput.value[tag]
        
        if target.isLiked {
            let removeResult = fileManager?.removeImage(for: target.photo.id)
            
            switch removeResult {
            case .success(_):
                DispatchQueue.main.async {
                    let dbResult = self.repository?.deleteLikedPhotoById(by: target.photo.id)
                    
                    switch dbResult {
                    case .success(let success):
                        self.likeButtonTouchOutput.value = success
                        self.didLoadOutput.value[tag] = DetailOutput(photo: target.photo, isLiked: false)
                    case .failure(let failure):
                        self.failureOutput.value = failure.rawValue
                    case nil:
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
                let result = await networkManager?.fetch(by: .detail(id: target.photo.id), of: Photo.self)
                
                switch result {
                case .success(let success):
                    guard let url = target.photo.urls.regular else { return }
                    let saveResult = fileManager?.saveImage(for: url, by: target.photo.id)
                    
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
                            case .success(let success):
                                self.likeButtonTouchOutput.value = success
                                DispatchQueue.main.async {
                                    self.didLoadOutput.value[tag] = DetailOutput(photo: target.photo, isLiked: true)
                                }
                            case .failure(let failure):
                                self.failureOutput.value = failure.rawValue
                            case nil:
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
    
    private func validatingIsLikedImage(by imageId: String) -> Bool {
        return (repository?.getLikedPhotoById(for: imageId)) != nil
    }
}
