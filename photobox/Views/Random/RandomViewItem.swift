//
//  RandomViewItem.swift
//  photobox
//
//  Created by 강한결 on 7/28/24.
//

import UIKit
import SnapKit
import Kingfisher

final class RandomViewItem: BaseCollectionItem {
    
    private let back = UIImageView()
    let owner = DetailOwnerView()
    private let countLabel = UILabel()
    
    override func setSubviews() {
        super.setSubviews()
        
        [back, owner, countLabel].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func setLayout() {
        super.setLayout()
        
        back.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
        }
        
        owner.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide)
            make.height.equalTo(56)
        }
        
        countLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(80)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(28)
            make.width.equalTo(64)
        }
    }
    
    override func setUI() {
        super.setUI()
        
        back.contentMode = .scaleAspectFill
        owner.backgroundColor = .white.withAlphaComponent(0.2)
        countLabel.backgroundColor = .gray_lg.withAlphaComponent(0.5)
        countLabel.textAlignment = .center
        countLabel.textColor = .gray_sm
        countLabel.font = .systemFont(ofSize: 13, weight: .regular)
        countLabel.layer.cornerRadius = 12
        countLabel.clipsToBounds = true
    }
    
    func setback(totalPage: Int,  page: Int, data: DetailOutput) {
        if let url = data.photo.urls.regular {
            back.kf.setImage(with: URL(string: url))
        }
        owner.bindView(for: data)
        countLabel.text = "\(page + 1) / \(totalPage)"
    }
}
