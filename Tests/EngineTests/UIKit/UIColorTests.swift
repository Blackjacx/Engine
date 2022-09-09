//
//  UIColorTests.swift
//  EngineTests
//
//  Created by Stefan Herold on 07.09.22.
//

#if canImport(UIKit)
import XCTest
@testable import Engine

final class UIColorTests: XCTestCase {

    func testConversionFrom32BitHexIntegerToColor() {

        let color = UIColor(hex32: 0xffeeddcc)  // hex 32 bit initializer
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)

        XCTAssertEqual(Int(r * 255), 255)
        XCTAssertEqual(Int(g * 255), 238)
        XCTAssertEqual(Int(b * 255), 221)
        XCTAssertEqual(Int(a * 255), 204)
    }

    func testConversionFrom24BitHexIntegerToColor() {

        let color = UIColor(0xffeedd) // hex 24 bit initializer
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)

        XCTAssertEqual(Int(r * 255), 255)
        XCTAssertEqual(Int(g * 255), 238)
        XCTAssertEqual(Int(b * 255), 221)
        XCTAssertEqual(Int(a * 255), 255)
    }
}
#endif
