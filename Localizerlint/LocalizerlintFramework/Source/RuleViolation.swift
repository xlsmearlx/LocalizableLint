//
//  RuleViolationType.swift
//  LocalizerlintFramework
//
//  Created by Samuel Lagunes on 12/17/20.
//

import Foundation

/// Container with the line and type of rule violation
public struct RuleViolation: Encodable {
    public let lineNumber: Int?
    public let type: RuleViolationType
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(lineNumber, forKey: .line)
        try container.encodeIfPresent(type.description, forKey: .reason)
    }
    
    enum CodingKeys: CodingKey {
        case line
        case reason
    }
}
