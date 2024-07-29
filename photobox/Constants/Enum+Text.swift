//
//  Enum+Text.swift
//  photobox
//
//  Created by 강한결 on 7/22/24.
//

import Foundation

enum Text: String {
    case APP_TITLE = "Photo Box"
    case APP_NAME = "강한결"
    
    enum Titles: String {
        case MBTIBOX = "MBTI 설정"
        
        case NAVIGATION_PROFILE_SETTING  = "프로필 생성"
        case NAVIGATION_PROFILE_IMAGE_SETTING = "프로필 이미지 선택"
        case NAVIGATION_SEARCH_PHOTO = "사진 검색"
        case NAVIGATION_LIKED_PHOTO = "좋아요한 사진 목록"
        
        case ALERT_PROFILE_DELETE = "프로필 삭제가 정말인가요? 🥹"
        
        case TOPIC_MAIN_TITLE = "토픽별 이미지"
    }
    
    enum Labels: String {
        case NICKNAME_SUCCESS = "정말 멋진 닉네임이에요!"
        
        case ALERT_PROFILE_DELETE = "정말 모든 데이터를 삭제하고\n 좋아요한 사진을 다 날리고\n 프로필을 삭제하실건가요?"
        
        case LIST_NO_LIKED_PHOTOS = "좋아요한 사진이 없습니다."
        case LIST_NO_SEARCHED_PHOTOS = "검색 결과가 없습니다."
    }
    
    enum Placeholder: String {
        case NICKNAMEFIELD = "멋진 닉네임을 만들어보세요."
        case SEARCHFIELD = "사진을 검색해보세요."
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
        case PROFILE_CONFIRM = "완료"
        case PROFILE_UPDATE = "저장"
        case PROFILE_DELETE = "프로필 삭제"
        case ALERT_PROFILE_DELETE = "정말 삭제하기"
        case ALERT_CANCEL = "취소"
    }
}
