//
//  Json.swift
//  Engine
//
//  Created by Stefan Herold on 19.06.20.
//

import Foundation

public struct Json {

    public static var encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }()

    public static var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
}
