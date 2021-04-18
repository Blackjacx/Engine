//
//  LoggableError.swift
//  Engine
//
//  Created by Stefan Herold on 18.04.21.
//

import Foundation

public protocol LoggableError: Identifiable {
    var id: String { get }
    /// Used for issue grouping.
    var code: Int { get }
    /// Mapped to NSLocalizedDescriptionKey. Suitable to show the user.
    var localizedDescription: String { get }
    /// Mapped to NSDebugDescriptionErrorKey. Suitable for debugging.
    var customDebugDescription: String { get }
}
