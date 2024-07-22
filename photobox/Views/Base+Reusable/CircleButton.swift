//
//  CircleButton.swift
//  photobox
//
//  Created by 강한결 on 7/22/24.
//

import UIKit
import SnapKit

final class CircleButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 25
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray_lg.cgColor
    
        configuration = .filled()
        configuration?.titleAlignment = .center
        configuration?.cornerStyle = .capsule
        configuration?.baseForegroundColor = .gray_lg
        configuration?.baseBackgroundColor = .white
        configurationUpdateHandler = { btn in
            switch btn.state {
            case .selected:
                btn.configuration?.baseBackgroundColor = .primary
                btn.configuration?.baseForegroundColor = .white
                btn.layer.borderColor = UIColor.primary.cgColor
                break
            default:
                break
            }
        }
    }
    
    convenience init(for title: String) {
        self.init(frame: .zero)
        configuration?.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func isCantTouched() {
        isEnabled = false
        configuration?.baseForegroundColor = .white
        configuration?.baseBackgroundColor = .black
        layer.borderWidth = 0
    }
    
    func isAbled() {
        isEnabled = true
        configuration?.baseForegroundColor = .white
        configuration?.baseBackgroundColor = .primary
        layer.borderWidth = 0
    }
}
