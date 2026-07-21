//
//  Encodable+JSON.swift
//  Engine
//
//  Created by Stefan Herold on 21.07.26.
//

import Foundation

public extension Encodable {

    /// Renders the receiver as pretty printed JSON so command output stays
    /// machine readable.
    func jsonString() throws -> String {
        let encoder = Json.encoder
        encoder.outputFormatting = [
            .prettyPrinted,
            .sortedKeys,
            .withoutEscapingSlashes,
        ]
        let data = try encoder.encode(self)
        return String(decoding: data, as: UTF8.self)
    }
}
