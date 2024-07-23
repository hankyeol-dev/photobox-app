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
        startEntryNavigator(for: OnboardingNavigator(controller: controller))
    }
    
    func startEntryNavigator(for navigator: NavigatingProtocol) {
        children.removeAll()
        children.append(navigator)
        navigator.parentNavigator = self
        navigator.start()
    }
}
