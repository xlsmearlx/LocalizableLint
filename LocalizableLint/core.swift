////
////  core.swift
////  LocalizableLint
////
////  Created by Samuel Lagunes on 12/3/20.
////
//
//import Foundation
//
//fileprivate let fileManager = FileManager.default
//fileprivate let currentPath = fileManager.currentDirectoryPath
//fileprivate let rootPath = URL(string: currentPath).map({ $0.deletingLastPathComponent().absoluteString })!
//
////print("currentPath: \(currentPath) ")
////print("rootPath: \(rootPath)")
//
//
///// List of files in currentPath - recursive
//var pathFiles: [String] = {
//    guard let enumerator = fileManager.enumerator(atPath: rootPath),
//        let files = (enumerator.allObjects as? [String])
//        else { fatalError("Could not locate files in path directory: \(currentPath)") }
//    return files.map({rootPath + $0})
//}()
//
///// List of localizable files - not including Localizable files in the Pods
//var localizableFiles: [String] = {
//    print("------------ Searching for localizable files ------------")
//    let localizationFiles = pathFiles.filter { $0.hasSuffix("Localizable.strings") && !$0.contains("Pods") }
//
//    print("------------ Available localizable files ------------")
//    localizationFiles.forEach({ print($0) })
//    
//    return localizationFiles
//}()
//
//
///// List of executable files
//var executableFiles: [String] = {
//    return pathFiles.filter {
//        !$0.localizedCaseInsensitiveContains("test") &&
//            (NSString(string: $0).pathExtension == "swift" || NSString(string: $0).pathExtension == "m")
//    }
//}()
//
//
///// Reads contents in path
/////
///// - Parameter path: path of file
///// - Returns: content in file
//func contents(atPath path: String) -> String {
//    guard let data = fileManager.contents(atPath: path),
//          let content = String(data: data, encoding: .utf8)
//        else { fatalError("Could not read from path: \(path)") }
//    return content
//}
//
//
///// Returns a list of strings that match regex pattern from content
/////
///// - Parameters:
/////   - pattern: regex pattern
/////   - content: content to match
///// - Returns: list of results
//func regexFor(_ pattern: String, content: String) -> [String] {
//    guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else { fatalError("Regex not formatted correctly: \(pattern)")}
//    let matches = regex.matches(in: content, options: [], range: NSRange(location: 0, length: content.utf16.count))
//    return matches.map {
//        guard let range = Range($0.range(at: 0), in: content) else { fatalError("Incorrect range match") }
//        return String(content[range])
//    }
//}
//
//func create() -> [LocalizationStringsFile] {
//    return localizableFiles.map(LocalizationStringsFile.init(path:))
//}
//
/////
/////
///// - Returns: A list of LocalizationCodeFile - contains path of file and all keys in it
//func localizedStringsInCode() -> [LocalizationCodeFile] {
//    return executableFiles.compactMap {
//        //let content = contents(atPath: $0).removingAllWhiteSpaces
//        let content = contents(atPath: $0).filter({ !" \n\t\r".contains($0) })
//        let matches = regexFor("(?<=localizedString\\(forKey:)\\s?\"(?!.*?%d)(.*?)\"", content: content)
//
//        if $0.contains("CouponLogicRetry") {
//            print(content)
//            print("file \($0) has \(matches.count) localizedStrings. \(matches)")
//        }
//
//        return matches.isEmpty ? nil : LocalizationCodeFile(path: $0, keys: Set(matches.map({ $0.trimmingCharacters(in: .whitespacesAndNewlines) })))
//    }
//}
//
///// Throws warning if keys exist in localizable file but are not being used
/////
///// - Parameters:
/////   - codeFiles: Array of LocalizationCodeFile
/////   - localizationFiles: Array of LocalizableStringFiles
//func validateDeadKeys(_ codeFiles: [LocalizationCodeFile], localizationFiles: [LocalizationStringsFile]) {
//    print("total code files: \(codeFiles.count)")
//    print("total localizationFiles files: \(localizationFiles.count)")
//    let allCodeFileKeys = Set(codeFiles.flatMap { $0.keys })
//
//    localizationFiles.forEach { (stringsFile) in
//        let baseKeys = Set(stringsFile.keys)
//        let deadKeys = baseKeys.subtracting(allCodeFileKeys)
//        
//        print("file: \(stringsFile.path) has \(baseKeys.count) keys and \(deadKeys.count) deadKeys")
//        deadKeys.forEach({ printPretty("warning: \($0) - Suggest cleaning dead keys") })
//    }
//}
//
//
//struct ContentParser {
//
//    /// Parses contents of a file to localizable keys and values - Throws error if localizable file have duplicated keys
//    ///
//    /// - Parameter path: Localizable file paths
//    /// - Returns: localizable key and value for content at path
//    static func parse(_ path: String) -> [String: String] {
//        let content = contents(atPath: path)
//        let trimmed = content
//            .replacingOccurrences(of: "\n+", with: "", options: .regularExpression, range: nil)
//            .trimmingCharacters(in: .whitespacesAndNewlines)
//        let keys = regexFor("\"([^\"]*?)\"(?= =)", content: trimmed)
//        let values = regexFor("(?<== )\"(.*?)\"(?=;)", content: trimmed)
//        if keys.count != values.count { fatalError("File: \(path)\nError parsing contents: Make sure all keys and values are in correct format without comments in file") }
//        print("Validating file: \(path)")
//        
//        return zip(keys, values).reduce(into: [String: String]()) { results, keyValue in
//            if results[keyValue.0] != nil {
//                printPretty("error: Found duplicate key: \(keyValue.0) in file: \(path)")
//                abort()
//            }
//            results[keyValue.0] = keyValue.1
//        }
//    }
//}

//func printPretty(_ string: String) {
//    print(string.replacingOccurrences(of: "\\", with: ""))
//}

////print("------------ Validating for duplicate keys ------------")
////let stringFiles = create()
////let codeFiles = localizedStringsInCode()
////
////print("------------ Checking for any dead keys in localizable file -----------")
////validateDeadKeys(codeFiles, localizationFiles: stringFiles)
////
//////print("------------ Sort and remove whitespaces ------------")
////// stringFiles.forEach { $0.cleanWrite() }
////
////print("------------ SUCCESS ------------")
