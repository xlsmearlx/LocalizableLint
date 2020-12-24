//
//  FileReaderError.swift
//  LocalizerlintFramework
//
//  Created by Samuel Lagunes on 12/15/20.
//

import Foundation

/// Errors related to reading files.
public enum FileReaderError: Error {
    case unreadablePath(String)
}

extension FileReaderError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .unreadablePath(let path):
            return "Unreadable path: \(path)"
        }
    }
}
