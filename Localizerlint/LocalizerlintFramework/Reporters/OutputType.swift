//
//  OutputType.swift
//  LocalizerlintFramework
//
//  Created by Samuel Lagunes on 12/17/20.
//

import Foundation

public enum OutputType: Equatable, Hashable {
    case json
    case xcode
    case other(String)
    
    /// Failable initializer for OutputType.
    /// - Parameter string: A String value to initialize OutputType.
    /// - Throws: OutputTypeError if the given value does not match any available types.
    public init(_ string: String) throws {
        if string == "json" {
            self = .json
        } else if string == "xcode" {
            self = .xcode
        } else {
            throw OutputTypeError.OutputTypeNotSupported(type: string)
        }
    }
    
    /// Initialize a Set of OutputType using a String.
    /// - Parameter string: A String containing available OutputType values.
    /// - Throws: OutputTypeError if the given value is invalid.
    /// - Returns: A Set of OutputType.
    public static func typesFromString(_ string: String) throws -> Set<OutputType> {
        try Set(string.split(separator: ",").map({ try OutputType(String($0)) }))
    }
}
