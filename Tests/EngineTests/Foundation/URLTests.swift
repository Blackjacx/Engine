//
//  URLTests.swift
//  EngineTests
//
//  Created by Stefan Herold on 07.09.22.
//

import Foundation
import Testing
@testable import Engine

@Suite()
struct URLTests {

    @Test("Construct URL Encoded URL with Query")
    func constructUrlEncodedUrlWithQuery() async throws {
        let expected = "https://test.com/%C3%A4hm?z=12"
        let url = URL.createFrom(
            scheme: "https",
            host: "test.com",
            path: "/ähm",
            parameters: ["z": "12"]
        )
        #expect(url?.absoluteString == expected)
    }
}
