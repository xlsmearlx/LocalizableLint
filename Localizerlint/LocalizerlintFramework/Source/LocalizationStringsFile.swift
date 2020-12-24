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
    public var ruleViolations: [RuleViolation]
    
    var keys: [String] {
        return Array(kv.keys)
    }
    
    /// Friendly description with the file path and the localized strings.
    public var description: String {
        "file \(path) has \(keys.count) localizedStrings.\(!keys.isEmpty ? " \(keys)" : "")"
    }
}

extension LocalizedStringsFile: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(path, forKey: .file)
        try container.encodeIfPresent(ruleViolations.count, forKey: .totalViolations)
        try container.encodeIfPresent(ruleViolations, forKey: .ruleViolations)
    }
    
    enum CodingKeys: CodingKey {
        case file
        case totalViolations
        case ruleViolations
    }
}

