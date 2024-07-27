//
//  LikeListViewModel.swift
//  photobox
//
//  Created by 강한결 on 7/27/24.
//

import Foundation

final class LikeListViewModel: ViewModelProtocol {
    
    weak var repository: LikedPhotoRepository?
    weak var filemanger: FileManageService?
    
    // MARK: Input
    var didLoadInput = Observable<Void?>(nil)
    var likeButtonInput = Observable<SearchedPhotoOutput?>(nil)
    
    // MARK: Output
    var didLoadOutput = Observable<[SearchedPhotoOutput]>([])
    var likeButtonOutput = Observable<String>("")
    var failureOutput = Observable("")
    
    
    init(
        repository: LikedPhotoRepository,
        filemanger: FileManageService
    ) {
        self.repository = repository
        self.filemanger = filemanger
        
        bindingInput()
    }
    
    func bindingInput() {
        didLoadInput.bindingWithoutInitCall { [weak self] _ in
            guard let self else { return }
            self.bindingDidLoadOutput()
        }
        
        likeButtonInput.bindingWithoutInitCall { [weak self] item in
            guard let self else { return }
            self.photoLikeHandler(for: item)
        }
    }
    
    private func bindingDidLoadOutput() {
        let likedRecords = repository?.getLikedPhotos()
        
        if let likedRecords, likedRecords.count != 0 {
            likedRecords.forEach {
                let savedImageResult = filemanger?.getImage(for: $0.id)
                switch savedImageResult {
                case .success(let success):
                    
                    self.didLoadOutput.value.append(SearchedPhotoOutput(id: $0.id, url: success, likes: 0, isLiked: true))
                case .failure(let failure):
                    self.failureOutput.value = failure.rawValue
                case .none:
                    break
                }
            }
        }
    }
    
    private func photoLikeHandler(for photo: SearchedPhotoOutput?) {
        guard let photo else { return }
        
        let removeResult = filemanger?.removeImage(for: photo.id)
        
        switch removeResult {
        case .success(_):
            DispatchQueue.main.async {
                let dbResult = self.repository?.deleteLikedPhotoById(by: photo.id)
                
                switch dbResult {
                case .success(let success):
                    self.likeButtonOutput.value = success
                    self.didLoadOutput.value = self.didLoadOutput.value.filter { $0.id != photo.id }
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
    }
    
    
    private func validatingIsLikedImage(by imageId: String) -> Bool {
        return (repository?.getLikedPhotoById(for: imageId)) != nil
    }
}
