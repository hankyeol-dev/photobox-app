//
//  SearchColorFilterItem.swift
//  photobox
//
//  Created by 강한결 on 7/29/24.
//

import UIKit
import SnapKit

final class SearchColorFilterItem: BaseCollectionItem {
    let colorBack = UIView()
    let colorImage = UIImageView()
    let colorText = UILabel()
    let colorButton = UIButton()
    
    override func setSubviews() {
        super.setSubviews()
        contentView.addSubview(colorBack)
        colorBack.addSubview(colorImage)
        colorBack.addSubview(colorText)
        colorBack.addSubview(colorButton)
    }
    
    override func setLayout() {
        super.setLayout()
        colorBack.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide).inset(2)
        }
        colorImage.snp.makeConstraints { make in
            make.leading.equalTo(colorBack.safeAreaLayoutGuide).inset(8)
            make.centerY.equalTo(colorBack.snp.centerY)
            make.size.equalTo(16)
        }
        colorText.snp.makeConstraints { make in
            make.leading.equalTo(colorImage.snp.trailing).offset(8)
            make.trailing.equalTo(colorBack.safeAreaLayoutGuide).inset(8)
            make.centerY.equalTo(colorBack.snp.centerY)
        }
        colorButton.snp.makeConstraints { make in
            make.edges.equalTo(colorBack.safeAreaLayoutGuide)
        }
    }
    
    override func setUI() {
        super.setUI()
        
        colorBack.layer.cornerRadius = 16
        colorBack.layer.borderWidth = 1
        colorBack.clipsToBounds = true
        
        colorImage.layer.cornerRadius = 8
        
        colorText.font = .systemFont(ofSize: 13)
        colorText.textAlignment = .center
        colorBack.isUserInteractionEnabled = true
    }
    
    func bindView(for data: ColorButtonOutput) {
        colorImage.backgroundColor = data.color.byUIColor
        colorText.text = data.color.byKorean
        
        if data.isSelected {
            colorBack.backgroundColor = .primary
            colorBack.layer.borderColor = UIColor.primary.cgColor
            colorText.textColor = .white
        } else {
            colorBack.backgroundColor = .systemBackground
            colorBack.layer.borderColor = UIColor.gray_lg.cgColor
            colorText.textColor = .gray_lg
        }
    }
}
