//
//  DeatilView.swift
//  photobox
//
//  Created by 강한결 on 7/27/24.
//

import UIKit
import SnapKit
import Kingfisher

final class DetailView: BaseView, MainViewProtocol {
    let detailOwnerView = DetailOwnerView()
    let detailImage = UIImageView()
    let detailInfoBox = BoxWithTitle(for: "정보")
    
    override func setSubviews() {
        super.setSubviews()
        
        [detailOwnerView, detailImage, detailInfoBox].forEach {
            self.addSubview($0)
        }
    }
    
    override func setLayout() {
        super.setLayout()
        
        let guide = self.safeAreaLayoutGuide
        
        detailOwnerView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(guide)
            make.height.equalTo(56)
        }
        
        detailImage.snp.makeConstraints { make in
            make.top.equalTo(detailOwnerView.snp.bottom)
            make.horizontalEdges.equalTo(guide)
            make.height.equalTo(200)
        }
        
        detailInfoBox.snp.makeConstraints { make in
            make.top.equalTo(detailImage.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(guide)
        }
    }
    
    override func setUI() {
        super.setUI()
        
        detailImage.contentMode = .scaleToFill
    }
    
    func bindView(for photo: Photo) {
        if let url = photo.urls.regular {
            detailImage.kf.setImage(with: URL(string: url))
        }
        
        let infoStack = UIStackView()
        infoStack.axis = .vertical
        infoStack.distribution = .fillEqually
        
        if let views = photo.views, let downloads = photo.downloads {
            let infoDatas = [
                ("크기",  String(photo.width) + "x" + String(photo.height)),
                ("조회수", String(views.formatted())),
                ("다운로드 수", String(downloads.formatted()))
            ]
            
            infoDatas.forEach {
                let item = DetailInfoItem()
                item.bindView(for: $0)
                item.snp.makeConstraints { make in
                    make.height.equalTo(24)
                }
                infoStack.addArrangedSubview(item)
            }
            
            detailInfoBox.setUpContentsView(by: infoStack)
        }
        
        
    }
}
