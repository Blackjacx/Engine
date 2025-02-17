//
//  JWTTests.swift
//  Engine
//
//  Created by Stefan Herold on 17.02.2025.
//

import Foundation
import Testing
@testable import Engine

@Suite()
struct JWTTests {

    @Test("Generate JWT Token")
    func createJWT() async throws {
        let jwt = try await JWT().create(
            // This is a fake test key ⚠️
            keySource: .inline(privateKey: """
            -----BEGIN EC PRIVATE KEY-----
            MHcCAQEEIDRTZb3ZCTWxPb7VY4RxWx9T0X5z+9bG2xPGgAkGm/CioAoGCCqGSM49
            AwEHoUQDQgAEdzhbmbV5zPuE5wUqhnAcDXhNJ5EJhFS5GG38YujrlPYoU2XHLm7n
            TUN/qLvSK5Z7lzE6jfzv8mJwUMULKPm+0A==
            -----END EC PRIVATE KEY-----
            """),
            header: ExampleHeader(kid: "8A7Q99KV2Y"),
            payload: ExampleClaims(iss: "0E378B17-7CD6-4679-84D9-8061415FC07F")
        )
        #expect(jwt != nil)
    }
}

private struct ExampleClaims: JWTClaims {
    let aud: String? = "some-audience"
    let iat: Date = Date()
    let exp: Date? = Date().addingTimeInterval(60 * 60)
    let iss: String
}

private struct ExampleHeader: JWTHeader {
    let alg: String? = "ES256"
    let typ: String = "JWT"
    let kid: String
}
