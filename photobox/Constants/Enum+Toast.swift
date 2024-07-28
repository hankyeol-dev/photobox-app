//
//  Enum+Toast.swift
//  photobox
//
//  Created by 강한결 on 7/28/24.
//

import UIKit

enum ToastState {
    case success
    case error
    
    var stateColor: UIColor {
        switch self {
        case .success:
            return .systemGreen
        case .error:
            return .error
        }
    }
}
