//
//  String+Extensions.swift
//  Engine
//
//  Created by Stefan Herold on 18.06.20.
//

import Foundation

public extension String {

    // MARK: - Truncation / Replacement / Filtering

    /// Trims new lines and whitespaces from a given text
    /// - Parameters:
    ///   - text: The input string that should be trimmed
    ///   - defaultResult: The string returned if the input is nil. Default `""`
    /// - Returns: The trimmed input string or the defaultResult if the input string is nil.
    static func trim(_ text: String?, defaultResult: String = "") -> String {
        text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? defaultResult
    }

    /// Used to parse the phone number and the dialing code to remove invalid
    /// characters. Only digits are allowed.
    /// - parameters:
    ///   - text: Any String where invalid characters are removed from
    /// - returns: A String that is never nil but maybe empty
    static func stripAllButDigits(fromText text: String?, defaultResult: String = "") -> String {
        let components = text?.components(separatedBy: .decimalDigits.inverted)
        let stripped = components?.joined()
        return stripped ?? defaultResult
    }

    var nbspFiltered: String {
        replacingOccurrences(of: "\u{00a0}", with: " ")
    }

    @available(*, deprecated, renamed: "firstCapitalized")
    func capitalizedFirst() -> String {
        firstCapitalized()
    }
    /// Handy function to capitalize only the first letter of a string
    func firstCapitalized() -> String {
        prefix(1).capitalized + dropFirst()
    }

    @available(*, deprecated, renamed: "firstLowercased")
    func lowercasedFirst() -> String {
        firstLowercased()
    }
    /// Handy function to lowercase only the first letter of a string
    func firstLowercased() -> String {
        prefix(1).lowercased() + dropFirst()
    }

    // MARK: - Paths

    func appendPathComponent(_ value: String) -> String {
        (self as NSString).appendingPathComponent(value)
    }

    // MARK: - Localization

    var localized: String {
        let appTranslation = NSLocalizedString(self,
                                               tableName: nil,
                                               bundle: Bundle.main,
                                               value: self,
                                               comment: "")

        if appTranslation != self {
            return appTranslation
        }
        return self
    }
}
