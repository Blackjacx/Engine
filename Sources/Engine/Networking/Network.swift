//
//  Network.swift
//  Engine
//
//  Created by Stefan Herold on 19.06.20.
//

import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public typealias RequestClosure<T: Decodable> = (RequestResult<T>) -> Void
public typealias RequestResult<T: Decodable> = Result<T, Network.Error>

public struct Network {

    public static var verbosityLevel = 0
    private static let session = URLSession.shared

    public init() {}

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

    public func request<T: Decodable>(endpoint: Endpoint, completion: @escaping RequestClosure<T>) {

        var request = URLRequest(url: endpoint.url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 5)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers

        if Self.verbosityLevel > 1 {
            print("Request: [\(endpoint.method.rawValue)] \(endpoint.url) • Headers: [")
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
}
