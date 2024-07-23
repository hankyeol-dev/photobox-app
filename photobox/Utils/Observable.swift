//
//  Observable.swift
//  photobox
//
//  Created by 강한결 on 7/23/24.
//

import Foundation

final class Observable<T> {
    private var handler: ((T) -> Void)?
    
    var value: T {
        didSet {
            handler?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func binding(_ handler: @escaping (T) -> Void) {
        handler(value)
        self.handler = handler
    }
    
    func bindingWithoutInitCall(_ handler: @escaping (T) -> Void) {
        self.handler = handler
    }
}
