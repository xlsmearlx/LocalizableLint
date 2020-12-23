//
//  RuleViolationType.swift
//  LocalizerlintFramework
//
//  Created by Samuel Lagunes on 12/17/20.
//

import Foundation

/// Warnings/Errors that can be found in localization files
public enum RuleViolationType {
    case duplicatedKey(key: String)
    case unusedKey(key: String)
    
    public var isDuplicate: Bool {
        switch self {
        case .duplicatedKey:
            return true
        case .unusedKey:
            return false
        }
    }
    
    public var description: String {
        switch self {
        case .duplicatedKey(let key):
            return "\(key) is duplicated"
        case .unusedKey(let key):
            return "\(key) was defined but never used"
        }
    }
}
