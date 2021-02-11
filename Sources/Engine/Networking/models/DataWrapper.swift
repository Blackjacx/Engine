//
//  DataWrapper.swift
//  Engine
//
//  Created by Stefan Herold on 26.05.20.
//

import Foundation

public struct DataWrapper<T: Decodable>: Decodable {
    public let data: T
}
