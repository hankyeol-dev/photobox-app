//
//  ProfileImageSettingViewController.swift
//  photobox
//
//  Created by 강한결 on 7/24/24.
//

import UIKit

final class ProfileImageSettingViewController: BaseViewController<ProfileImageSettingViewModel, ProfileImageSelectView> {
    
    private var dataSource: UICollectionViewDiffableDataSource<String, ProfileImages>!
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindData()
        setCollection()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let currentImage = viewModel.currentImage {
            viewModel.sender?(currentImage)
        }
    }
    
    override func setNavigation() {
        super.setNavigation()
        navigationItem.title = "프로필 이미지 선택"
        navigationItem.leftBarButtonItem = genLeftGoBackButton(target: self, action: #selector(goBack))
    }
    
    override func bindData() {
        viewModel.didLoadInput.value = ()
        viewModel.didLoadOutput.bindingWithoutInitCall { [weak self] profileImage in
            if let self, let profileImage {
                self.mainView.profileImage.setImage(for: profileImage)
                self.setCollectionData(for: profileImage)
            }
        }
    }
}

extension ProfileImageSettingViewController {
    @objc
    func goBack() {
        viewModel.goBackInput.value = ()
    }
}

extension ProfileImageSettingViewController: UICollectionViewDelegate {
    private func setCollection() {
        mainView.profileImageCollection.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.collecionItemSelectInput.value = dataSource.itemIdentifier(for: indexPath)
    }
    
    private func registerCollectionItem(for currentImage: ProfileImages) -> UICollectionView.CellRegistration<ProfileImageItem, ProfileImages> {
        return UICollectionView.CellRegistration<ProfileImageItem, ProfileImages> { cell, indexPath, item in
            cell.setUpImage(for: item, by: item == currentImage)
        }
    }
    
    private func setCollectionData(for currentImage: ProfileImages) {
        let registerdCell = registerCollectionItem(for: currentImage)
        var snapshot = NSDiffableDataSourceSnapshot<String, ProfileImages>()
        
        dataSource = UICollectionViewDiffableDataSource(
            collectionView: mainView.profileImageCollection,
            cellProvider: { collectionView, indexPath, item in
                return collectionView.dequeueConfiguredReusableCell(
                    using: registerdCell,
                    for: indexPath,
                    item: item
                )
            }
        )
        
        snapshot.appendSections(["profiles"])
        snapshot.appendItems(ProfileImages.allCases, toSection: "profiles")
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
