//
//  Keychain.swift
//  Engine
//
//  Created by Stefan Herold on 17.02.2025.
//

import Foundation
import KeychainAccess

public struct Keychain {
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    private let keychain = KeychainAccess.Keychain(service: ProcessInfo.processId)

    // MARK: - Public Interface

    public mutating func setObject<T: Codable>(_ value: T, key: String) throws {
        let data = try encoder.encode(value)
        try keychain.set(data, key: key)
    }

    public mutating func getObject<T: Codable>(for key: String) throws -> T? {
        guard let data = try keychain.getData(key) else {
            return nil
        }
        return try decoder.decode(T.self, from: data)
    }

    public mutating func getData(for key: String) throws -> Data? {
        return try keychain.getData(key)
    }

    public mutating func removeObject(for key: String) throws {
        try keychain.remove(key)
    }
}
