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
    
    // MARK: Not Observable variables
    private var total = 0
    private var total_pages = 0
    
    // MARK: Input
    var didLoadInput = Observable<Void?>(nil)
    var searchTextInput = Observable<String?>(nil)
    
    // MARK: Output
    var didLoadOutput = Observable<[SearchedPhotoOutput]>([])
    var searchErrorOutput = Observable<String?>(nil)
    
    
    init(networkManager: NetworkService, repositoryManager: LikedPhotoRepository) {
        self.networkManager = networkManager
        self.repositoryManager = repositoryManager
        
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
                                    id: $0.id,
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
        if (repositoryManager?.getLikedPhotoById(for: imageId)) != nil {
            return true
        } else {
            return false
        }
    }
}
