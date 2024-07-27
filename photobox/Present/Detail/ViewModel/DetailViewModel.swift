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
                failureOutput.value = failure.rawValue
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
            let saveResult = fileManager?.saveImage(for: url, by: id)
            
            switch saveResult {
            case .success(_):
                DispatchQueue.main.async {
                    let dbResult = self.repository?.addLikedPhoto(for: LikedPhoto(id: id))
                    
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
        }
    }
}
