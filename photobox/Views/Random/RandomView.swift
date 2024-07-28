//
//  RandomView.swift
//  photobox
//
//  Created by 강한결 on 7/28/24.
//

import UIKit
import SnapKit

final class RandomView: BaseView, MainViewProtocol {
    lazy var randomCollection = UICollectionView(
        frame: .zero,
        collectionViewLayout: createLayout()
    )
    
    override func setSubviews() {
        super.setSubviews()
        self.addSubview(randomCollection)
    }
    
    override func setLayout() {
        super.setLayout()
        randomCollection.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        section.contentInsetsReference = .none
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .vertical
        config.contentInsetsReference = .none
        
        return UICollectionViewCompositionalLayout(section: section, configuration: config)
    }
}
