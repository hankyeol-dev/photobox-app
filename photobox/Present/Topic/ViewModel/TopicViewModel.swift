//
//  TopicViewModel.swift
//  photobox
//
//  Created by 강한결 on 7/24/24.
//

import Foundation

final class TopicViewModel: ViewModelProtocol {
    
    weak var fileManageService: FileManageService?
    weak var likedPhotoRepository: LikedPhotoRepository?
    
    
    
    // MARK: Input
    var likeButtonInput = Observable<SearchedPhotoOutput?>(nil)
    
    // MARK: Output
    var likeButtonOutput = Observable<String>("")
    var failureOutput = Observable<String>("")
    
    init(fileManageService: FileManageService, likedPhotoRepository: LikedPhotoRepository) {
        self.fileManageService = fileManageService
        self.likedPhotoRepository = likedPhotoRepository
        
        bindingInput()
    }
    
    func bindingInput() {
        likeButtonInput.bindingWithoutInitCall { [weak self] photo in
            guard let self else { return }
            self.photoLikeHandler(for: photo)
        }
    }
    
    private func photoLikeHandler(for photo: SearchedPhotoOutput?) {
        guard let photo else { return }
        
        // 사진을 먼저 저장
        let saveResult = fileManageService?.saveImage(for: photo.url, by: photo.id)
        
        switch saveResult {
        case .success(_):
            let dbResult =  likedPhotoRepository?.addLikedPhoto(for: LikedPhoto(id: photo.id))
            
            switch dbResult {
            case .success(let success):
                likeButtonOutput.value = success
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
    
    private func isLikedPhotoHandler(for photo: Photo?) {
        guard let photo else { return }
        
        if let target = likedPhotoRepository?.getLikedPhotoById(for: photo.id) {
            
        }
    }
}
