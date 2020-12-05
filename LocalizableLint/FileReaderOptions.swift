//
//  FileReaderOptions.swift
//  LocalizableLint
//
//  Created by Samuel Lagunes on 12/5/20.
//

import Foundation

struct FileReaderOptions: OptionSet {
    let rawValue: Int8
    
    static let swiftui = FileReaderOptions(rawValue: 1)
    static let objectivec = FileReaderOptions(rawValue: 1 << 1)
    static let bruteForce = FileReaderOptions(rawValue: 1 << 2)
}
