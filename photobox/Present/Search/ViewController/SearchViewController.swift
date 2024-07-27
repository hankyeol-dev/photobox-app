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
                self.mainView.onSearchNoneView()
            } else {
                DispatchQueue.main.async {
                    self.mainView.onSearchTableView()
                    self.bindCollectionDataSource(for: output)
                }
            }
        }
        viewModel.searchErrorOutput.bindingWithoutInitCall { [weak self] output in
            guard let output, let self else { return }
            self.mainView.makeToast(output, duration: 2, title: "뭔가 검색에 실패했어요.")
        }
        
    }
}

extension SearchViewController: UICollectionViewDelegate {
    private func setCollection() {
        mainView.searchCollection.delegate = self
    }
    
    private func bindCollectionDataSource(for datas: [SearchedPhotoOutput]) {
        let cellRegister = UICollectionView.CellRegistration<ImageCardItem, SearchedPhotoOutput> { cell, indexPath, item in
            cell.setUIWithData(for: item)
            cell.likeButtonHandler = {
                
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
    
    
}

extension SearchViewController: UISearchBarDelegate {
    private func setSearchController() {
        mainView.searchBar.delegate = self
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        mainView.endEditing(true)
        viewModel.searchTextInput.value = searchBar.text
    }
}
