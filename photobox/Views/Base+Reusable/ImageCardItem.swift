//
//  ImageCardItem.swift
//  photobox
//
//  Created by 강한결 on 7/25/24.
//

import UIKit
import Kingfisher

final class ImageCardItem: BaseCollectionItem {
    var likeButtonHandler: (() -> Void)?
    
    private let cardImage = UIImageView()
    private let likeCountView = LikeCountView()
    
    let likeButton = UIButton()
    
    
    override func setSubviews() {
        super.setSubviews()
        [cardImage, likeButton].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func setLayout() {
        super.setLayout()
        let guide = contentView.safeAreaLayoutGuide
        cardImage.snp.makeConstraints { make in
            make.edges.equalTo(guide)
        }
        
        likeButton.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(guide).inset(12)
            make.size.equalTo(32)
        }

    }
    
    override func setUI() {
        super.setUI()
        
        cardImage.contentMode = .scaleToFill
        likeButton.addTarget(self, action: #selector(onTouchLikeButton), for: .touchUpInside)
    }
    
    /// 받아야 하는 데이터
    /// 이미지, 좋아요 카운트, 좋아요 여부
    func setUIWithData(for data: SearchedPhotoOutput, showLikeCount: Bool) {
        
        if showLikeCount {
            contentView.addSubview(likeCountView)
            
            likeCountView.snp.makeConstraints { make in
                make.leading.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(12)
                make.height.equalTo(32)
                make.width.equalTo(100)
            }
            
            likeCountView.bind(
                backgroundColor: .gray_lg,
                image: UIImage(systemName: "star.fill")!,
                text: String(data.likes.formatted())
            )
        }
        
        cardImage.kf.setImage(with: URL(string: data.url))
        
        if data.isLiked {
            isLikedImage()
        } else {
            isNotLikedImage()
        }
    }
    
    func setUIWithData(for data: SearchedPhotoOutput) {
        cardImage.image = UIImage(contentsOfFile: data.url)
        
        if data.isLiked {
            isLikedImage()
        } else {
            isNotLikedImage()
        }
    }
    
    func isRoundedUI() {
        cardImage.layer.cornerRadius = 12
        cardImage.clipsToBounds = true
    }
    
    private func isLikedImage() {
        likeButton.setImage(.likeCircle, for: .normal)
    }
    
    private func isNotLikedImage() {
        likeButton.setImage(.likeCircleInactive, for: .normal)
    }
    
    @objc
    func onTouchLikeButton() {
        likeButtonHandler?()
    }
}
