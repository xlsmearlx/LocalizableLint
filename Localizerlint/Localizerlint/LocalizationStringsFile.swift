//
//  LocalizationStringsFile.swift
//  LocalizableLint
//
//  Created by Samuel Lagunes on 12/4/20.
//

import Foundation

/// <#Description#>
struct LocalizedStringsFile {
    let path: String
    let kv: [String: String]

    var keys: [String] {
        return Array(kv.keys)
    }

    init(path: String, kv: [String: String]) {
        self.path = path
        self.kv = kv
    }

    /// Writes back to localizable file with sorted keys and removed whitespaces and new lines
    func cleanWrite() {
        Logger.print(log: BuildLog(message: "Formatting file: \(path)", type: .message))
        let content = kv.keys.sorted().map { "\($0) = \(kv[$0]!);" }.joined(separator: "\n")
        try! content.write(toFile: path, atomically: true, encoding: .utf8)
    }
}

