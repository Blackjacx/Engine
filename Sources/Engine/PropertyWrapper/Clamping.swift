//
//  Clamping.swift
//  Engine
//
//  Created by Stefan Herold on 07.09.22.
//

import Foundation

@propertyWrapper
public struct Clamping<Value: Comparable> {

    var value: Value
    let range: ClosedRange<Value>

    // Used when initializing via `@Clamping(min...max) var clamped: Double = 7`
    public init(wrappedValue: Value, _ range: ClosedRange<Value>) {
        self.value = Self.clamp(range: range, value: wrappedValue)
        self.range = range
    }

    // Used when initializing via `let clamped = Clamping(initialValue: 7, min...max)`
    public init(initialValue value: Value, _ range: ClosedRange<Value>) {
        self.value = Self.clamp(range: range, value: value)
        self.range = range
    }

    public var wrappedValue: Value {
        get { value }
        set { value = Self.clamp(range: range, value: newValue) }
    }

    private static func clamp(range: ClosedRange<Value>, value: Value) -> Value {
        return min(max(range.lowerBound, value), range.upperBound)
    }
}
