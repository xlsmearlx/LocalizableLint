//
//  FileAnalyzer.swift
//  LocalizableLint
//
//  Created by Samuel Lagunes on 12/4/20.
//

import Foundation

final class FileAnalyzer {
    
    enum Pattern: String {
        case bruteForce = "\"(?!.*?%d)(.*?)\""
        case swiftui = "(?<=Text\\()\\s?\"(?!.*?%d)(.*?)\""
        case bundleLocalized = "(?<=localizedString\\(forKey:)\\s?\"(?!.*?%d)(.*?)\""
        case nslocalized = "(?<=NSLocalizedString\\()\\s?\"(?!.*?%d)(.*?)\""
    }
    
    /// Returns a list of strings that match regex pattern from content
    ///
    /// - Parameters:
    ///   - pattern: regex pattern
    ///   - content: content to match
    /// - Returns: list of results
    static func regexFor(_ pattern: String, content: String) -> [String] {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else { fatalError("Regex not formatted correctly: \(pattern)")}
        let matches = regex.matches(in: content, options: [], range: NSRange(location: 0, length: content.utf16.count))
        return matches.map {
            guard let range = Range($0.range(at: 0), in: content) else { fatalError("Incorrect range match") }
            
            return String(content[range])
        }
    }
    
    /// Throws warning if keys exist in localizable file but are not being used
    ///
    /// - Parameters:
    ///   - codeFiles: Array of LocalizationCodeFile
    ///   - localizationFiles: Array of LocalizableStringFiles
    static func validateDeadKeys(_ codeFiles: [LocalizationCodeFile], localizationFiles: [LocalizationStringsFile]) {
        print("total code files: \(codeFiles.count)")
        print("total localizationFiles files: \(localizationFiles.count)")
        let allCodeFileKeys = Set(codeFiles.flatMap { $0.keys })
        
        localizationFiles.forEach { (stringsFile) in
            let baseKeys = Set(stringsFile.keys)
            let deadKeys = baseKeys.subtracting(allCodeFileKeys)
            
            print("file: \(stringsFile.path) has \(baseKeys.count) keys and \(deadKeys.count) deadKeys")
            
            deadKeys.forEach({ printPretty("\(stringsFile.path): warning: DEADKEY: \($0)") })
        }
    }
}
