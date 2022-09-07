//
//  Bundle.swift
//  Engine
//
//  Created by Stefan Herold on 07.09.22.
//

import Foundation

public extension Bundle {

    // MARK: - Values From Info Plist

    /// Returns the bundle identifier specified in the Info.plist
    static var bundleId: String {
        Bundle.main.bundleIdentifier ?? ""
    }

    /// Returns the applications name as specified in the Info.plist
    var appName: String {
        Bundle.main.infoDictionary?["CFBundleName"] as? String ?? ""
    }

    /// Returns `CFBundleShortVersionString` specified in the Info.plist
    static var applicationVersionString: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }

    /// Returns `CFBundleVersion` specified in the Info.plist
    static var buildNumber: String? {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    }

    static var applicationCompleteVersionString: String {
        guard applicationVersionString.isEmpty else {
            return ""
        }
        guard let buildNumber = buildNumber else {
            return applicationVersionString
        }
        return "\(applicationVersionString) (\(buildNumber))"
    }

    // MARK: - Comparing Versions

    static func isAppVersion(_ currentVersion: String = Bundle.applicationVersionString,
                             higherThan comparingVersion: String?) -> Bool {
        guard let comparingVersion = comparingVersion else { return true }
        return currentVersion.compare(comparingVersion, options: .numeric) == .orderedDescending
    }
}
