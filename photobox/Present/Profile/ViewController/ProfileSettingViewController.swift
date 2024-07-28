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
        
        if !viewModel.isInitial {
            mainView.showWithdrawButton()
        } else {
            mainView.showConfirmButton()
        }
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
                mainView.profileNicknameField.text = output.currentNickname
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
                    self.mainView.confirmButton.isCantTouched()
                case .isLowerOrOverCount:
                    self.mainView.profileNicknameValidationLabel.isLowerThanTwoOrOverTen()
                    self.mainView.confirmButton.isCantTouched()
                case .isContainNumber:
                    self.mainView.profileNicknameValidationLabel.isContainsNumber()
                    self.mainView.confirmButton.isCantTouched()
                case .isContainSpecialLetter:
                    self.mainView.profileNicknameValidationLabel.isContainsSpecialLetter()
                    self.mainView.confirmButton.isCantTouched()
                }
            }
        }
        viewModel.profileCreationOutput.bindingWithoutInitCall { [weak self] output in
            guard let self else { return }
            if output {
                self.mainView.confirmButton.isAbled()
                self.navigationItem.rightBarButtonItem?.tintColor = .primary
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            } else {
                self.mainView.confirmButton.isCantTouched()
                self.navigationItem.rightBarButtonItem?.tintColor = .gray_lg
                self.navigationItem.rightBarButtonItem?.isEnabled = false
            }
        }
        viewModel.saveProfileOutput.bindingWithoutInitCall { [weak self] _ in
            guard let self else { return }
            
            if self.viewModel.isInitial {
                let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                let sceneDelegate = scene?.delegate as? SceneDelegate
                
                let window = sceneDelegate?.window
                
                window?.rootViewController = MainTabBarController()
                window?.makeKeyAndVisible()
            } else {
                navigationController?.popViewController(animated: true)
            }
        }
    }
    
    override func setNavigation() {
        super.setNavigation()
        navigationItem.title = "프로필 생성"
        navigationItem.leftBarButtonItem = genLeftGoBackButton(target: self, action: #selector(goBack))
        
        if !viewModel.isInitial {
            let rightSaveButton = UIBarButtonItem(
                title: "저장",
                style: .plain,
                target: self,
                action: #selector(saveUserProfile)
            )

            navigationItem.setRightBarButton(rightSaveButton, animated: true)
        }
    }
   
}

extension ProfileSettingViewController {
    private func bindingAction() {
        mainView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(fieldEndEditing)))
        mainView.profileChangeButton.addTarget(self, action: #selector(goToProfileImageSelect), for: .touchUpInside)
        mainView.confirmButton.addTarget(self, action: #selector(saveUserProfile), for: .touchUpInside)
        mainView.withdrawButton.addTarget(self, action: #selector(deleteUserProfile), for: .touchUpInside)
    }
    
    @objc
    private func bindingMbtiButtonAction(_ sender: UIButton) {
         viewModel.mbtiButtonTouchInput.value = (sender.tag, sender.configuration?.title)
    }
    
    @objc
    private func fieldEndEditing() {
        mainView.profileNicknameField.fieldOutFocus()
        mainView.endEditing(true)
    }
    
    @objc
    private func goToProfileImageSelect() {
        if let currentImage = viewModel.currentProfileImage {
            let vm = ProfileImageSettingViewModel()
            vm.currentImage = currentImage
            vm.sender = { image in
                self.viewModel.currentProfileImage = image
            }
            let vc = ProfileImageSettingViewController(
                viewModel: vm, mainView: ProfileImageSelectView()
            )
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc
    private func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func saveUserProfile() {
        if viewModel.profileCreationOutput.value {
            viewModel.saveUserProfileInput.value = ()
        }
    }

    @objc
    private func deleteUserProfile() {
        let alert = UIAlertController(
            title: "프로필 삭제가 정말인가요? 🥹", 
            message: "정말 모든 데이터를 삭제하고\n 좋아요한 사진을 다 날리고\n 프로필을 삭제하실건가요?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(
            title: "정말 삭제하기",
            style: .destructive,
            handler: { [weak self] action in
                guard let self else { return }
                self.viewModel.deleteUserProfileInput.value = ()
                
                let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                let sceneDelegate = scene?.delegate as? SceneDelegate
                
                let window = sceneDelegate?.window
                let vc = UINavigationController(rootViewController: OnboardingViewController(viewModel: OnboardingViewModel(), mainView: OnboardingView()))
                
                window?.rootViewController = vc
                window?.makeKeyAndVisible()
            })
        )
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        present(alert, animated: true)
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
