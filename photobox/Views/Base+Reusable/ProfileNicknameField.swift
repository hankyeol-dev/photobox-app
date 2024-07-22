//
//  ProfileNicknameField.swift
//  photobox
//
//  Created by 강한결 on 7/22/24.
//

import UIKit
import SnapKit

class ProfileNicknameField: UITextField {
    private let underline = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(_ placeholderText: String = "") {
        self.init(frame: .zero)
        
        backgroundColor = .systemBackground
        textColor = .black
        tintColor = .primary
        placeholder = placeholderText
        leftView = UIView(frame: CGRect(x: 0, y: 4, width: 4, height: self.frame.height))
        leftViewMode = .always

        configureUnderline()
    }
    
    func configureUnderline() {
        addSubview(underline)
        
        underline.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        underline.layer.borderColor = UIColor.gray_md.cgColor
        underline.layer.borderWidth = 1
    }
    
    func fieldOnFocus() {
        underline.layer.borderColor = UIColor.primary.cgColor
    }
    
    func fieldOutFocus() {
        underline.layer.borderColor = UIColor.gray_md.cgColor
    }
    
    func fieldOnError() {
        underline.layer.borderColor = UIColor.error.cgColor
    }
    
}
