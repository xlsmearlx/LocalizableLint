//
//  RegexEvaluatorError.swift
//  Localizerlint
//
//  Created by Samuel Lagunes on 12/15/20.
//

import Foundation

/// Errors related to regular expressions
enum RegexEvaluatorError: Error {
    case invalidPattern(String)
}

extension RegexEvaluatorError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidPattern(let pattern):
            return "Invalid regex format: \(pattern)"
        }
    }
}
