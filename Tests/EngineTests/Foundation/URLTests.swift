//
//  URLTests.swift
//  EngineTests
//
//  Created by Stefan Herold on 07.09.22.
//

import Foundation
import XCTest
@testable import Engine

final class URLTests: XCTestCase {

    func testConstructUrlEncodedUrlWithQuery() {

        let expected = "https://test.com/%C3%A4hm?z=12"

        let url = URL.createFrom(scheme: "https",
                                 host: "test.com",
                                 path: "/ähm",
                                 parameters: ["z": "12"])

        XCTAssertEqual(url?.absoluteString, expected)
    }
}
