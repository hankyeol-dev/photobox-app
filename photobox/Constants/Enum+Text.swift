//
//  Enum+Text.swift
//  photobox
//
//  Created by 강한결 on 7/22/24.
//

import Foundation

enum Text: String {
    case APP_TITLE = "Photo Box"
    
    enum Labels: String {
        case NICKNAME_SUCCESS = "정말 멋진 닉네임이에요!"
    }
    
    enum Errors: String, Error {
        case NICKNAME_EDITING_START = " "
        case NICKNAME_ERROR_EMPTY = "멋진 닉네임을 작성해보세요."
        case NICKNAME_ERROR_COUNT = "닉네임은 2자 이상 10자 미만으로 작성해주세요."
        case NICKNAME_ERROR_SPECIAL_LETTER = "닉네임에 @, #, $, % 는 들어갈 수 없어요."
        case NICKNAME_ERROR_NUMBER = "닉네임에 숫자는 들어갈 수 없어요."
        case NICKNAME_SUCCESS = "정말 멋진 닉네임이에요!"
    }
    
    enum Buttons: String {
        case ONBOARDING_START = "시작하기"
    }
}
