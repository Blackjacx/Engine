//
//  UIColorTests.swift
//  EngineTests
//
//  Created by Stefan Herold on 07.09.22.
//

#if canImport(UIKit)
import UIKit
import Testing
@testable import Engine

@Suite()
struct UIColorTests {

    @Test("Conversion From 32Bit Hex-Integer To Color")
    func conversionFrom32BitHexIntegerToColor() async throws {
        let color = UIColor(hex32: 0xffeeddcc)  // hex 32 bit initializer
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)

        #expect(Int(r * 255) == 255)
        #expect(Int(g * 255) == 238)
        #expect(Int(b * 255) == 221)
        #expect(Int(a * 255) == 204)
    }

    @Test("Conversion From 24Bit Hex-Integer To Color")
    func conversionFrom24BitHexIntegerToColor() async throws {
        let color = UIColor(0xffeedd) // hex 24 bit initializer
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)

        #expect(Int(r * 255) == 255)
        #expect(Int(g * 255) == 238)
        #expect(Int(b * 255) == 221)
        #expect(Int(a * 255) == 255)
    }
}
#endif
