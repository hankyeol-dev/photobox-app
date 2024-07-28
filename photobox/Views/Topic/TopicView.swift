//
//  TopicView.swift
//  photobox
//
//  Created by 강한결 on 7/24/24.
//

import UIKit
import SnapKit

final class TopicView: BaseView, MainViewProtocol {
    
    private let largeTitle = UILabel()
    let topicTable = UITableView()
    
    override func setSubviews() {
        super.setSubviews()
        [largeTitle, topicTable].forEach {
            self.addSubview($0)
        }
    }
    
    override func setLayout() {
        super.setLayout()
        let guide = self.safeAreaLayoutGuide
        
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
        largeTitle.text = Text.Titles.TOPIC_MAIN_TITLE.rawValue
    }
}

