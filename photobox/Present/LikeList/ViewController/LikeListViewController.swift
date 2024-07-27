//
//  LikeListViewController.swift
//  photobox
//
//  Created by 강한결 on 7/27/24.
//

import UIKit

final class LikeListViewController: BaseViewController<LikeListViewModel, LikeListView> {
    
    private var dataSource: UICollectionViewDiffableDataSource<String, SearchedPhotoOutput>!
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollection()
    }
    
    override func setNavigation() {
        super.setNavigation()
        
        navigationItem.title = "좋아요한 사진 목록"
    }
    
    override func bindData() {
        super.bindData()
        
        viewModel.didLoadInput.value = ()
        viewModel.didLoadOutput.binding { [weak self] output in
            guard let self else { return }
            if output.count != 0 {
                self.bindCollectionDataSource(for: output)
                self.mainView.onListView()
            } else {
                self.mainView.onListNoneView()
            }
        }
    }
}

extension LikeListViewController: UICollectionViewDelegate {
    private func setCollection() {
        mainView.listCollection.delegate = self
    }
    
    private func bindCollectionDataSource(for datas: [SearchedPhotoOutput]) {
        let cellRegister = UICollectionView.CellRegistration<ImageCardItem, SearchedPhotoOutput> { cell, indexPath, item in
            cell.setUIWithData(for: item)
            cell.likeButtonHandler = { [weak self] in
                guard let self else { return }
                self.viewModel.likeButtonInput.value = item
            }
        }
        
        dataSource = UICollectionViewDiffableDataSource(
            collectionView: mainView.listCollection,
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
}
