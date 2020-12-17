//
//  LocalizedStringsFile.swift
//  Localizerlint
//
//  Created by Samuel Lagunes on 12/4/20.
//

import Foundation

/// Container for ".strings" files localization keys and values
public struct LocalizedStringsFile {
    public let path: String
    let kv: [String: String]
    public let ruleViolations: [RuleViolation]

    var keys: [String] {
        return Array(kv.keys)
    }
    
    /// Friendly description with the file path and the localized strings
    public var description: String {
        "file \(path) has \(keys.count) localizedStrings.\(!keys.isEmpty ? " \(keys)" : "")"
    }
}

