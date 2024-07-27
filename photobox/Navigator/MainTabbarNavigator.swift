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
        
        let topicVC = UINavigationController(
            rootViewController: TopicViewController(
                viewModel: TopicViewModel(
                    networkManager: NetworkService.shared,
                    fileManageService: FileManageService.shared,
                    likedPhotoRepository: LikedPhotoRepository.shared
                ),
                mainView: TopicView()
            )
        )
        topicVC.tabBarItem = UITabBarItem(title: "", image: UIImage.tapTrendInactive, selectedImage: UIImage.tabTrend)
        
        let searchVC = UINavigationController(
            rootViewController: SearchViewController(
                viewModel: SearchViewModel(
                    networkManager: NetworkService.shared,
                    repositoryManager: LikedPhotoRepository.shared,
                    fileManageService: FileManageService.shared
                ),
                mainView: SearchView()
            )
        )
        searchVC.tabBarItem = UITabBarItem(title: "", image: UIImage.tabSearchInactive, selectedImage: UIImage.tabSearch)
        
        let likeListVC = UINavigationController(
            rootViewController: LikeListViewController(
                viewModel: LikeListViewModel(
                    repository: LikedPhotoRepository.shared,
                    filemanger: FileManageService.shared
                ),
                mainView: LikeListView()
            )
        )
        likeListVC.tabBarItem = UITabBarItem(title: "", image: UIImage.tabLikeInactive, selectedImage: UIImage.tabLike)
        
        
        let viewControllers = [likeListVC]
        
        tabbarController.setViewControllers(viewControllers, animated: true)
        tabbarController.tabBar.backgroundColor = .systemBackground
        tabbarController.tabBar.tintColor = .gray_lg
        
        controller.viewControllers.removeAll()
        return tabbarController
    }
}
