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

    /// - throws: NetworkError
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

        do {
            if Self.verbosityLevel > 0 {
                let json = String(data: data, encoding: .utf8)!
                print(json)
            }

            // Prevents decoding error when there is no data in the response
            if T.self == EmptyResponse.self {
              return EmptyResponse() as! T
            }

            return try endpoint.jsonDecode(T.self, from: data)
        } catch {
            throw NetworkError.jsonDecodingFailed(error: error)
        }
    }

    // MARK: - Deprecated

    public func request<T: Decodable>(endpoint: Endpoint, completion: @escaping RequestClosure<T>) {

        let url = endpoint.buildUrl()

        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 5)
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
                completion(.failure(.parameterEncodingToJsonFailed(error: error)))
                return
            }
        }

        Self.session.dataTask(with: request) { (data, response, error) in

            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse(error: error)))
                return
            }

            if Self.verbosityLevel > 1 {
                print("\nResponse: \(response)")
            }

            guard (200..<400).contains(response.statusCode) else {

                var loggedError: Swift.Error? = error
                if let data = data, let failureMessage = String(data: data, encoding: .utf8) {
                    loggedError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: failureMessage])
                }
                completion(.failure(.invalidStatusCode(code: response.statusCode, underlying: loggedError)))
                return
            }

            guard let data = data else {
                completion(.failure(.noData(error: error)))
                return
            }

            do {
                if Self.verbosityLevel > 0 {
                    let json = String(data: data, encoding: .utf8)!
                    print(json)
                }

                // Prevents decoding error when there is no data in the response
                if T.self == EmptyResponse.self {
                  completion(.success(EmptyResponse() as! T))
                  return
                }

                let decodable = try endpoint.jsonDecode(T.self, from: data)
                completion(.success(decodable))
            } catch {
                completion(.failure(.jsonDecodingFailed(error: error)))
            }
        }.resume()
    }

    public func syncRequest<T: Decodable>(endpoint: Endpoint) -> RequestResult<T> {

        let semaphore = DispatchSemaphore(value: 0)
        var result: RequestResult<T>!

        request(endpoint: endpoint) { (receivedResult: RequestResult<T>) in
            result = receivedResult
            semaphore.signal()
        }
        semaphore.wait()
        return result
    }
}
