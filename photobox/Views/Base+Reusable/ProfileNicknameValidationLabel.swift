//
//  ProfileNicknameValidationLabel.swift
//  photobox
//
//  Created by 강한결 on 7/22/24.
//

import UIKit

class ProfileNicknameValidationLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init() {
        self.init(frame: .zero)
        
        font = .sm
        text = Text.Labels.NICKNAME_ERROR_EMPTY.rawValue
        textColor = .gray_md
    }
    
    func startEditing() {
        text = Text.Labels.NICKNAME_EDITING_START.rawValue
    }
    
    func isLowerThanTwoOrOverTen() {
        text = Text.Labels.NICKNAME_ERROR_COUNT.rawValue
        textColor = .error
    }
 
    func isEmpty() {
        text = Text.Labels.NICKNAME_ERROR_EMPTY.rawValue
        textColor = .gray_md
    }
    
    func isContainsNumber() {
        text = Text.Labels.NICKNAME_ERROR_NUMBER.rawValue
        textColor = .error
    }
    
    func isContainsSpecialLetter() {
        text = Text.Labels.NICKNAME_ERROR_SPECIAL_LETTER.rawValue
        textColor = .error
    }
    
    func isSuccess() {
        text = Text.Labels.NICKNAME_SUCCESS.rawValue
        textColor = .primary
    }
}
