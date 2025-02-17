//
//  FileManager+Extensions.swift
//  Engine
//
//  Created by Stefan Herold on 24.09.20.
//

import Foundation

public extension FileManager {


    /// Creates a temporary directory in the temp directory location of the app
    /// bundle which can be cleared when the system needs resources.
    /// - Returns: The URL to the created directory
    static func createTemporaryDirectory() throws -> URL {
        let uuid = "\(ProcessInfo.processId).\(NSUUID().uuidString)"
        let tmpDirectoryURL = FileManager.default.temporaryDirectory.appendingPathComponent(uuid)
        try FileManager.default.createDirectory(at: tmpDirectoryURL, withIntermediateDirectories: true, attributes: nil)
        return tmpDirectoryURL
    }
}
