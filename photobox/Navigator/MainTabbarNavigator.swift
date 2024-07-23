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
    
    func start() {
        //
    }
    
    
}
