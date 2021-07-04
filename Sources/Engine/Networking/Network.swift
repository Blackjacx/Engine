//
//  Network.swift
//  Engine
//
//  Created by Stefan Herold on 19.06.20.
//

import Foundation
import Combine

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public typealias RequestClosure<T: Decodable> = (RequestResult<T>) -> Void
public typealias RequestResult<T: Decodable> = Result<T, NetworkError>

public struct Network {

    public static var verbosityLevel = 0
    public static let shared = Network()

    private static let session = URLSession.shared

    private init() {}

    // MARK: - Async / Await

    public func request<T: Decodable>(endpoint: Endpoint) async throws -> T {

        let url = endpoint.buildUrl()
        var request = URLRequest(url: url,
                                 cachePolicy: .useProtocolCachePolicy,
                                 timeoutInterval: endpoint.timeout)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers

        if Self.verbosityLevel > 1 {
            print("Request: [\(endpoint.method.rawValue)] \(url) • Headers: [")
            endpoint.headers?.forEach { print("\t \($0)") }
            print("]")
        }

        if let parameters = endpoint.parameters {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                throw NetworkError.parameterEncodingToJsonFailed(error: error)
            }
        }

        let (data, response) = try await Self.session.data(for: request, delegate: nil)

        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse(error: nil)
        }

        if Self.verbosityLevel > 1 {
            print("\nResponse: \(response)")
        }

        guard (200..<400).contains(response.statusCode) else {
            var error: Error?
            if let failureMessage = String(data: data, encoding: .utf8) {
                error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: failureMessage])
            }
            throw NetworkError.invalidStatusCode(code: response.statusCode, underlying: error)
        }

        if Self.verbosityLevel > 0 {
            let json = String(data: data, encoding: .utf8)!
            print(json)
        }

        // Prevents decoding error when there is no data in the response
        if T.self == EmptyResponse.self {
          return EmptyResponse() as! T
        }

        return try endpoint.jsonDecode(T.self, from: data)
    }
}
