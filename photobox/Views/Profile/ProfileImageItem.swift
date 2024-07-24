//
//  ProfileImageItem.swift
//  photobox
//
//  Created by 강한결 on 7/23/24.
//

import UIKit
import SnapKit

final class ProfileImageItem: BaseCollectionItem {
    private let profileImage = UIImageView()
    
    override func setSubviews() {
        super.setSubviews()
        
        contentView.addSubview(profileImage)
    }
    
    override func setLayout() {
        super.setLayout()
        
        profileImage.snp.makeConstraints { make in
            make.size.equalTo(70)
            make.center.equalTo(contentView.snp.center)
        }
    }
    
    override func setUI() {
        super.setUI()
        contentView.backgroundColor = .white
        
        profileImage.layer.cornerRadius = 35
        profileImage.layer.borderWidth = 1
        profileImage.layer.borderColor = UIColor.gray_md.cgColor
        profileImage.clipsToBounds = true
        profileImage.contentMode = .scaleAspectFit
    }
    
    func setUpImage(for imageName: ProfileImages, by isSelected: Bool) {
        profileImage.image = UIImage(named: imageName.rawValue)
        
        if isSelected {
            profileImage.alpha = 1
            profileImage.tintColor = .primary
            profileImage.layer.borderWidth = 3
            profileImage.layer.borderColor = UIColor.primary.cgColor
        } else {
            profileImage.alpha = 0.5
            profileImage.tintColor = .gray_md
            profileImage.layer.borderColor = UIColor.gray_sm.cgColor
        }
    }
    
}
