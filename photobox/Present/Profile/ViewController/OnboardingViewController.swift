//
//  StartViewController.swift
//  photobox
//
//  Created by 강한결 on 7/23/24.
//

import UIKit

final class OnboardingViewController: BaseViewController<OnboardingViewModel, OnboardingView> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        self.view = mainView
    }
    
    override func bindAction() {
        super.bindAction()
        mainView.startButton.addTarget(self, action: #selector(goToProfileSettingVC), for: .touchUpInside)
    }
    
    @objc
    func goToProfileSettingVC() {
        let vc = ProfileSettingViewController(
            viewModel: ProfileSettingViewModel(isInitial: true),
            mainView: ProfileSettingView()
        )
        navigationController?.pushViewController(vc, animated: true)
    }
}
