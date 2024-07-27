//
//  SearchViewModel.swift
//  photobox
//
//  Created by 강한결 on 7/26/24.
//

import Foundation


final class SearchViewModel: ViewModelProtocol {
    
    weak var networkManager: NetworkService?
    weak var repositoryManager: LikedPhotoRepository?
    weak var fileManageService: FileManageService?
    weak var navigator: DetailViewNavigatingProtocol?
    
    // MARK: Not Observable variables
    private var total = 0
    private var total_pages = 0
    
    // MARK: Input
    var didLoadInput = Observable<Void?>(nil)
    var searchTextInput = Observable<String?>(nil)
    var likeButtonInput = Observable<SearchedPhotoOutput?>(nil)

    // MARK: Output
    var didLoadOutput = Observable<[SearchedPhotoOutput]>([])
    var likeButtonOutput = Observable<String>("")
    var searchErrorOutput = Observable<String?>(nil)
    
    
    init(
        networkManager: NetworkService,
        repositoryManager: LikedPhotoRepository,
        fileManageService: FileManageService,
        navigator: DetailViewNavigatingProtocol
    ) {
        self.networkManager = networkManager
        self.repositoryManager = repositoryManager
        self.fileManageService = fileManageService
        self.navigator = navigator
        
        bindingInput()
    }
    
    
    func bindingInput() {
        didLoadInput.bindingWithoutInitCall { [weak self] _ in
            guard let self else { return }
            self.didLoadOutput.value = []
        }
        searchTextInput.bindingWithoutInitCall { [weak self] text in
            guard let self else { return }
            self.bindingSearchTextInput(for: text)
        }
        likeButtonInput.bindingWithoutInitCall { [weak self] photo in
            guard let self else { return }
            self.photoLikeHandler(for: photo)
        }
    }
    
    private func bindingSearchTextInput(for text: String?) {
        guard let text else {
            self.didLoadOutput.value = []
            return
        }
        
        Task {
            let result = await networkManager?.fetch(
                by: .search(query: text),
                of: PhotoSearchResult.self
            )
            
            switch result {
            case .success(let success):
                total = success.total
                total_pages = success.total_pages
                
                DispatchQueue.main.async {
                    success.results.forEach {
                        if let url = $0.urls.regular {
                            self.didLoadOutput.value.append(
                                SearchedPhotoOutput(
                                    photoId: $0.id,
                                    url: url,
                                    likes: $0.likes,
                                    isLiked: self.validatingIsLikedImage(by: $0.id)
                                )
                            )
                        }
                    }
                }
            case .failure(let failure):
                didLoadOutput.value = []
                searchErrorOutput.value = failure.rawValue
            case .none:
                break
            }
        }
    }
    
    private func validatingIsLikedImage(by imageId: String) -> Bool {
        return (repositoryManager?.getLikedPhotoById(for: imageId)) != nil
    }
    
    private func photoLikeHandler(for photo: SearchedPhotoOutput?) {
        guard let photo else { return }
        
        if photo.isLiked {
            let removeResult = fileManageService?.removeImage(for: photo.photoId)
            
            switch removeResult {
            case .success(_):
                let dbResult = repositoryManager?.deleteLikedPhotoById(by: photo.photoId)
                
                switch dbResult {
                case .success(let success):
                    likeButtonOutput.value = success
                    DispatchQueue.main.async {
                        self.didLoadOutput.value = self.didLoadOutput.value.map {
                            SearchedPhotoOutput(photoId: $0.photoId, url: $0.url, likes: $0.likes, isLiked: self.validatingIsLikedImage(by: $0.photoId))
                        }
                    }
                case .failure(let failure):
                    searchErrorOutput.value = failure.rawValue
                case nil:
                    break
                }
            case .failure(let failure):
                searchErrorOutput.value = failure.rawValue
            case nil:
                break
            }
            
        } else {
            let saveResult = fileManageService?.saveImage(for: photo.url, by: photo.photoId)
            
            switch saveResult {
            case .success(_):
                let dbResult = repositoryManager?.addLikedPhoto(for: LikedPhoto(id: photo.photoId))
                
                switch dbResult {
                case .success(let success):
                    likeButtonOutput.value = success
                    DispatchQueue.main.async {
                        self.didLoadOutput.value = self.didLoadOutput.value.map {
                            SearchedPhotoOutput(photoId: $0.photoId, url: $0.url, likes: $0.likes, isLiked: self.validatingIsLikedImage(by: $0.photoId))
                        }
                    }
                case .failure(let failure):
                    searchErrorOutput.value = failure.rawValue
                case nil:
                    break
                }
            case .failure(let failure):
                searchErrorOutput.value = failure.rawValue
            case nil:
                break
            }
        }
    }
}
