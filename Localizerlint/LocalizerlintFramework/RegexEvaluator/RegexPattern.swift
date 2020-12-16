//
//  RegexPattern.swift
//  Localizerlint
//
//  Created by Samuel Lagunes on 12/15/20.
//

import Foundation

/// Patterns to be used by RegexEvaluator
enum RegexPattern {
    case bruteForce
    case swiftui
    case bundleLocalized
    case bundleLocalizedObjc
    case nslocalized
    case localizedString
    case custom(String)
    
    var expression: String {
        switch self {
        case .bruteForce: return "\"(?!.*?%d)(.*?)\""
        case .swiftui: return "(?<=Text\\()\\s?\"(?!.*?%d)(.*?)\""
        case .bundleLocalized: return "(?<=localizedString\\(forKey:)\\s?\"(?!.*?%d)(.*?)\""
        case .bundleLocalizedObjc: return "(?<=localizedStringForKey:)\\s?@?\"(?!.*?%d)(.*?)\""
        case .nslocalized: return "(?<=NSLocalizedString\\()\\s?@?\"(?!.*?%d)(.*?)\""
        case .localizedString: return "\"([^\"]*?)\"=\"(.*?)\"(?=;)"
        case .custom(let value): return value
        }
    }
}
