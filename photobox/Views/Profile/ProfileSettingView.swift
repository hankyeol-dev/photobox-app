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
    let profileNicknameField = ProfileNicknameField("멋진 닉네임을 만들어보세요.")
    let profileNicknameValidationLabel = ProfileNicknameValidationLabel()
    let mbtiBox = BoxWithTitle(for: "MBTI 설정하기")
    let confirmButton = CircleButton(for: "완료")
    
    override func setSubviews() {
        super.setSubviews()
        
        [profileBackView, profileNicknameField, profileNicknameValidationLabel, mbtiBox, confirmButton].forEach {
            self.addSubview($0)
        }
        [profileImage, profileChangeButton].forEach {
            profileBackView.addSubview($0)
        }
    }
    
    override func setLayout() {
        super.setLayout()
        
        profileBackView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
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
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(60)
        }
        
        profileNicknameValidationLabel.snp.makeConstraints { make in
            make.top.equalTo(profileNicknameField.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(20)
        }
        
        mbtiBox.snp.makeConstraints { make in
            make.top.equalTo(profileNicknameValidationLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
            make.height.equalTo(140)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(60)
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
        
        confirmButton.isCantTouched()
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
    
    func hideConfirmButton() {
        confirmButton.isHidden = true
    }
}
