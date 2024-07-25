//
//  AppNavigator.swift
//  photobox
//
//  Created by 강한결 on 7/23/24.
//

import UIKit

final class AppNavigator: NavigatingProtocol {
    weak var parentNavigator: (any NavigatingProtocol)?
    var children: [any NavigatingProtocol] = []
    var controller: UINavigationController
    
    init(controller: UINavigationController) {
        self.controller = controller
    }
    
    func start() {
        let values = UserDefaultsService.shared.getValues()
        if (values.filter { $0 != nil }).count != values.count {
            startOnboarding()
        } else {
            startMainTabbar()
        }
        
    }
    
    func startOnboarding() {
        let navigator = OnboardingNavigator(controller: controller)
        navigator.parentNavigator = self
        children.removeAll()
        children.append(navigator)
        navigator.start()
    }
    
    func startMainTabbar() {
        let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = scene?.delegate as? SceneDelegate
        
        let window = sceneDelegate?.window
        
        let navigator = MainTabbarNavigator(controller: controller)
        children.removeAll()
        navigator.parentNavigator = self
        navigator.start()
        
        window?.rootViewController = controller
        window?.makeKeyAndVisible()
    }
    
    func startEntryNavigator(for navigator: NavigatingProtocol) {
        children.removeAll()
        children.append(navigator)
        navigator.parentNavigator = self
        navigator.start()
    }
}
