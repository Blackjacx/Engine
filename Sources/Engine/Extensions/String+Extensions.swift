//
//  String+Extensions.swift
//  Engine
//
//  Created by Stefan Herold on 18.06.20.
//

import Foundation

public extension String {

    func nbspFiltered() -> String {
        replacingOccurrences(of: "\u{00a0}", with: " ")
    }

    func appendPathComponent(_ value: String) -> String {
        (self as NSString).appendingPathComponent(value)
    }

    func capitalizedFirst() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    func lowercasedFirst() -> String {
        return prefix(1).lowercased() + dropFirst()
    }

    var localized: String {
        let appTranslation = NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: self, comment: "")

        if appTranslation != self {
            return appTranslation
        }

        return self
    }
}
