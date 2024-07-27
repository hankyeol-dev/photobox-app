//
//  NavigatingProtocol.swift
//  photobox
//
//  Created by 강한결 on 7/23/24.
//

import UIKit

protocol NavigatingProtocol: AnyObject {
    var parentNavigator: NavigatingProtocol? { get set }
    var children: [NavigatingProtocol] { get set }
    var controller: UINavigationController { get set }
    
    func start()
}

extension NavigatingProtocol {
    func childDidFinish(by navigator: NavigatingProtocol) {
        children.enumerated().forEach { index, child in
            if child === navigator {
                children.remove(at: index)
                return
            }
        }
    }
}

protocol GoBackNavigation: AnyObject {
    func goBack()
}

protocol DetailViewNavigatingProtocol: AnyObject {
    func goToDetail(by photoId: String)
}
