//
//  Extension+UIColor.swift
//  photobox
//
//  Created by 강한결 on 7/22/24.
//

import UIKit

extension UIColor {
    
    convenience init(hexCode: String) {
        var hexFormatted: String = hexCode.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: 1.0
        )
    }
    
    static let primary = UIColor(hexCode: "#186FF2")
    static let gray_sm = UIColor(hexCode: "#F2F2F2")
    static let gray_md = UIColor(hexCode: "#8C8C8C")
    static let gray_lg = UIColor(hexCode: "#4D5652")
    static let error = UIColor(hexCode: "#F04452")
}
