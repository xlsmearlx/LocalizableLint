//
//  OutputType.swift
//  LocalizerlintFramework
//
//  Created by Samuel Lagunes on 12/17/20.
//

import Foundation

public enum OutputType: Equatable {
    case json
    case xcode
    case other(String)

    public init(_ string: String) throws {
        if string == "json" {
            self = .json
        } else if string == "xcode" {
            self = .xcode
        } else {
            self = .other(string)
        }
    }
    
    public static func typesFromString(_ string: String) throws -> [OutputType] {
        try string.split(separator: ",").map({ try OutputType(String($0)) })
    }
}
