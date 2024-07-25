//
//  CapsuleItem.swift
//  photobox
//
//  Created by 강한결 on 7/25/24.
//

import UIKit
import SnapKit

final class CapsuleItem: BaseView {
    private var image = UIImageView()
    private let label = UILabel()
    
    override func setSubviews() {
        super.setSubviews()
        
        [image, label].forEach { self.addSubview($0) }
    }
    
    override func setLayout() {
        super.setLayout()
        
        image.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.centerY)
            make.leading.equalTo(self.safeAreaLayoutGuide).inset(12)
            make.size.equalTo(12)
        }
        
        label.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.centerY)
            make.leading.equalTo(image.snp.trailing).offset(8)
            make.trailing.equalTo(self.safeAreaLayoutGuide).inset(12)
        }
    }
    
    override func setUI() {
        super.setUI()
        self.layer.cornerRadius = 16
        image.tintColor = .systemYellow
        label.font = .systemFont(ofSize: 13)
        label.textColor = .gray_sm
    }
    
    func bind(backgroundColor: UIColor, image: UIImage, text: String) {
        self.backgroundColor = backgroundColor
        self.image.image = image
        self.label.text = text
    }
}
