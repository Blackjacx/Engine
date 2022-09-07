//
//  UserDefaults+PropertyWrapper.swift
//  Engine
//
//  Created by Stefan Herold on 17.11.20.
//

import Foundation

@propertyWrapper
public struct Defaults<T: Codable> {
    let key: String
    let defaultValue: T

    public init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    public var wrappedValue: T {
        get {
            guard let data = UserDefaults.standard.object(forKey: key) as? Data,
                  let user = try? JSONDecoder().decode(T.self, from: data) else { return  defaultValue }

            return user
        }
        set {
            guard let encoded = try? JSONEncoder().encode(newValue) else { return }
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }
}
