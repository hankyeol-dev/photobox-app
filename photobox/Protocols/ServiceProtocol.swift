//
//  ServiceProtocol.swift
//  photobox
//
//  Created by 강한결 on 7/22/24.
//

import Foundation

protocol ServiceProtocol: AnyObject {
    static var shared: Self { get }
}
