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
    private let likeCountView = CapsuleItem()
    
    let likeButton = UIButton()
    
    
    override func setSubviews() {
        super.setSubviews()
        [cardImage, likeCountView, likeButton].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func setLayout() {
        super.setLayout()
        let guide = contentView.safeAreaLayoutGuide
        cardImage.snp.makeConstraints { make in
            make.edges.equalTo(guide)
        }
        likeCountView.snp.makeConstraints { make in
            make.leading.bottom.equalTo(guide).inset(12)
            make.height.equalTo(32)
            make.width.equalTo(100)
        }
        likeButton.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(guide).inset(12)
            make.size.equalTo(32)
        }

    }
    
    override func setUI() {
        super.setUI()
        
        cardImage.contentMode = .scaleToFill
        likeButton.setImage(.likeCircleInactive, for: .normal)
        likeButton.addTarget(self, action: #selector(onTouchLikeButton), for: .touchUpInside)
    }
    
    /// 받아야 하는 데이터
    /// 이미지, 좋아요 카운트, 좋아요 여부
    func setUIWithData(for data: Photo) {
        likeCountView.bind(
            backgroundColor: .gray_lg,
            image: UIImage(systemName: "star.fill")!.withTintColor(.systemYellow, renderingMode: .alwaysTemplate),
            text: String(data.likes.formatted())
        )
        
        if let imageUrl = data.urls.regular {
            cardImage.kf.setImage(with: URL(string: imageUrl))
        }
    }
    
    func bindLikeButton() {
        likeButton.setImage(.likeCircle, for: .normal)
        
    }
    
    @objc
    func onTouchLikeButton() {
        likeButtonHandler?()
    }
}
