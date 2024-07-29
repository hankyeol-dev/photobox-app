//
//  SearchViewController.swift
//  photobox
//
//  Created by 강한결 on 7/26/24.
//

import UIKit

final class SearchViewController: BaseViewController<SearchViewModel, SearchView> {
    private var dataSource: UICollectionViewDiffableDataSource<String, SearchedPhotoOutput>!
    private var filterDataSource: UICollectionViewDiffableDataSource<String, ColorButtonOutput>!
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollection()
        setSearchController()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func setNavigation() {
        super.setNavigation()
        
        navigationItem.title = Text.Titles.NAVIGATION_SEARCH_PHOTO.rawValue
    }
    
    override func bindDataAtDidLoad() {
        super.bindDataAtDidLoad()
        
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
                    self.bindFilterMenuDataSource(by: self.viewModel.colorSortOptionOutput)
                }
            }
        }
    }
    
    override func bindData() {
        super.bindData()
        
        viewModel.searchErrorOutput.bindingWithoutInitCall { [weak self] output in
            guard let output, let self else { return }
            self.genToast(for: output, state: .error)
        }
        viewModel.likeButtonOutput.bindingWithoutInitCall { [weak self] message in
            guard let self else { return }
            self.genToast(for: message, state: .success)
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
        mainView.searchFilterMenu.filterCollection.delegate = self
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
    
    private func bindFilterMenuDataSource(by datas: [ColorButtonOutput]) {
        let cellRegister = UICollectionView.CellRegistration<SearchColorFilterItem, ColorButtonOutput> {
            [weak self] cell, indexPath, item in
            cell.bindView(for: item)
            cell.colorButton.tag = item.color.rawValue
            cell.colorButton.addTarget(self, action: #selector(self?.onTouchColorFilterButton), for: .touchUpInside)
        }
        
        filterDataSource = UICollectionViewDiffableDataSource(
            collectionView: mainView.searchFilterMenu.filterCollection,
            cellProvider: { collectionView, indexPath, item in
                return collectionView.dequeueConfiguredReusableCell(
                    using: cellRegister, for: indexPath, item: item)
            }
        )
        
        var snapshot = NSDiffableDataSourceSnapshot<String, ColorButtonOutput>()
        snapshot.appendSections(["filter"])
        snapshot.appendItems(datas, toSection: "filter")
        filterDataSource.apply(snapshot)
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
        mainView.endEditing(true)
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
    @objc
    private func onTouchColorFilterButton(_ sender: UIButton) {
        viewModel.colorSortOptionInput.value = sender.tag
    }
}
