//
//  FileManager+Extensions.swift
//  Engine
//
//  Created by Stefan Herold on 24.09.20.
//

import Foundation

public extension FileManager {

    static func createTemporaryDirectory() throws -> URL {
        let uuid = "\(ProcessInfo.processId).\(NSUUID().uuidString)"
        let tmpDirectoryURL = FileManager.default.temporaryDirectory.appendingPathComponent(uuid)
        try FileManager.default.createDirectory(at: tmpDirectoryURL, withIntermediateDirectories: true, attributes: nil)
        return tmpDirectoryURL
    }
}
