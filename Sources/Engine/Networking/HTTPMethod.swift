//
//  HTTPMethod.swift
//  Engine
//
//  Created by Stefan Herold on 26.05.20.
//

import Foundation

public enum HTTPMethod: String, Equatable, Codable, Hashable {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case delete = "DELETE"
    case head = "HEAD"
}

public extension HTTPMethod {
    var stringValue: String { rawValue }
}
