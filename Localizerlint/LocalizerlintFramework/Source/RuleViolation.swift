//
//  RuleViolationType.swift
//  LocalizerlintFramework
//
//  Created by Samuel Lagunes on 12/17/20.
//

import Foundation

/// Container with the line and type of rule violation
public struct RuleViolation {
    public let lineNumber: Int?
    public let type: RuleViolationType
}
