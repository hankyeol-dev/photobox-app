//
//  LikeListView.swift
//  photobox
//
//  Created by 강한결 on 7/27/24.
//

import UIKit
import SnapKit

final class LikeListView: BaseView, MainViewProtocol {
    var sender: ((LikePhotoSortOption) -> Void)?
    
    let listFilterMenu = SearchFilterMenu()
    lazy var listCollection = UICollectionView(
        frame: .zero, collectionViewLayout: setCollectionLayout()
    )
    private let listNoneView = UILabel()
    
    override func setUI() {
        super.setUI()
        
        listFilterMenu.setButtionTitle(for: OrderBy.latest.byKorean)
        
        let menus = LikePhotoSortOption.allCases.map { sort in
            UIAction(title: sort.byKorean) { [weak self] action in
                guard let self else { return }
                self.listFilterMenu.setButtionTitle(for: sort.byKorean)
                self.sender?(sort)
            }
        }
        
        listFilterMenu.sortButton.menu = UIMenu(
            identifier: nil, options: .singleSelection, children: menus)
    }
    
    private func setCollectionLayout() -> UICollectionViewCompositionalLayout {
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.49), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.62))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = NSCollectionLayoutSpacing.flexible(1.0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 4.0
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func onListView() {
        [listFilterMenu, listCollection].forEach {
            self.addSubview($0)
        }
        listFilterMenu.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
            make.height.equalTo(36)
        }
        listCollection.snp.makeConstraints { make in
            make.top.equalTo(listFilterMenu.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.bottom.equalTo(self.safeAreaLayoutGuide)
        }
        
        listFilterMenu.hideFilterCollection()
        
    }
    
    func onListNoneView() {
        self.addSubview(listNoneView)
        listNoneView.snp.makeConstraints { make in
            make.edges.bottom.equalTo(self.safeAreaLayoutGuide)
        }
        
        listNoneView.backgroundColor = .systemBackground
        listNoneView.text = "좋아요한 사진이 없습니다."
        listNoneView.textAlignment = .center
        listNoneView.font = .systemFont(ofSize: 16, weight: .semibold)
    }
}
