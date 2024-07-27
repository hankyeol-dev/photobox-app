//
//  SearchViewController.swift
//  photobox
//
//  Created by 강한결 on 7/26/24.
//

import UIKit

final class SearchViewController: BaseViewController<SearchViewModel, SearchView> {
    private var dataSource: UICollectionViewDiffableDataSource<String, SearchedPhotoOutput>!
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollection()
        setSearchController()
        bindAction()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mainView.searchBar.text = ""
    }
    
    override func setNavigation() {
        super.setNavigation()
        
        navigationItem.title = "사진 검색"
    }
    
    override func bindData() {
        super.bindData()
        
        viewModel.didLoadInput.value = ()
        viewModel.didLoadOutput.binding { [weak self] output in
            guard let self else { return }
            if output.count == 0 {
                DispatchQueue.main.async {
                    self.mainView.onSearchNoneView()
                }
            } else {
                DispatchQueue.main.async {
                    self.mainView.onSearchTableView()
                    self.bindCollectionDataSource(for: output)
                }
            }
        }
        viewModel.searchErrorOutput.bindingWithoutInitCall { [weak self] output in
            guard let output, let self else { return }
            self.mainView.makeToast(output, duration: 2, position: .top)
        }
        viewModel.likeButtonOutput.bindingWithoutInitCall { [weak self] message in
            guard let self else { return }
            if message.count != 0 {
                self.mainView.makeToast(message, duration: 1, position: .top)
            }
        }
        
        mainView.sender = { [weak self] order in
            guard let self else { return }
            self.viewModel.sortOptionInput.value = order
        }
    }
}

extension SearchViewController: UICollectionViewDelegate {
    private func setCollection() {
        mainView.searchCollection.delegate = self
    }
    
    private func bindCollectionDataSource(for datas: [SearchedPhotoOutput]) {
        let cellRegister = UICollectionView.CellRegistration<ImageCardItem, SearchedPhotoOutput> { cell, indexPath, item in
            cell.setUIWithData(for: item, showLikeCount:  true)
            cell.likeButtonHandler = { [weak self] in
                guard let self else { return }
                self.viewModel.likeButtonInput.value = item
            }
        }
        
        dataSource = UICollectionViewDiffableDataSource(
            collectionView: mainView.searchCollection,
            cellProvider: { collectionView, indexPath, item in
                return collectionView.dequeueConfiguredReusableCell(
                    using: cellRegister, for: indexPath, item: item)
            })
        
        var snapshot = NSDiffableDataSourceSnapshot<String, SearchedPhotoOutput>()
        snapshot.appendSections(["main"])
        snapshot.appendItems(datas, toSection: "main")
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let data = dataSource.itemIdentifier(for: indexPath) else { return }
        
        let vm = DetailViewModel(
            networkManager: NetworkService.shared,
            repository: LikedPhotoRepository.shared,
            fileManager: FileManageService.shared
        )
        vm.didLoadInput.value = data.photoId
        
        let mv = DetailView()
        
        let detailVC = DetailViewController(viewModel: vm, mainView: mv)
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let query = mainView.searchBar.text else { return }
        let collection = mainView.searchCollection
        
        if collection.contentOffset.y >= (collection.contentSize.height - collection.bounds.size.height) {
            viewModel.scrollInput.value = ()
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    private func setSearchController() {
        mainView.searchBar.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchTextDidChangeInput.value = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        mainView.endEditing(true)
        viewModel.searchTextDidClickedInput.value = searchBar.text
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchTextDidChangeInput.value = ""
    }
}

extension SearchViewController {
    private func bindAction() {
        mainView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(bindEndEditing)))
    }
    
    @objc
    private func bindEndEditing() {
        mainView.endEditing(true)
    }
}
