//
//  FileReader.swift
//  Localizerlint
//
//  Created by Samuel Lagunes on 12/4/20.
//

import Foundation


public struct FileReader {
    
    /// Reads contents in path.
    /// - Parameter path: path of file.
    /// - Throws: FileReaderError if the path is not valid.
    /// - Returns: content in file.
    public static func contentOfFile(atPath path: String) throws -> String {
        guard let data = FileManager.default.contents(atPath: path),
              let content = String(data: data, encoding: .utf8) else {
            Logger.print(log: BuildLog(message: "Unreadable path: \(path)", type: .error))
            throw FileReaderError.unreadablePath(path)
        }
        
        return content
    }
    
    /// Search the given Localization files paths and evaluates the content againts the desired pattern.
    /// - Parameters:
    ///   - filePaths: The paths to the localization files (.strings).
    ///   - options: FileReaderOptions that will set the type of patterns that the NSRegularExpression will use.
    /// - Throws: Error if the regular expression fails.
    /// - Returns: A list of LocalizationCodeFile - contains path of file and all keys in it.
    public static func localizedStringsInCode(filePaths: [String], options: FileReaderOptions) throws -> [LocalizationCodeFile] {
        try filePaths.compactMap {
            let content = try contentOfFile(atPath: $0).removingAllWhiteSpaces
            var expresions = [RegexPattern]()
            var matches = [String]()
            
            if options.contains(.bruteForce) {
                expresions.append(.bruteForce)
            } else {
                expresions.append(.bundleLocalized)
                expresions.append(.nslocalized)
                options.contains(.swiftui) ? expresions.append(.swiftui) : nil
                options.contains(.objectivec) ? expresions.append(.bundleLocalizedObjc) : nil
            }
            
            try expresions.forEach({ matches.append(contentsOf: try RegexEvaluator.matchesFor(pattern: $0, content: content)) })
            
            return matches.isEmpty ? nil : LocalizationCodeFile(path: $0, keys: Set(matches))
        }
    }
        
    /// Parses contents of a file to localizable keys and values.
    /// - Parameter filePaths: Localizable file paths.
    /// - Throws: Error if localizable file have duplicated keys.
    /// - Returns: A list of LocalizedStringsFile - contains path of file and all keys in it.
    public static func readFiles(filePaths: [String]) throws -> [LocalizedStringsFile] {
        try filePaths.compactMap { path in
            let rawContent = try contentOfFile(atPath: path)
            let linesContent = rawContent.components(separatedBy: "\n")
            let sanitizedContent = rawContent.removingAllWhiteSpaces
            let kvMatches: RegexEvaluator.KeyValueMatch = try RegexEvaluator.matchFor(pattern: .localizedString, content: sanitizedContent)
            var ruleViolations = [RuleViolation]()
            
            Logger.print(log: BuildLog(message: "Searching for duplicate keys in file: \(path)", type: .message))

            let kv = zip(kvMatches.keys, kvMatches.values).reduce(into: [String: String]()) { results, keyValue in
                if results[keyValue.0] != nil {
                    ruleViolations.append(
                        .init(lineNumber: linesContent.firstIndex(where: { $0.contains("\(keyValue.0)") }).map({ $0+1 }),
                              type: .duplicatedKey(key: keyValue.0))
                    )
                }
                results[keyValue.0] = keyValue.1
            }
            
            return LocalizedStringsFile(path: path, kv: kv, ruleViolations: ruleViolations)
        }
    }
    
    /// Throws warning if keys exist in localizable file but are not being used.
    /// - Parameters:
    ///   - codeFiles: Array of LocalizationCodeFile.
    ///   - localizationFiles: Array of LocalizableStringFiles.
    /// - Throws: Error if the reader fails to load the content of the given paths.
    public static func evaluateKeys(codeFiles: [LocalizationCodeFile],
                                    localizationFiles: inout [LocalizedStringsFile]) throws {
        let allCodeFileKeys = Set(codeFiles.flatMap { $0.keys })
                
        localizationFiles = try localizationFiles.map { stringsFile in
            var stringsFile = stringsFile
            let baseKeys = Set(stringsFile.keys)
            let deadKeys = baseKeys.subtracting(allCodeFileKeys)
            var memoKeys: [String: [String]] = [:]
            
            Logger.print(log: BuildLog(message: "KEYS: \(baseKeys.count) | DEADKEYS: \(deadKeys.count) | \(stringsFile.path)", type: .message))
            
            try deadKeys.forEach({ key in
                if memoKeys[stringsFile.path] == nil {
                    memoKeys[stringsFile.path] = try FileReader.contentOfFile(atPath: stringsFile.path).components(separatedBy: "\n")
                }
                
                stringsFile.ruleViolations.append(
                    .init(lineNumber: memoKeys[stringsFile.path]!.firstIndex(where: { $0.contains(key) }).map({ $0+1 }),
                          type: .unusedKey(key: key))
                )
            })
            
            return stringsFile
        }
    }
}
