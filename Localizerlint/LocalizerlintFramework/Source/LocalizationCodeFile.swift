//
//  LocalizationCodeFile.swift
//  Localizerlint
//
//  Created by Samuel Lagunes on 12/4/20.
//

import Foundation

/// Container for ".swift", ".h" files localization keys
public struct LocalizationCodeFile {
    let path: String
    let keys: Set<String>
}
