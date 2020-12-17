//
//  FileViolation.swift
//  LocalizerlintFramework
//
//  Created by Samuel Lagunes on 12/16/20.
//

import Foundation

/// Container with the file path and rule violations
public struct FileViolation {
    public let path: String
    public var violations: [RuleViolation]
    
    /// Adds a new element to the rule violations array
    /// - Parameter rule: an instance of RuleViolation
    mutating func addRuleViolation(_ rule: RuleViolation) {
        violations.append(rule)
    }
}
