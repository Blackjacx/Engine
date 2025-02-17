//
//  JWTHeader.swift
//  Engine
//
//  Created by Stefan Herold on 17.02.2025.
//

import Foundation

public protocol JWTHeader: Encodable {
    var alg: String? { get }
    var typ: String { get }
}
