//
//  JWT.swift
//  Engine
//
//  Created by Stefan Herold on 17.02.2025.
//

import CryptoKit
import Foundation

public struct JWT {
    public init() {}

    public func create(keySource: KeySource, header: JWTHeader, payload: JWTClaims) async throws(Error) -> String {
        let headerBase64: String
        let payloadBase64: String

        do {
            let jsonEncoder = JSONEncoder()
            jsonEncoder.dateEncodingStrategy = .custom({ date, encoder in
                var container = encoder.singleValueContainer()
                try container.encode(Int(date.timeIntervalSince1970))
            })
            let headerData = try jsonEncoder.encode(header)
            let payloadData = try jsonEncoder.encode(payload)
            headerBase64 = base64URLEncode(headerData)
            payloadBase64 = base64URLEncode(payloadData)
        } catch {
            throw .headerOrPayloadEncodingError
        }

        guard let keyAsString = String(data: try keySource.data(), encoding: .utf8) else {
            throw .privateKeyToStringConversionFailed
        }
        let privateKey: P256.Signing.PrivateKey
        do {
            privateKey = try P256.Signing.PrivateKey(pemRepresentation: keyAsString)
        } catch {
            throw .privateKeyInvalid
        }

        // Signing Input
        let signingInput = "\(headerBase64).\(payloadBase64)"
        let signingInputData = signingInput.data(using: .utf8)!

        // Sign with existing key
        let signature: P256.Signing.ECDSASignature
        do {
            signature = try privateKey.signature(for: signingInputData)
        } catch {
            throw .signingError
        }
        let signatureBase64 = base64URLEncode(signature.rawRepresentation)

        // Construct final JWT
        return "\(signingInput).\(signatureBase64)"
    }

    // MARK: - Private Helper Functions

    private func base64URLEncode(_ data: Data) -> String {
        data.base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }

    // MARK: - Sub Types

    public enum KeySource: Equatable, Hashable, Codable {
        case localFilePath(path: String)
        case keychain(keychainKey: String)
        case inline(privateKey: String)

        func data() throws(Error) -> Data {
            switch self {
            case .localFilePath(let path):
                guard let data = FileManager.default.contents(atPath: path) else {
                    throw .fileNotFound(path)
                }
                return data
            case .keychain(let keychainKey):
                guard let data = Engine.keychain.keychainItem(for: keychainKey)?.data(using: .utf8) else {
                    throw .keychainItemNotFound(keychainKey)
                }
                return data
            case .inline(let privateKey):
                guard let data = privateKey.data(using: .utf8) else {
                    throw .conversionFailed
                }
                return data
            }
        }

        // MARK: - Codable

        enum CodingKeys: CodingKey {
            case localFilePath
            case keychain
            case inline
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let key = container.allKeys.first

            switch key {
            case .localFilePath:
                let path = try container.decode(String.self, forKey: .localFilePath)
                self = .localFilePath(path: path)
            case .keychain:
                let keychainKey = try container.decode(String.self, forKey: .keychain)
                self = .keychain(keychainKey: keychainKey)
            case .inline:
                let privateKey = try container.decode(String.self, forKey: .inline)
                self = .inline(privateKey: privateKey)
            default:
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: container.codingPath,
                        debugDescription: "Unable to decode enum."
                    )
                )
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            switch self {
            case .localFilePath(let path):
                try container.encode(path, forKey: .localFilePath)
            case .keychain(let keychainKey):
                try container.encode(keychainKey, forKey: .keychain)
            case .inline(let privateKey):
                try container.encode(privateKey, forKey: .inline)
            }
        }
    }

    public enum Error: Swift.Error {
        case credentialsNotSet
        case headerOrPayloadEncodingError
        case signingError
        case keychainItemNotFound(String)
        case conversionFailed
        case fileNotFound(String)
        case privateKeyEmpty
        case privateKeyToStringConversionFailed
        case privateKeyInvalid
        case keyContainsNoData(String)
        case googleServiceAccountJsonNotFound(path: String)
        case invalidResonse(response: URLResponse)
    }
}
