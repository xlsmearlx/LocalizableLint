//
//  LocalizationStringsFile.swift
//  LocalizableLint
//
//  Created by Samuel Lagunes on 12/4/20.
//

import Foundation

struct LocalizationStringsFile: Pathable {
    let path: String
    let kv: [String: String]

    var keys: [String] {
        return Array(kv.keys)
    }

    init(path: String) {
        self.path = path
        self.kv = FileReader.parse(path)
    }

    /// Writes back to localizable file with sorted keys and removed whitespaces and new lines
    func cleanWrite() {
        print("Formatting file: \(path)")
        let content = kv.keys.sorted().map { "\($0) = \(kv[$0]!);" }.joined(separator: "\n")
        try! content.write(toFile: path, atomically: true, encoding: .utf8)
    }
}
