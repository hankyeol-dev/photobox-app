//
//  Extension+UIView.swift
//  photobox
//
//  Created by 강한결 on 7/23/24.
//

import UIKit

extension UIView {
    func getWindowWidth() -> CGFloat {
        let window = UIApplication.shared.connectedScenes.first as! UIWindowScene
        return window.screen.bounds.width
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}
