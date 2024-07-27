//
//  DetailInfoItem.swift
//  photobox
//
//  Created by 강한결 on 7/27/24.
//

import UIKit
import SnapKit

final class DetailInfoItem: BaseView {
    private let titleLabel = UILabel()
    private let infoLabel = UILabel()
    
    override func setSubviews() {
        super.setSubviews()
        
        [titleLabel, infoLabel].forEach {
            self.addSubview($0)
        }
    }
    
    override func setLayout() {
        super.setLayout()
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.centerY)
            make.leading.equalTo(self.safeAreaLayoutGuide).inset(4)
            make.width.equalTo(100)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.centerY)
            make.trailing.equalTo(self.safeAreaLayoutGuide).inset(4)
            make.leading.equalTo(titleLabel.snp.trailing).offset(8)
        }
    }
    
    override func setUI() {
        super.setUI()
        
        titleLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        titleLabel.textAlignment = .left
        
        infoLabel.font = .systemFont(ofSize: 13, weight: .regular)
        infoLabel.textAlignment = .right
    }
    
    func bindView(for data: (String, String)) {
        titleLabel.text = data.0
        infoLabel.text = data.1
    }
}
