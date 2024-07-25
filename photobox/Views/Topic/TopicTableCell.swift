//
//  TopicTableCell.swift
//  photobox
//
//  Created by 강한결 on 7/25/24.
//

import UIKit
import SnapKit

final class TopicTableCell: BaseTableCell {
    private let sectionTitle = UILabel()
    lazy var sectionCollection = UICollectionView(frame: .zero, collectionViewLayout: createSingleHorizontalSection())
    
    override func setSubviews() {
        [sectionTitle, sectionCollection].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func setLayout() {
        let guide = contentView.safeAreaLayoutGuide
        sectionTitle.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(guide)
            make.top.equalTo(guide).inset(8)
            make.height.equalTo(28)
        }
        sectionCollection.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(guide)
            make.top.equalTo(sectionTitle.snp.bottom).offset(4)
            make.bottom.equalTo(guide).inset(8)
        }
    }
    
    override func setUI() {
        super.setUI()
        
        sectionTitle.font = .boldSystemFont(ofSize: 20)
    }
    
    private func createSingleHorizontalSection() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 8)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.6), heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 4, leading: 0, bottom: 24, trailing: 0)
        section.interGroupSpacing = 8
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func setSectionTitle(for title: String) {
        sectionTitle.text = title
    }
}
