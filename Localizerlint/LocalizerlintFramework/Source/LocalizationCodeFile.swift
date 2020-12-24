//
//  LocalizationCodeFile.swift
//  Localizerlint
//
//  Created by Samuel Lagunes on 12/4/20.
//

import Foundation

/// Container for ".swift", ".h" files localization keys.
public struct LocalizationCodeFile {
    let path: String
    let keys: Set<String>
    
    /// Friendly description with the file path and the localized keys.
    public var description: String {
        "file \(path) has \(keys.count) localizedStrings.\(!keys.isEmpty ? " \(keys)" : "")"
    }
}
