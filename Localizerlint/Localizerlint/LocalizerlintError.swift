//
//  LocalizerlintError.swift
//  Localizerlint
//
//  Created by Samuel Lagunes on 12/17/20.
//

import Foundation

enum LocalizerlintError: Error {
    case strictModeEnabled
}

extension LocalizerlintError: LocalizedError {    
    var errorDescription: String? {
        switch self {
        case .strictModeEnabled:
            return "Localizerlint finished with errors due to strict mode enabled"
        }
    }
}
