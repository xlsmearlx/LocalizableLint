//
//  LocalizedStringsFile.swift
//  Localizerlint
//
//  Created by Samuel Lagunes on 12/4/20.
//

import Foundation

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
}

