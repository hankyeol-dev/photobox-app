//
//  MainTabbarNavigator.swift
//  photobox
//
//  Created by 강한결 on 7/23/24.
//

import UIKit

final class MainTabbarNavigator: NavigatingProtocol {
    var parentNavigator: (any NavigatingProtocol)?
    
    var children: [any NavigatingProtocol] = []
    
    var controller: UINavigationController
    
    init(controller: UINavigationController) {
        self.controller = controller
    }
    
    func start() { }
}

extension MainTabbarNavigator {
    func goToMainTabbar() -> UITabBarController {
        let tabbarController = UITabBarController()
        
        let TopicVC = UINavigationController(rootViewController: TopicViewController(viewModel: TopicViewModel(), mainView: TopicView()))
        TopicVC.tabBarItem = UITabBarItem(title: "", image: UIImage.tapTrendInactive, selectedImage: UIImage.tabTrend)
        
        let viewControllers = [TopicVC]
        
        tabbarController.setViewControllers(viewControllers, animated: true)
        tabbarController.tabBar.backgroundColor = .systemBackground
        tabbarController.tabBar.tintColor = .gray_lg
        
        controller.viewControllers.removeAll()
        return tabbarController
    }
}
