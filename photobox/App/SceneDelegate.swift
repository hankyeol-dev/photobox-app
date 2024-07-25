//
//  SceneDelegate.swift
//  photobox
//
//  Created by 강한결 on 7/22/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var mainNavigator: NavigatingProtocol?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        
        let controller = UINavigationController()
        let users = UserDefaultsService.shared.getValues()
        
        if (users.filter { $0 != nil }).count != users.count {
            mainNavigator = OnboardingNavigator(controller: controller)
            mainNavigator?.start()
            window?.rootViewController = controller
        } else {
            window?.rootViewController = MainTabbarNavigator(controller: controller).goToMainTabbar()
        }
        
        
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) { }

    func sceneDidBecomeActive(_ scene: UIScene) { }

    func sceneWillResignActive(_ scene: UIScene) { }

    func sceneWillEnterForeground(_ scene: UIScene) { }

    func sceneDidEnterBackground(_ scene: UIScene) { }
}

