//
//  Validation.swift
//  photobox
//
//  Created by 강한결 on 7/24/24.
//

import Foundation

final class ValidateService: ServiceProtocol {
    static var shared = ValidateService()
    
    private init() {}
    
    enum ValidationErrors: Error {
        case isEmpty
        case isLowerOrOverCount
        case isContainNumber
        case isContainSpecialLetter
    }
    
    func validateNickname(_ t: String) throws {
        if isEmpty(t) {
            throw ValidationErrors.isEmpty
        }
        
        if isLowerThanTwo(t) || isOverTen(t) {
            throw ValidationErrors.isLowerOrOverCount
        }
        
        if isContainNumber(t) {
            throw ValidationErrors.isContainNumber
        }
        
        if isContainSpecialLetter(t) {
            throw ValidationErrors.isContainSpecialLetter
        }

    }
    
    private func isEmpty(_ t: String) -> Bool {
        return t.isEmpty
    }
    
    private func isLowerThanTwo(_ t: String) -> Bool {
        return t.count < 2
    }
    
    private func isOverTen(_ t: String) -> Bool {
        return t.count > 9
    }
    
    private func isContainNumber(_ t: String) -> Bool {
        let array = Array(t)
        return array.filter { Int(String($0)) == nil }.count != array.count
    }
    
    private func isContainSpecialLetter(_ t: String) -> Bool {
        let array = Array(t)
        return array.filter { $0 != "@" && $0 != "#" && $0 != "$" && $0 != "%" }.count != array.count
    }
    
}
