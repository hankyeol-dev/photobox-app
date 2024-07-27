//
//  MainTabbarController.swift
//  photobox
//
//  Created by 강한결 on 7/28/24.
//

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        
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
        
        setViewControllers([topicVC, searchVC, likeListVC], animated: true)
    }

}
