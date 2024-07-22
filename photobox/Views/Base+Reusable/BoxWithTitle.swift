//
//  BoxWithTitle.swift
//  photobox
//
//  Created by 강한결 on 7/22/24.
//

import UIKit
import SnapKit

final class BoxWithTitle: BaseView {
    private let titleLabel = UILabel()
    private let contentsView = UIView()
    
    convenience init(for title: String) {
        self.init(frame: .zero)
        
        titleLabel.text = title
    }
    
    override func setSubviews() {
        super.setSubviews()
        
        self.addSubview(titleLabel)
        self.addSubview(contentsView)
    }
    
    override func setLayout() {
        super.setLayout()
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.leading.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(24)
            make.width.equalTo(90)
        }
        
        contentsView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(self.safeAreaLayoutGuide).inset(8)
            make.leading.equalTo(titleLabel.snp.trailing).offset(4)
            make.trailing.equalTo(self.safeAreaLayoutGuide).inset(16)
        }
    }
    
    override func setUI() {
        super.setUI()
        backgroundColor = .systemBackground
        titleLabel.font = .smBold
    }
    
    func setUpContentsView(by someView: UIView) {
        contentsView.addSubview(someView)
        someView.snp.makeConstraints { make in
            make.edges.equalTo(contentsView.safeAreaLayoutGuide)
        }
    }
}
