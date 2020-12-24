//
//  FileReaderOptions.swift
//  LocalizerlintFramework
//
//  Created by Samuel Lagunes on 12/15/20.
//

import Foundation

/// Options that will determine the behaviour of FileReader.
public struct FileReaderOptions: OptionSet {
    public let rawValue: Int8
    
    public static let swiftui = FileReaderOptions(rawValue: 1)
    public static let objectivec = FileReaderOptions(rawValue: 1 << 1)
    public static let bruteForce = FileReaderOptions(rawValue: 1 << 2)    
    
    public init(rawValue: Int8) {
        self.rawValue = rawValue
    }
}
