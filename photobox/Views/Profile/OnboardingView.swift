//
//  OnboardingView.swift
//  photobox
//
//  Created by 강한결 on 7/23/24.
//

import UIKit
import SnapKit

final class OnboardingView: BaseView, MainViewProtocol {
    private let titleImage = UIImageView(image: UIImage.launchLetter)
    private let polarImage = UIImageView(image: UIImage.launch)
    private let nameLabel = UILabel()
    let startButton = CircleButton(for: Text.Buttons.ONBOARDING_START.rawValue)
    
    override func setSubviews() {
        super.setSubviews()
        [titleImage, polarImage, nameLabel, startButton].forEach { self.addSubview($0) }
    }
    
    override func setLayout() {
        super.setLayout()
        
        let guide = self.safeAreaLayoutGuide
        
        titleImage.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(guide).inset(32)
            make.top.equalTo(guide).inset(16)
            make.height.equalTo(160)
        }
        
        polarImage.snp.makeConstraints { make in
            make.top.equalTo(titleImage.snp.bottom).offset(32)
            make.horizontalEdges.equalTo(guide).inset(32)
            make.height.equalTo(240)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(polarImage.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(guide).inset(32)
            make.centerX.equalToSuperview()
            make.height.equalTo(32)
        }
        
        startButton.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(guide).inset(32)
            make.height.equalTo(60)
        }
    }
    
    override func setUI() {
        titleImage.contentMode = .scaleAspectFit
        polarImage.contentMode = .scaleAspectFit
        nameLabel.text = "강한결"
        nameLabel.textAlignment = .center
        nameLabel.font = .systemFont(ofSize: 24, weight: .medium)
        startButton.isAbled()
    }
}
