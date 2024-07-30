//
//  ViewModelProtocol.swift
//  photobox
//
//  Created by 강한결 on 7/22/24.
//

import Foundation

protocol ViewModelProtocol: AnyObject {
    func bindingInput()
}

extension ViewModelProtocol {
    func disLikeHandler(
        fileManager: FileManageService,
        repository: LikedPhotoRepository,
        by photoId: String,
        handler: @escaping (Result<String, any Error>) -> Void
    ) {
        let removeResult = fileManager.removeImage(for: photoId)
        
        switch removeResult {
        case .success(_):
            DispatchQueue.main.async {
                let dbResult = repository.deleteLikedPhotoById(by: photoId)
                
                switch dbResult {
                case .success(let success):
                    handler(.success(success))
                case .failure(let failure):
                    handler(.failure(failure))
                }
            }
        case .failure(let failure):
            handler(.failure(failure))
        }
    }
    
    func likeHandler(
        fileManager: FileManageService,
        repository: LikedPhotoRepository,
        for photoUrl: String,
        by photoId: String,
        handler: @escaping (Result<String, any Error>) -> Void
    ) {
        Task {
            let networkResult = await NetworkService.shared.fetch(by: .detail(id: photoId), of: Photo.self)
            
            switch networkResult {
            case .success(let success):
                let saveResult = fileManager.saveImage(for: photoUrl, by: photoId)
                
                switch saveResult {
                case .success(_):
                    DispatchQueue.main.async {
                        let dbResult = repository.addLikedPhoto(
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
                        case .success(let successString):
                            handler(.success(successString))
                        case .failure(let failure):
                            handler(.failure(failure))
                        }
                    }
                case .failure(let failure):
                    handler(.failure(failure))
                }
            case .failure(let failure):
                handler(.failure(failure))
            }
        }
    }
}
