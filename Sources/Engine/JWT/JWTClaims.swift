//
//  JWTClaims.swift
//  Engine
//
//  Created by Stefan Herold on 17.02.2025.
//

import Foundation

public protocol JWTClaims: Encodable {
    var aud: String? { get }
    // Creation date in time interval since 1970 casted to Int
    var iat: Date { get }
    // Expiration date in time interval since 1970 casted to Int
    var exp: Date? { get }
}
