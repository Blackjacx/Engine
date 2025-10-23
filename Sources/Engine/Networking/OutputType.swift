//
//  OutputType.swift
//  Engine
//
//  Created by Stefan Herold on 23.10.25.
//

import Foundation

/// The way the results of a network requests are displayed
public enum OutputType: String, Codable {
    /// The output is rendered as it is received to the console (default)
    case raw
    /// No output is rendered. Suitable when the frontend itself renders the
    /// results.
    case none
}
