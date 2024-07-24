//
//  OnboardingNavigator.swift
//  photobox
//
//  Created by 강한결 on 7/23/24.
//

import UIKit

final class OnboardingNavigator: NavigatingProtocol, StartNavigation, ProfileSettingNavigation, GoBackNavigation {
    
    var parentNavigator: (any NavigatingProtocol)?
    
    var children: [any NavigatingProtocol] = []
    
    var controller: UINavigationController
    
    init(controller: UINavigationController) {
        self.controller = controller
    }
    
    func start() {
        let onboardingVC = OnboardingViewController(viewModel: OnboardingViewModel(navigator: self), mainView: OnboardingView())
        controller.viewControllers.removeAll()
        controller.pushViewController(onboardingVC, animated: true)
    }
    
    func goToProfileSettingView() {
        let profileSettingVC = ProfileSettingViewController(
            viewModel: ProfileSettingViewModel(navigator: self), mainView: ProfileSettingView()
        )
        controller.pushViewController(profileSettingVC, animated: true)
    }
    
    func goToProfileImageSettingView(image: ProfileImages, completionHanlder: @escaping (ProfileImages) -> Void) {
        
        var viewModel = ProfileImageSettingViewModel(navigator: self)
        viewModel.currentImage = image
        viewModel.sender = completionHanlder
        
        let profileImageSettingVC = ProfileImageSettingViewController(
            viewModel: viewModel, mainView: ProfileImageSelectView()
        )
        
        controller.pushViewController(profileImageSettingVC, animated: true)
    }

    func goBack() {
        controller.popViewController(animated: true)
    }
}
