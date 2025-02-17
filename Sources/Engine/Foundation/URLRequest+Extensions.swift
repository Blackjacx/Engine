//
//  URLRequest+Description.swift
//  Engine
//
//  Created by Stefan Herold on 07.09.22.
//

import Foundation

public extension URLRequest {

    var extendedDescription: String {

        let methodDescription: String = {
            let title = "HTTP-Method"
            let value = "[\(httpMethod ?? "NONE")] \(url?.absoluteString ?? "NONE")"
            return "\(title):\n\(value)"
        }()

        let timeoutDescription: String = {
            "Timeout: \(timeoutInterval)"
        }()

        let headerDescription: String = {
            let title = "HTTP-Header"
            var value = "NONE"
            if let headerFields = allHTTPHeaderFields {
                value = headerFields.map { (key, value) in
                    "\(key) = \(value)"
                }.joined(separator: "\n")
            }
            return "\(title):\n\(value)"
        }()

        let body: String = {
            let title = "HTTP-Body"
            var value: String = "NONE"
            if let body = httpBody, let bodyDescr = String(data: body, encoding: .utf8) {
                value = bodyDescr
            }
            return "\(title):\n\(value)"
        }()

        return """
        \(methodDescription)
        \(timeoutDescription)
        \(headerDescription)
        \(body)
        """
    }
}
