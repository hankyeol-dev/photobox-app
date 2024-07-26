//
//  TopicView.swift
//  photobox
//
//  Created by 강한결 on 7/24/24.
//

import UIKit
import SnapKit

final class TopicView: BaseView, MainViewProtocol {
    let userImage = UIImageView()
    private let largeTitle = UILabel()
    let topicTable = UITableView()
    
    override func setSubviews() {
        super.setSubviews()
        [userImage, largeTitle, topicTable].forEach {
            self.addSubview($0)
        }
    }
    
    override func setLayout() {
        super.setLayout()
        let guide = self.safeAreaLayoutGuide
        
        userImage.snp.makeConstraints { make in
            make.top.equalTo(guide).offset(-36)
            make.trailing.equalTo(guide).inset(24)
            make.size.equalTo(32)
        }
        
        largeTitle.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(guide).inset(16)
            make.height.equalTo(36)
        }
        topicTable.snp.makeConstraints { make in
            make.top.equalTo(largeTitle.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(guide).inset(16)
            make.bottom.equalTo(guide)
        }
    }
    
    override func setUI() {
        super.setUI()
        
        largeTitle.font = .boldSystemFont(ofSize: 28)
        largeTitle.text = "토픽별 이미지"
        
        userImage.layer.borderColor = UIColor.gray_lg.cgColor
        userImage.layer.borderWidth = 1
        userImage.clipsToBounds = true
        userImage.layer.cornerRadius = 16
        userImage.contentMode = .scaleAspectFit
    }
    
    func setUserImage(for imageName: String) {
        userImage.image = UIImage(named: imageName)
        userImage.isUserInteractionEnabled = true
    }
}

