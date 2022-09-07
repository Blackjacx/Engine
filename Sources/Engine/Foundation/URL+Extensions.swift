//
//  URL+Extensions.swift
//  Engine
//
//  Created by Stefan Herold on 07.09.22.
//
import Foundation

public extension URL {

    static func createFrom(scheme: String,
                           host: String,
                           path: String,
                           parameters: [String: String]) -> URL? {

        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        return components.url
    }
}
