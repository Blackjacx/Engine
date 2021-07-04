//
//  Endpoint.swift
//  Engine
//
//  Created by Stefan Herold on 26.05.20.
//

import Foundation

/// Describes everything to operate on network resources. Encapsulates the details to form a network request.
/// - note: Conform an enum to it to implement multiple endpoints using the enum's cases.
public protocol Endpoint {
    var url: URL? { get }
    var host: String { get }
    var port: Int? { get }
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var parameters: [String: Any]? { get }
    var shouldAuthorize: Bool { get }
    var timeout: TimeInterval { get }

    /// Only the endpoint knows how to decode API specific JSON into model objects
    func jsonDecode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T
}

extension Endpoint {

    func buildUrl() -> URL {
        if let url = url {
            return url
        }
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.port = port
        components.path = path

        if !queryItems.isEmpty {
            components.queryItems = queryItems
        }
        return components.url!
    }
}
