//
//  UIColor+Extensions.swift
//  Engine
//
//  Created by Stefan Herold on 21.02.20.
//

#if canImport(UIKit)
import UIKit

public extension UIColor {

    convenience init(r: UInt8, g: UInt8, b: UInt8, a: UInt8) {
        self.init(red: CGFloat(r) / 255.0,
                  green: CGFloat(g) / 255.0,
                  blue: CGFloat(b) / 255.0,
                  alpha: CGFloat(a) / 255.0)
    }

    // MARK: - Dark Mode

    /// Creates a UIColor that dynamically adapts to light/dark and normal/high
    /// contrast modes.
    ///
    /// See [Building with parallel Xcode versions on Bitrise](https://blog.bitrise.io/building-with-parallel-xcode-versions-on-bitrise)
    /// for a description of the backwards compatibility check.
    ///
    /// - Parameter light: The light, normal contrast color variant.
    /// - Parameter lightHigh: The light, high contrast color variant.
    /// - Parameter dark: The dark, normal contrast color variant.
    /// - Parameter darkHigh: The dark, high contrast color variant.
    convenience init(light: UIColor,
                     lightHigh: UIColor,
                     dark: UIColor,
                     darkHigh: UIColor) {

        #if os(watchOS)
        self.init(cgColor: light.cgColor)
        #else
        self.init(dynamicProvider: { (traits) in
            switch(traits.userInterfaceStyle, traits.accessibilityContrast) {
            case (.dark, .high): return darkHigh
            case (.dark, _):     return dark
            case (_, .high):     return lightHigh
            default:             return light
            }
        })
        #endif
    }

    /// Creates a UIColor that dynamically adapts to light/dark and normal/high
    /// contrast modes.
    /// - Parameter light: The light, normal contrast color variant, specified as hex value.
    /// - Parameter lightHigh: The light, high contrast color variant, specified as hex value.
    /// - Parameter dark: The dark, normal contrast color variant, specified as hex value.
    /// - Parameter darkHigh: The dark, high contrast color variant, specified as hex value.
    convenience init(light: Int, lightHigh: Int, dark: Int, darkHigh: Int) {

        self.init(light: UIColor(light),
                  lightHigh: UIColor(lightHigh),
                  dark: UIColor(dark),
                  darkHigh: UIColor(darkHigh))
    }

    /// Creates a UIColor that dynamically adapts to light/dark mode.
    /// - Parameter light: The light color variant.
    /// - Parameter dark: The dark color variant.
    convenience init(light: UIColor, dark: UIColor) {
        self.init(light: light, lightHigh: light, dark: dark, darkHigh: dark)
    }

    /// Creates a UIColor that dynamically adapts to light/dark mode.
    /// - Parameter light: The light color variant, specified as hex value.
    /// - Parameter dark: The dark color variant, specified as hex value.
    convenience init(light: Int, dark: Int) {
        self.init(light: UIColor(light), dark: UIColor(dark))
    }

    // MARK: - Hex

    /// Creates a UIColor from a hex value. Currently it can only handle opaque
    /// colors (colors with alpha == 1).
    /// - Parameter hex32: The integer hex value to create the color from.
    convenience init(hex32: UInt32) {
        self.init(r: UInt8((hex32 >> 24) & 0xFF),
                  g: UInt8((hex32 >> 16) & 0xFF),
                  b: UInt8((hex32 >>  8) & 0xFF),
                  a: UInt8( hex32        & 0xFF))
    }

    convenience init(_ hex24: Int) {
        self.init(r: UInt8((hex24 >> 16) & 0xFF),
                  g: UInt8((hex24 >>  8) & 0xFF),
                  b: UInt8((hex24 >>  0) & 0xFF),
                  a: 255)
    }

    /// Returns the hex value of a color as RGBA (32 bit) int value
    var hex32Value: Int {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return Int(r * 255) << 24 | Int(g * 255) << 16 | Int(b * 255) << 8 | Int(a * 255) << 0
    }

    /// Returns the hex value of a color as RGB (24 bit) int value
    var hex24Value: Int {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return Int(r * 255) << 16 | Int(g * 255) << 8 | Int(b * 255) << 0
    }
}
#endif
