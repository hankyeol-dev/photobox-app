//
//  ProfileChangeButton.swift
//  photobox
//
//  Created by 강한결 on 7/22/24.
//

import UIKit

final class ProfileImageChangeButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configuration = .filled()
        configuration?.cornerStyle = .capsule
        configuration?.image = UIImage(systemName: "camera.fill")
        configuration?.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 12)
        configuration?.imagePlacement = .all
        configuration?.baseBackgroundColor = .primary
        configuration?.baseForegroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
