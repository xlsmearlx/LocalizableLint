//
//  LocalizationCodeFile.swift
//  LocalizableLint
//
//  Created by Samuel Lagunes on 12/4/20.
//

import Foundation

struct LocalizationCodeFile: Pathable {
    let path: String
    let keys: Set<String>
}
