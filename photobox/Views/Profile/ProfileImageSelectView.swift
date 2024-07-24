//
//  ProfileImageSelectView.swift
//  photobox
//
//  Created by 강한결 on 7/23/24.
//

import UIKit
import SnapKit

final class ProfileImageSelectView: BaseView, MainViewProtocol {
    private let profileBackView = UIView()
    let profileImage = ProfileImage(for: UIImage.profile0)
    lazy var profileImageCollection = UICollectionView(frame: .zero, collectionViewLayout: setCollectionLayout())
    
    override func setSubviews() {
        super.setSubviews()
        
        [profileBackView, profileImageCollection].forEach {
            self.addSubview($0)
        }
        profileBackView.addSubview(profileImage)
    }
    
    override func setLayout() {
        super.setLayout()
        
        profileBackView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
            make.height.equalTo(150)
        }
        
        profileImage.snp.makeConstraints { make in
            make.center.equalTo(profileBackView.snp.center)
            make.size.equalTo(100)
        }
        
        profileImageCollection.snp.makeConstraints { make in
            make.top.equalTo(profileBackView.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(240)
        }
    }
    
    override func setUI() {
        super.setUI()
        
        profileBackView.backgroundColor = .systemBackground
        profileBackView.layer.shadowColor = UIColor.gray_md.cgColor
        profileBackView.layer.shadowOpacity = 0.2
        profileBackView.layer.shadowRadius = 1
        profileBackView.layer.shadowOffset = CGSize(width: profileBackView.frame.size.width, height: 1)
        profileBackView.layer.shadowPath = nil
        
        profileImage.setBorder(for: true)
        profileImageCollection.isScrollEnabled = false
    }
    
    private func setCollectionLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/4), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(80))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
