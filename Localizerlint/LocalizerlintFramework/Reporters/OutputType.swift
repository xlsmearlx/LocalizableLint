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

    public init(_ string: String) throws {
        if string == "json" {
            self = .json
        } else if string == "xcode" {
            self = .xcode
        } else {
            throw OutputTypeError.OutputTypeNotSupported(type: string)
        }
    }
    
    public static func typesFromString(_ string: String) throws -> Set<OutputType> {
        try Set(string.split(separator: ",").map({ try OutputType(String($0)) }))
    }
}
