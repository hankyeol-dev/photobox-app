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
    
    // MARK: Not Observable variables
    private var query = ""
    private var current_page = 0
    private var total_pages = 0
    private var isFetching = false
    private var currentOrder: OrderBy = .relevant
    
    // MARK: Input
    var didLoadInput = Observable<Void?>(nil)
    var searchTextDidChangeInput = Observable<String?>(nil)
    var searchTextDidClickedInput = Observable<String?>(nil)
    var likeButtonInput = Observable<SearchedPhotoOutput?>(nil)
    var scrollInput = Observable<Void?>(nil)
    var sortOptionInput = Observable<OrderBy>(.latest)

    // MARK: Output
    var didLoadOutput = Observable<[SearchedPhotoOutput]>([])
    var likeButtonOutput = Observable<String>("")
    var searchErrorOutput = Observable<String?>(nil)
    
    
    init(
        networkManager: NetworkService,
        repositoryManager: LikedPhotoRepository,
        fileManageService: FileManageService
    ) {
        self.networkManager = networkManager
        self.repositoryManager = repositoryManager
        self.fileManageService = fileManageService
        
        bindingInput()
    }
    
    
    func bindingInput() {
        didLoadInput.bindingWithoutInitCall { [weak self] _ in
            guard let self else { return }
            self.didLoadOutput.value = []
        }
        searchTextDidChangeInput.bindingWithoutInitCall { [weak self] input in
            guard let self, let input else { return }
            self.query = input
            if query.isEmpty {
                self.didLoadOutput.value = []
            }
        }
        searchTextDidClickedInput.bindingWithoutInitCall { [weak self] text in
            guard let self else { return }
            self.didLoadOutput.value = []
            self.bindingSearchTextInput(for: text)
        }
        likeButtonInput.bindingWithoutInitCall { [weak self] photo in
            guard let self else { return }
            self.photoLikeHandler(for: photo)
        }
        scrollInput.bindingWithoutInitCall { [weak self] _ in
            guard let self else { return }
            self.bindScrollInput()
        }
        sortOptionInput.bindingWithoutInitCall { [weak self] order in
            guard let self else { return }
            if order != currentOrder && !self.query.isEmpty {
                self.currentOrder = order
                self.didLoadOutput.value = []
                self.bindingSearchTextInput(for: self.query)
            }
        }
    }
    
    private func bindingSearchTextInput(for text: String?) {
        guard let text else {
            self.didLoadOutput.value = []
            return
        }
        query = text
        
        if query.isEmpty {
            didLoadOutput.value = []
        }
        
        Task {
            let result = await networkManager?.fetch(
                by: .search(query: text, order_by: currentOrder),
                of: PhotoSearchResult.self
            )
            
            switch result {
            case .success(let success):
                total_pages = success.total_pages
                current_page = 1
                
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
            Task {
                let result = await networkManager?.fetch(by: .detail(id: photo.photoId), of: Photo.self)
                
                switch result {
                case .success(let success):
                    let saveResult = fileManageService?.saveImage(for: photo.url, by: photo.photoId)
                    
                    switch saveResult {
                    case .success(_):
                        DispatchQueue.main.async {
                            let dbResult = self.repositoryManager?.addLikedPhoto(
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
                                self.likeButtonOutput.value = success
                                DispatchQueue.main.async {
                                    self.didLoadOutput.value = self.didLoadOutput.value.map {
                                        SearchedPhotoOutput(photoId: $0.photoId, url: $0.url, likes: $0.likes, isLiked: self.validatingIsLikedImage(by: $0.photoId))
                                    }
                                }
                            case .failure(let failure):
                                self.searchErrorOutput.value = failure.rawValue
                            case nil:
                                break
                            }
                        }
                    case .failure(let failure):
                        searchErrorOutput.value = failure.rawValue
                    case nil:
                        break
                    }
                case .failure(let failure):
                    searchErrorOutput.value = failure.rawValue
                case .none:
                    break
                }
            }
        }
    }
    
    private func bindScrollInput() {
        guard !query.isEmpty else { return }
        
        Task {
            if total_pages > current_page && !isFetching {
                isFetching = true
                let result = await networkManager?.fetch(
                    by: .search(query: query, page: current_page + 1, order_by: currentOrder),
                    of: PhotoSearchResult.self
                )
                
                switch result {
                case .success(let success):
                    current_page += 1
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
                    searchErrorOutput.value = failure.rawValue
                case .none:
                    break
                }
                isFetching = false
            }
        }
    }
}
