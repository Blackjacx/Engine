//
//  Network+Error.swift
//  Engine
//
//  Created by Stefan Herold on 26.05.20.
//

import Foundation

extension Network {

    public enum Error: Swift.Error {
        case invalidResponse(error: Swift.Error?)
        case invalidStatusCode(code: Int, error: Swift.Error?)
        case noData(error: Swift.Error?)
        case jsonDecodingFailed(error: Swift.Error?)
        case parameterEncodingToJsonFailed(error: Swift.Error?)
    }
}
