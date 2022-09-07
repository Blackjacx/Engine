//
//  ClampingTests.swift
//  EngineTests
//
//  Created by Stefan Herold on 07.09.22.
//

import Foundation
import XCTest
@testable import Engine

final class ClampingTests: XCTestCase {
    static let min: Double = 0
    static let max: Double = 14

    struct Collection1 {
        @Clamping(min...max) var underflowValue: Double = min - 0.001
        @Clamping(min...max) var lowerEqualValue: Double = min
        @Clamping(min...max) var inRangeValue: Double = 7
        @Clamping(min...max) var upperEqualValue: Double = max
        @Clamping(min...max) var overflowValue: Double = max + 0.001
    }

    struct Collection2 {
        let underflowValue = Clamping(initialValue: min - 0.001, min...max)
        let lowerEqualValue = Clamping(initialValue: min, min...max)
        var inRangeValue = Clamping(initialValue: 7, min...max)
        let upperEqualValue = Clamping(initialValue: max, min...max)
        let overflowValue = Clamping(initialValue: max + 0.001, min...max)
    }

    func testClampingOnWrappedValueInit() {
        var c1 = Collection1()
        XCTAssertEqual(c1.underflowValue, Self.min)
        XCTAssertEqual(c1.lowerEqualValue, Self.min)
        XCTAssertEqual(c1.inRangeValue, 7)
        XCTAssertEqual(c1.upperEqualValue, Self.max)
        XCTAssertEqual(c1.overflowValue, Self.max)

        c1.inRangeValue -= 100
        XCTAssertEqual(c1.inRangeValue, Self.min)
        c1.inRangeValue = 7
        XCTAssertEqual(c1.inRangeValue, 7)
        c1.inRangeValue += 100
        XCTAssertEqual(c1.inRangeValue, Self.max)
    }

    func testClampingOnAlternativeInit() {
        var c2 = Collection2()
        XCTAssertEqual(c2.underflowValue.value, Self.min)
        XCTAssertEqual(c2.lowerEqualValue.value, Self.min)
        XCTAssertEqual(c2.inRangeValue.value, 7)
        XCTAssertEqual(c2.upperEqualValue.value, Self.max)
        XCTAssertEqual(c2.overflowValue.value, Self.max)

        c2.inRangeValue.value -= 100
        XCTAssertEqual(c2.inRangeValue.value, -93.0)
        c2.inRangeValue.value = 7
        XCTAssertEqual(c2.inRangeValue.value, 7)
        c2.inRangeValue.value += 100
        XCTAssertEqual(c2.inRangeValue.value, 107.0)
    }
}
