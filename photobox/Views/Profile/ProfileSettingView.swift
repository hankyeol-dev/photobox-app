//
//  ProfileView.swift
//  photobox
//
//  Created by 강한결 on 7/22/24.
//

import UIKit
import SnapKit

final class ProfileSettingView: BaseView, MainViewProtocol {
    private let profileBackView = UIView()
    let profileImage = ProfileImage(for: UIImage.profile0)
    let profileChangeButton = ProfileImageChangeButton()
    let profileNicknameField = ProfileNicknameField(Text.Placeholder.NICKNAMEFIELD.rawValue)
    let profileNicknameValidationLabel = ProfileNicknameValidationLabel()
    let mbtiBox = BoxWithTitle(for: Text.Titles.MBTIBOX.rawValue)
    let confirmButton = CircleButton(for: Text.Buttons.PROFILE_CONFIRM.rawValue)
    let withdrawButton = UIButton()
    
    override func setSubviews() {
        super.setSubviews()
        
        [profileBackView, profileNicknameField, profileNicknameValidationLabel, mbtiBox, confirmButton, withdrawButton].forEach {
            self.addSubview($0)
        }
        [profileImage, profileChangeButton].forEach {
            profileBackView.addSubview($0)
        }
    }
    
    override func setLayout() {
        super.setLayout()
        
        let guide = self.safeAreaLayoutGuide
        
        profileBackView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(guide)
            make.height.equalTo(150)
        }
        
        profileImage.snp.makeConstraints { make in
            make.center.equalTo(profileBackView.snp.center)
            make.size.equalTo(100)
        }
        
        profileChangeButton.snp.makeConstraints { make in
            make.centerX.equalTo(profileBackView.snp.centerX).offset(40)
            make.bottom.equalTo(profileImage.snp.bottom)
            make.size.equalTo(32)
        }
        
        profileNicknameField.snp.makeConstraints { make in
            make.top.equalTo(profileBackView.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(guide).inset(16)
            make.height.equalTo(60)
        }
        
        profileNicknameValidationLabel.snp.makeConstraints { make in
            make.top.equalTo(profileNicknameField.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(guide).inset(20)
        }
        
        mbtiBox.snp.makeConstraints { make in
            make.top.equalTo(profileNicknameValidationLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(guide)
            make.height.equalTo(140)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(guide).inset(16)
            make.height.equalTo(60)
        }
        
        withdrawButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(guide).inset(16)
            make.bottom.equalTo(guide).inset(44)
            make.height.equalTo(44)
        }
    }
    
    override func setUI() {
        super.setUI()
        
        profileBackView.backgroundColor = .systemBackground
        profileBackView.layer.shadowColor = UIColor.gray_md.cgColor
        profileBackView.layer.shadowOpacity = 0.2
        profileBackView.layer.shadowRadius = 1
        profileBackView.layer.shadowOffset = CGSize(width: profileBackView.frame.size.width, height: 1)
        profileBackView.layer.shadowPath = nil
        
        profileImage.setBorder(for: true)
        profileImage.isUserInteractionEnabled = true
        
        confirmButton.isCantTouched()
        setWithdrawButton()
    }
    
    func generateMBTI(by mbtiArray: [[MbtiButton]], target: Any?, action: Selector) {
        let totalStack = UIStackView()
        totalStack.alignment = .center
        totalStack.distribution = .fillEqually
                
        let mbtiViews = mbtiArray.map { $0.map {
            let btn = CircleButton(for: $0.value)
            btn.isSelected = $0.isSelected
            return btn
        } }
        
        mbtiViews.enumerated().forEach { idx, buttons in
            let stack = UIStackView()
            buttons.forEach {
                $0.tag = idx
                $0.snp.makeConstraints { make in
                    make.size.equalTo(50)
                }
                $0.addTarget(target, action: action, for: .touchUpInside)
                stack.addArrangedSubview($0)
            }
            stack.distribution = .fillEqually
            stack.spacing = 8
            stack.alignment = .center
            stack.axis = .vertical
            totalStack.addArrangedSubview(stack)
        }
        
        mbtiBox.setUpContentsView(by: totalStack)
    }
    
    func showConfirmButton() {
        confirmButton.isHidden = false
        withdrawButton.isHidden = true
    }
    
    func showWithdrawButton() {
        confirmButton.isHidden = true
        withdrawButton.isHidden = false
    }
    
    private func setWithdrawButton() {
        withdrawButton.configuration = .borderless()
        withdrawButton.configuration?.baseForegroundColor = .error
        var titleContainer = AttributeContainer()
        titleContainer.font = UIFont.boldSystemFont(ofSize: 14)
        withdrawButton.configuration?.attributedTitle = AttributedString(
            Text.Buttons.PROFILE_DELETE.rawValue, attributes: titleContainer)
    }
}
