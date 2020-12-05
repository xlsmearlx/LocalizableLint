//
//  FileReader.swift
//  LocalizableLint
//
//  Created by Samuel Lagunes on 12/4/20.
//

import Foundation

class FileReader {    
    /// Reads contents in path
    ///
    /// - Parameter path: path of file
    /// - Returns: content in file
    static private func contents(atPath path: String) -> String {
        guard let data = FileManager.default.contents(atPath: path),
              let content = String(data: data, encoding: .utf8)
        else { fatalError("Could not read from path: \(path)") }
        
        return content
    }
    
    /// Parses contents of a file to localizable keys and values - Throws error if localizable file have duplicated keys
    ///
    /// - Parameter path: Localizable file paths
    /// - Returns: localizable key and value for content at path
    static func parse(_ path: String) -> [String: String] {
        let content = contents(atPath: path).removingAllWhiteSpaces
        let keys = FileAnalyzer.regexFor("\"([^\"]*?)\"(?==)", content: content)
        let values = FileAnalyzer.regexFor("(?<==)\"(.*?)\"(?=;)", content: content)
        if keys.count != values.count { fatalError("File: \(path)\nError parsing contents: Make sure all keys and values are in correct format without comments in file") }
        
        print("Validating for duplicate keys in file: \(path)")
        
        return zip(keys, values).reduce(into: [String: String]()) { results, keyValue in
            if results[keyValue.0] != nil {
                printPretty("error: Found duplicate key: \(keyValue.0) in file: \(path)")
                abort()
            }
            results[keyValue.0] = keyValue.1
        }
    }
    
    ///
    ///
    /// - Returns: A list of LocalizationCodeFile - contains path of file and all keys in it
    static func localizedStringsInCode(filePaths: [String], options: FileReaderOptions) -> [LocalizationCodeFile] {
        filePaths.compactMap {
            let content = contents(atPath: $0).removingAllWhiteSpaces
            let regex = options.contains(.bruteForce) ? "\"(?!.*?%d)(.*?)\"" : "(?<=localizedString\\(forKey:)\\s?\"(?!.*?%d)(.*?)\""
            
            let matches = FileAnalyzer.regexFor(regex, content: content)
            print("file \($0) has \(matches.count) localizedStrings. \(matches)")
            
            return matches.isEmpty ? nil : LocalizationCodeFile(path: $0, keys: Set(matches.map({ $0.trimmingCharacters(in: .whitespacesAndNewlines) })))
        }
    }
}
