//
//  ProfileImage.swift
//  photobox
//
//  Created by 강한결 on 7/22/24.
//

import UIKit

enum ViewState {
    case modify
    case noneModify
}

final class ProfileImage: UIImageView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(for selectedImage: UIImage) {
        self.init(frame: .zero)
        
        image = selectedImage
        contentMode = .scaleToFill
        layer.cornerRadius = 50
        clipsToBounds = true
        backgroundColor = .systemBackground
    }
    
    func setImage(for image: ProfileImages) {
        self.image = UIImage(named: image.rawValue)
    }
    
    func setImage(for imageName: String) {
        self.image = UIImage(named: imageName)
    }
    
    func setBorder(for isSelected: Bool) {
        if isSelected {
            layer.borderColor = UIColor.primary.cgColor
            layer.borderWidth = 3
        } else {
            layer.borderColor = UIColor.gray_md.withAlphaComponent(0.5).cgColor
            layer.borderWidth = 1
            alpha = 0.5
        }
    }
    
    func setCorner(by size: Double) {
        layer.cornerRadius = size / 2
    }
}
