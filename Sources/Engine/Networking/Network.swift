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
public typealias RequestResult<T: Decodable> = Result<T, Network.Error>

public struct Network {

    public static var verbosityLevel = 0
    public static let shared = Network()

    private static let session = URLSession.shared

    private init() {}

    // MARK: - Combine

    /// Use this if you just want to fire a request but are not interested in the response and the resulting object.
    /// Sometimes the request just has no response. It's empty. Then this function is just optimal too.
    public func requestDataPublisher(endpoint: Endpoint,
                                     queue: DispatchQueue = .main,
                                     retries: Int = 0,
                                     timeout: TimeInterval = 5,
                                     cachingPolicy: URLRequest.CachePolicy = .useProtocolCachePolicy) -> AnyPublisher<Data, Network.Error> {

        let url = endpoint.buildUrl()
        var request = URLRequest(url: url, cachePolicy: cachingPolicy, timeoutInterval: timeout)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers

        if let parameters = endpoint.parameters {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                return Fail(outputType: Data.self, failure: Network.Error.parameterEncodingToJsonFailed(error: error))
                    .eraseToAnyPublisher()
            }
        }

        return Self.session.dataTaskPublisher(for: request)
            .receive(on: queue)
            .mapError {
                Network.Error.invalidResponse(error: $0)
            }
            .tryMap { element -> Data in
                if Self.verbosityLevel > 1 {
                    print("Request: [\(endpoint.method.rawValue)] \(url) • Headers: [")
                    endpoint.headers?.forEach { print("\t \($0)") }
                    print("]")
                }

                guard let response = element.response as? HTTPURLResponse else {
                    throw Network.Error.invalidResponse(error: URLError(.badServerResponse))
                }

                if Self.verbosityLevel > 1 {
                    print("\nResponse: \(response)")
                }

                guard (200..<400).contains(response.statusCode) else {
                    var urlError: Swift.Error?
                    if let failureMessage = String(data: element.data, encoding: .utf8) {
                        urlError = URLError(.badServerResponse, userInfo: [NSLocalizedDescriptionKey: failureMessage])
                    }
                    throw Network.Error.invalidStatusCode(code: response.statusCode, underlying: urlError)
                }

                if Self.verbosityLevel > 0 {
                    let json = String(data: element.data, encoding: .utf8)!
                    print(json)
                }
                return element.data
            }
            .retry(retries)
            .mapError { $0 as! Network.Error }
            .eraseToAnyPublisher()
    }

    /// Use to do a request and you're interested in the resulting object.
    public func request<T>(endpoint: Endpoint,
                           queue: DispatchQueue = .main,
                           retries: Int = 0,
                           timeout: TimeInterval = 5,
                           cachingPolicy: URLRequest.CachePolicy = .useProtocolCachePolicy) -> AnyPublisher<T, Network.Error>  where T: Decodable {

        let publisher = requestDataPublisher(endpoint: endpoint,
                                             queue: queue,
                                             retries: retries,
                                             timeout: timeout,
                                             cachingPolicy: cachingPolicy)
            .decode(type: T.self, decoder: Json.decoder)
            .mapError { error -> Network.Error in
                error as? Network.Error ?? Error.jsonDecodingFailed(error: error)
            }
            
            // Throw another error
//            .tryCatch { (error) -> Fail<T, Network.Error> in
//                guard let networkError = error as? Network.Error else {
//                    throw Error.jsonDecodingFailed(error: error)
//                }
//                throw networkError
//            }


            // Replace error with other publisher
//            .catch { (error) -> Fail<T, Network.Error> in
//                /// Make sure to not
//                if let networkError = error as? Network.Error {
//                    return Fail(outputType: T.self, failure: networkError)
//                } else {
//                    return Fail(outputType: T.self, failure: Error.jsonDecodingFailed(error: error))
//                }
//            }


            // Replace error with valid object, e.g. empty array for list requests
//            .catch { error -> Just<T> in
//                print("Decoding failed with error: \(error)")
//            }
            //
            // DEBUG
            //
            .handleEvents(receiveSubscription: { (subscription) in
                print("Receive subscription")
            }, receiveOutput: { output in
                print("Received output: \(output)")
            }, receiveCompletion: { _ in
                print("Receive completion")
            }, receiveCancel: {
                print("Receive cancel")
            }, receiveRequest: { demand in
                print("Receive request: \(demand)")
            })
            .eraseToAnyPublisher()

        return publisher
    }

    // MARK: - URLSession

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
