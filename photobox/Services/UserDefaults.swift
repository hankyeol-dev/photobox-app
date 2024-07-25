//
//  UserDefaults.swift
//  photobox
//
//  Created by 강한결 on 7/24/24.
//

import Foundation

final class UserDefaultsService: ServiceProtocol {
    static let shared = UserDefaultsService()
    
    private let standard = UserDefaults.standard
    
    private init() {}
    
    enum keys: String, CaseIterable {
        case nickname
        case profileImage
        case mbti
    }
    
    func setValue(for key: keys, as value: String) {
        standard.setValue(value, forKey: key.rawValue)
    }
    
    func setValues(for values: [String]) {
        if values.count == keys.allCases.count {
            keys.allCases.enumerated().forEach { (index, key) in
                standard.setValue(values[index], forKey: key.rawValue)
            }
        }
    }
    
    func getValue(for key: keys) -> String? {
        return standard.string(forKey: key.rawValue)
    }
    
    func getValues() -> [String?] {
        return keys.allCases.map {
            standard.string(forKey: $0.rawValue)
        }
    }
    
    func removeValues() {
        keys.allCases.forEach {
            standard.removeObject(forKey: $0.rawValue)
        }
    }
}
