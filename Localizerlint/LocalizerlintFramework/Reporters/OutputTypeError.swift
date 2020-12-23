//
//  OutputTypeError.swift
//  LocalizerlintFramework
//
//  Created by Samuel Lagunes on 23/12/20.
//

import Foundation

enum OutputTypeError: Error {
    case OutputTypeNotSupported(type: String)
}

extension OutputTypeError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .OutputTypeNotSupported(let type):
            return "\'\(type)\' is not a valid reporter. Available reporters: xcode, json"
        }
    }
}
