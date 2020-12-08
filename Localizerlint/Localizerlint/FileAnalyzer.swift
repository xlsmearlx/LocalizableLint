//
//  FileAnalyzer.swift
//  Localizerlint
//
//  Created by Samuel Lagunes on 12/4/20.
//

import Foundation

struct FileAnalyzer {
    
    enum Pattern {
        case bruteForce
        case swiftui
        case bundleLocalized
        case bundleLocalizedObjc
        case nslocalized
        case localizedKeys
        case localizedValues
        case custom(String)
        
        var expression: String {
            switch self {
            case .bruteForce: return "\"(?!.*?%d)(.*?)\""
            case .swiftui: return "(?<=Text\\()\\s?\"(?!.*?%d)(.*?)\""
            case .bundleLocalized: return "(?<=localizedString\\(forKey:)\\s?\"(?!.*?%d)(.*?)\""
            case .bundleLocalizedObjc: return "(?<=localizedStringForKey:)\\s?@?\"(?!.*?%d)(.*?)\""
            case .nslocalized: return "(?<=NSLocalizedString\\()\\s?@?\"(?!.*?%d)(.*?)\""
            case .localizedKeys: return "\"([^\"]*?)\"(?==)"
            case .localizedValues: return "(?<==)\"(.*?)\"(?=;)"
            case .custom(let value): return value
            }
        }
    }
    
    /// Returns a list of strings that match regex pattern from content
    ///
    /// - Parameters:
    ///   - pattern: regex pattern
    ///   - content: content to match
    /// - Returns: list of results
    static func matchesFor(pattern: Pattern, content: String) -> [String] {
        guard let regex = try? NSRegularExpression(pattern: pattern.expression, options: []) else {
            Logger.print(log: BuildLog(message: "Invalid regex format: \(pattern)", type: .error))
            abort()
        }
        
        let matches = regex.matches(in: content,
                                    options: [],
                                    range: NSRange(location: 0, length: content.utf16.count))
        
        return matches.map {
            guard let range = Range($0.range(at: 0), in: content) else {
                Logger.print(log: BuildLog(message: "Incorrect range match", type: .error))
                abort()
            }
            
            return String(content[range])
        }
    }
    
    /// Throws warning if keys exist in localizable file but are not being used
    ///
    /// - Parameters:
    ///   - codeFiles: Array of LocalizationCodeFile
    ///   - localizationFiles: Array of LocalizableStringFiles
    static func evaluateKeys(codeFiles: [LocalizationCodeFile], localizationFiles: [LocalizedStringsFile], options: FileReader.FileReaderOptions) {
        let allCodeFileKeys = Set(codeFiles.flatMap { $0.keys })
        
        localizationFiles.forEach { stringsFile in
            let baseKeys = Set(stringsFile.keys)
            let deadKeys = baseKeys.subtracting(allCodeFileKeys)
            
            Logger.print(log: BuildLog(message: "KEYS: \(baseKeys.count) | DEADKEYS: \(deadKeys.count) | \(stringsFile.path)", type: .message))
            
            var memoKeys: [String: [String]] = [:]
            var logs = [BuildLog]()
            
            deadKeys.forEach({ key in
                if memoKeys[stringsFile.path] == nil {
                    memoKeys[stringsFile.path] = FileReader.contentOfFile(atPath: stringsFile.path).components(separatedBy: "\n")
                }
                
                logs.append(BuildLog(file: stringsFile.path,
                                     line: memoKeys[stringsFile.path]!.firstIndex(where: { $0.contains(key) }).map({ $0+1 }),
                                     message: "\(key) was defines but never used",
                                     type: options.contains(.strict) ? .error : .warning))
            })
            
            if !logs.isEmpty {
                Logger.print(logs: logs)
                options.contains(.strict) ? abort() : nil
            }
        }
    }
}
