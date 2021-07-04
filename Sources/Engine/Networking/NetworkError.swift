//
//  NetworkError.swift
//  Engine
//
//  Created by Stefan Herold on 26.05.20.
//

import Foundation

public enum NetworkError: Error {
    case generic(error: Error)
    case invalidResponse(error: Error?)
    case invalidStatusCode(code: Int, underlying: Error? = nil)
    case requestFailed(code: Int, underlying: Error? = nil)
    case noData(error: Error?)
    case jsonDecodingFailed(error: Error?)
    case parameterEncodingToJsonFailed(error: Error?)
}

extension NetworkError: LoggableError {

    public var id: String {
        "\(self)".components(separatedBy: "(")[0]
    }

    public var code: Int {
        switch self {
        case let .generic(error): return (error as NSError).code
        case let .invalidResponse(error): return (error as NSError?)?.code ?? 0
        case let .invalidStatusCode(code, _): return code
        case let .requestFailed(code, _): return code
        case let .noData(error): return (error as NSError?)?.code ?? 0
        case let .jsonDecodingFailed(error): return (error as NSError?)?.code ?? 0
        case let .parameterEncodingToJsonFailed(error): return (error as NSError?)?.code ?? 0
        }
    }

    public var localizedDescription: String {
        let optionalMessage: String?
        switch self {
        case let .generic(error): optionalMessage = error.localizedDescription
        case let .invalidResponse(error): optionalMessage = error?.localizedDescription
        case let .invalidStatusCode(_, underlying): optionalMessage = underlying?.localizedDescription
        case let .requestFailed(_, underlying): optionalMessage = underlying?.localizedDescription
        case let .noData(error): optionalMessage = error?.localizedDescription
        case let .jsonDecodingFailed(error): optionalMessage = error?.localizedDescription
        case let .parameterEncodingToJsonFailed(error): optionalMessage = error?.localizedDescription
        }

        guard let message = optionalMessage else {
            let key = "ui.networkError.status.\(code)"
            let value = key.localized

            if key != value {
                // Return localized string from Localizable.strings
                return value
            } else {
                // Return generic error message
                return "ui.networkError.generic".localized
            }
        }
        return message
    }

    public var customDebugDescription: String {
        switch self {
        case let .generic(error): return String(describing: error)
        case let .invalidResponse(error): return String(describing: error)
        case let .invalidStatusCode(_, underlying): return String(describing: underlying)
        case let .requestFailed(_, underlying): return String(describing: underlying)
        case let .noData(error): return String(describing: error)
        case let .jsonDecodingFailed(error): return String(describing: error)
        case let .parameterEncodingToJsonFailed(error): return String(describing: error)
        }
    }
}
