//
//  SearchFilterMenu.swift
//  photobox
//
//  Created by 강한결 on 7/26/24.
//

import UIKit
import SnapKit

final class SearchFilterMenu: BaseView {
    lazy var filterCollection = UICollectionView(frame: .zero, collectionViewLayout: setCollectionLayout())
    let sortButton = UIButton()
    
    
    override func setSubviews() {
        super.setSubviews()
        [filterCollection, sortButton].forEach {
            self.addSubview($0)
        }
    }
    
    override func setLayout() {
        super.setLayout()
        let guide = self.safeAreaLayoutGuide
        filterCollection.snp.makeConstraints { make in
            make.height.equalTo(36)
            make.centerY.equalTo(self.snp.centerY)
            make.leading.equalTo(guide).inset(16)
            make.trailing.equalTo(sortButton.snp.leading).offset(-8)
        }
        sortButton.snp.makeConstraints { make in
            make.trailing.equalTo(guide).inset(16)
            make.width.equalTo(100)
        }
    }
    
    override func setUI() {
        super.setUI()
        
        filterCollection.backgroundColor = .brown
        
        sortButton.configuration = .filled()
        sortButton.layer.cornerRadius = 16
        sortButton.layer.borderWidth = 1
        sortButton.layer.borderColor = UIColor.gray_lg.cgColor
        sortButton.configuration?.cornerStyle = .capsule
        sortButton.configuration?.image = .sort
        sortButton.configuration?.title = "최신순"
        sortButton.configuration?.imagePadding = 4
        sortButton.configuration?.baseBackgroundColor = .white
        sortButton.configuration?.baseForegroundColor = .gray_lg
    }
}

extension SearchFilterMenu {
    private func setCollectionLayout() -> UICollectionViewCompositionalLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2), heightDimension: .absolute(56))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(8)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}
