//
//  Service.swift
//  Engine
//
//  Created by Stefan Herold on 19.06.20.
//

import Foundation

public protocol Service {

    /// Only the service knows how to decode json into model objects.
    func jsonDecode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T
}
