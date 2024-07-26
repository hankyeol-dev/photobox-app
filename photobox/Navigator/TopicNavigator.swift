//
//  TopciNavigator.swift
//  photobox
//
//  Created by 강한결 on 7/24/24.
//

import UIKit

final class TopicNavigator: NavigatingProtocol {
    var parentNavigator: (any NavigatingProtocol)?
    
    var children: [any NavigatingProtocol] = []
    
    var controller: UINavigationController
    
    init(controller: UINavigationController) {
        self.controller = controller
    }
    
    func start() {
        showTopicVC()
    }
    
    func showTopicVC() {} 
}
