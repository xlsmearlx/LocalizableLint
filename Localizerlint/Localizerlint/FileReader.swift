//
//  FileReader.swift
//  Localizerlint
//
//  Created by Samuel Lagunes on 12/4/20.
//

import Foundation

struct FileReader {
    
    struct FileReaderOptions: OptionSet {
        let rawValue: Int8
        
        static let swiftui = FileReaderOptions(rawValue: 1)
        static let objectivec = FileReaderOptions(rawValue: 1 << 1)
        static let bruteForce = FileReaderOptions(rawValue: 1 << 2)
        static let verbose = FileReaderOptions(rawValue: 1 << 3)
        static let strict = FileReaderOptions(rawValue: 1 << 4)
    }
    
    /// Reads contents in path
    ///
    /// - Parameter path: path of file
    /// - Returns: content in file
    static func contentOfFile(atPath path: String) -> String {
        guard let data = FileManager.default.contents(atPath: path),
              let content = String(data: data, encoding: .utf8) else {
            Logger.print(log: BuildLog(message: "Unreadable path: \(path)", type: .error))
            abort()
        }
        
        return content
    }
    
    /// Parses contents of a file to localizable keys and values - Throws error if localizable file have duplicated keys
    ///
    /// - Parameter path: Localizable file paths
    /// - Returns: A list of LocalizedStringsFile - contains path of file and all keys in it
    static func readFiles(filePaths: [String], options: FileReaderOptions) -> [LocalizedStringsFile] {
        filePaths.compactMap { path in
            let rawContent = contentOfFile(atPath: path)
            let sanitizedContent = rawContent.removingAllWhiteSpaces
            let keys = FileAnalyzer.matchesFor(pattern: .localizedKeys, content: sanitizedContent)
            let values = FileAnalyzer.matchesFor(pattern: .localizedValues, content: sanitizedContent)
            
            if keys.count != values.count {
                Logger.print(log: BuildLog(file: path,
                                           message: "Make sure all keys and values are in correct format without comments in file: \(path)",
                                           type: .error))
                abort()
            }
            
            Logger.print(log: BuildLog(message: "Searching for duplicate keys in file: \(path)", type: .message))
            
            let linesContent = rawContent.components(separatedBy: "\n")
            var logs = [BuildLog]()
            let kv = zip(keys, values).reduce(into: [String: String]()) { results, keyValue in
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
    
    ///
    ///
    /// - Returns: A list of LocalizationCodeFile - contains path of file and all keys in it
    static func localizedStringsInCode(filePaths: [String], options: FileReaderOptions) -> [LocalizationCodeFile] {
        filePaths.compactMap {
            let content = contentOfFile(atPath: $0).removingAllWhiteSpaces
            
            var expresions = [FileAnalyzer.Pattern]()
            var matches = [String]()
            
            if options.contains(.bruteForce) {
                expresions.append(.bruteForce)
            } else {
                expresions.append(.bundleLocalized)
                options.contains(.swiftui) ? expresions.append(.swiftui) : nil
                expresions.append(.nslocalized)
                
                if options.contains(.objectivec) {
                    expresions.append(.bundleLocalizedObjc)
                }
            }
            
            expresions.forEach({ matches.append(contentsOf: FileAnalyzer.matchesFor(pattern: $0, content: content)) })
            
            if options.contains(.verbose) {
                Logger.print(log: BuildLog(message: "file \($0) has \(matches.count) localizedStrings. \(!matches.isEmpty ? "\(matches)" : "")",
                                           type: .message))
            }
            
            return matches.isEmpty ? nil : LocalizationCodeFile(path: $0, keys: Set(matches))
        }
    }
}
