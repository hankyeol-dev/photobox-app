//
//  DetailOwnerView.swift
//  photobox
//
//  Created by 강한결 on 7/27/24.
//

import UIKit
import SnapKit
import Kingfisher

final class DetailOwnerView: BaseView {
    private let ownerProfile = UIImageView()
    private let ownerInfoStack = UIStackView()
    private let ownerNameLabel = UILabel()
    private let detailCreateDateLabel = UILabel()
    let likeButton = UIButton()
    
    override func setSubviews() {
        super.setSubviews()
        
        [ownerProfile, ownerInfoStack, likeButton].forEach {
            self.addSubview($0)
        }
        
        [ownerNameLabel, detailCreateDateLabel].forEach {
            ownerInfoStack.addArrangedSubview($0)
        }
    }
    
    override func setLayout() {
        super.setLayout()
        
        let guide = self.safeAreaLayoutGuide
        
        ownerProfile.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.centerY)
            make.leading.equalTo(guide).inset(16)
            make.size.equalTo(32)
        }
        
        likeButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.centerY)
            make.trailing.equalTo(guide).inset(16)
            make.size.equalTo(32)
        }
        
        ownerInfoStack.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.centerY)
            make.leading.equalTo(ownerProfile.snp.trailing).offset(12)
            make.trailing.equalTo(likeButton.snp.leading).offset(-12)
        }
    }
    
    override func setUI() {
        super.setUI()
        
        backgroundColor = .systemBackground
        
        ownerProfile.layer.cornerRadius = 16
        ownerProfile.clipsToBounds = true
        ownerProfile.contentMode = .scaleAspectFill
        
        ownerInfoStack.axis = .vertical
        ownerInfoStack.alignment = .leading
        ownerInfoStack.distribution = .fillEqually
        
        ownerNameLabel.font = .systemFont(ofSize: 14)
        detailCreateDateLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        
        likeButton.layer.cornerRadius = 16
        likeButton.clipsToBounds = true
    }
    
    func bindView(for data: DetailOutput) {
        if let small = data.photo.user.profile_image.small {
            ownerProfile.kf.setImage(with: URL(string: small))
        }
        ownerNameLabel.text = data.photo.user.username
        detailCreateDateLabel.text = data.photo.formattedDate
        
        if data.isLiked {
            isLikedImage()
        } else {
            isNotLikedImage()
        }
    }
    
    private func isLikedImage() {
        likeButton.setImage(.like, for: .normal)
        likeButton.backgroundColor = .none
    }
    
    private func isNotLikedImage() {
        likeButton.setImage(.likeInactive, for: .normal)
        likeButton.backgroundColor = .gray_sm
    }
}
