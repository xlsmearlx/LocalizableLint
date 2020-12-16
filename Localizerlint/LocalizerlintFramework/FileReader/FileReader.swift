//
//  FileReader.swift
//  Localizerlint
//
//  Created by Samuel Lagunes on 12/4/20.
//

import Foundation


public struct FileReader {
    /// Reads contents in path
    /// - Parameter path: path of file
    /// - Returns: content in file
    public static func contentOfFile(atPath path: String) throws -> String {
        guard let data = FileManager.default.contents(atPath: path),
              let content = String(data: data, encoding: .utf8) else {
            Logger.print(log: BuildLog(message: "Unreadable path: \(path)", type: .error))
            throw FileReaderError.unreadablePath(path)
        }

        return content
    }
    
    /// Parses contents of a file to localizable keys and values - Throws error if localizable file have duplicated keys
    /// - Parameters:
    ///   - filePaths: Localizable file paths
    ///   - options: <#options description#>
    /// - Returns: A list of LocalizedStringsFile - contains path of file and all keys in it
    public static func readFiles(filePaths: [String], options: FileReaderOptions) throws -> [LocalizedStringsFile] {
        try filePaths.compactMap { path in
            let rawContent = try contentOfFile(atPath: path)
            let sanitizedContent = rawContent.removingAllWhiteSpaces
            
            let kvMatches: RegexEvaluator.KeyValueMatch = try RegexEvaluator.matchesFor(pattern: .localizedString, content: sanitizedContent)
            
            Logger.print(log: BuildLog(message: "Searching for duplicate keys in file: \(path)", type: .message))
            
            let linesContent = rawContent.components(separatedBy: "\n")
            var logs = [BuildLog]()
            
            let kv = zip(kvMatches.keys, kvMatches.values).reduce(into: [String: String]()) { results, keyValue in
                if results[keyValue.0] != nil {
                    logs.append(.init(file: path,
                                      line: linesContent.firstIndex(where: { $0.contains("\(keyValue.0)") }).map({ $0+1 }),
                                      message: "Found duplicate key: \(keyValue.0) in file: \(path)",
                                      type: .error))
                }
                results[keyValue.0] = keyValue.1
            }
            
            if !logs.isEmpty {
                Logger.print(logs: logs)
                options.contains(.strict) ? abort() : nil
            }
            
            return LocalizedStringsFile(path: path, kv: kv)
        }
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - filePaths: <#filePaths description#>
    ///   - options: <#options description#>
    /// - Returns: A list of LocalizationCodeFile - contains path of file and all keys in it
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
            
            if options.contains(.verbose) {
                Logger.print(log: BuildLog(message: "file \($0) has \(matches.count) localizedStrings. \(!matches.isEmpty ? "\(matches)" : "")", type: .message))
            }
            
            return matches.isEmpty ? nil : LocalizationCodeFile(path: $0, keys: Set(matches))
        }
    }
    
    /// Throws warning if keys exist in localizable file but are not being used
    ///
    /// - Parameters:
    ///   - codeFiles: Array of LocalizationCodeFile
    ///   - localizationFiles: Array of LocalizableStringFiles
    public static func evaluateKeys(codeFiles: [LocalizationCodeFile], localizationFiles: [LocalizedStringsFile], options: FileReaderOptions) throws -> [BuildLog] {
        let allCodeFileKeys = Set(codeFiles.flatMap { $0.keys })
        var logs = [BuildLog]()
        
        for stringsFile in localizationFiles {
            let baseKeys = Set(stringsFile.keys)
            let deadKeys = baseKeys.subtracting(allCodeFileKeys)
            
            Logger.print(log: BuildLog(message: "KEYS: \(baseKeys.count) | DEADKEYS: \(deadKeys.count) | \(stringsFile.path)", type: .message))
            
            var memoKeys: [String: [String]] = [:]
            
            try deadKeys.forEach({ key in
                if memoKeys[stringsFile.path] == nil {
                    memoKeys[stringsFile.path] = try FileReader.contentOfFile(atPath: stringsFile.path).components(separatedBy: "\n")
                }
                
                logs.append(.init(file: stringsFile.path,
                                     line: memoKeys[stringsFile.path]!.firstIndex(where: { $0.contains(key) }).map({ $0+1 }),
                                     message: "\(key) was defines but never used",
                                     type: options.contains(.strict) ? .error : .warning))
            })
        }
        
        return logs
    }
}
