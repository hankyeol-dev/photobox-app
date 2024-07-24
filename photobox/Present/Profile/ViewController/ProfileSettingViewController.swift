//
//  ProfileSettingViewController.swift
//  photobox
//
//  Created by 강한결 on 7/22/24.
//

import UIKit

final class ProfileSettingViewController: BaseViewController<ProfileSettingViewModel, ProfileSettingView> {

    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTextField()
        bindingAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func bindData() {
        super.bindData()
        
        viewModel.didLoadInput.value = ()
        viewModel.didLoadOutput.binding { [weak self] output in
            guard let self else { return }
            if let output, output.mbtiButtons.count != 0 {
                mainView.profileImage.setImage(for: output.currentImage)
                mainView.generateMBTI(by: output.mbtiButtons, target: self, action: #selector(bindingMbtiButtonAction))
            }
        }
        viewModel.nicknameOutput.bindingWithoutInitCall { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                self.mainView.profileNicknameValidationLabel.isSuccess(success)
            case .failure(let failure):
                switch failure {
                case .isEmpty:
                    self.mainView.profileNicknameValidationLabel.isEmpty()
                case .isLowerOrOverCount:
                    self.mainView.profileNicknameValidationLabel.isLowerThanTwoOrOverTen()
                case .isContainNumber:
                    self.mainView.profileNicknameValidationLabel.isContainsNumber()
                case .isContainSpecialLetter:
                    self.mainView.profileNicknameValidationLabel.isContainsSpecialLetter()
                }
            }
        }
    }
    
    override func setNavigation() {
        super.setNavigation()
        navigationItem.title = "프로필 생성"
        navigationItem.leftBarButtonItem = genLeftGoBackButton(target: self, action: #selector(goBack))
    }
   
}

extension ProfileSettingViewController {
    private func bindingAction() {
        mainView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(fieldEndEditing)))
        mainView.profileChangeButton.addTarget(self, action: #selector(goToProfileImageSelect), for: .touchUpInside)
    }
    
    @objc
    func bindingMbtiButtonAction(_ sender: UIButton) {
         viewModel.mbtiButtonTouchInput.value = (sender.tag, sender.configuration?.title)
    }
    
    @objc
    func fieldEndEditing() {
        mainView.profileNicknameField.fieldOutFocus()
        mainView.endEditing(true)
    }
    
    @objc
    func goToProfileImageSelect() {
        viewModel.profileImageSelectInput.value = ()
    }
    
    @objc
    func goBack() {
        viewModel.goBackInput.value = ()
    }
}

extension ProfileSettingViewController: UITextFieldDelegate {
    private func setTextField() {
        mainView.profileNicknameField.delegate = self
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        mainView.profileNicknameField.fieldOnFocus()
        mainView.profileNicknameValidationLabel.startEditing()
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        viewModel.nicknameInput.value = textField.text
    }
}
