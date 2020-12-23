//
//  main.swift
//  Localizerlint
//
//  Created by Samuel Lagunes on 12/3/20.
//

import Foundation
import ArgumentParser
import LocalizerlintFramework

struct Localizerlint: ParsableCommand {
    @Argument(wrappedValue: "\(FileManager.default.currentDirectoryPath)/", help: "The root path of the project")
    var path: String
    
    @Flag(wrappedValue: false, help: "Search diplicate keys in Localized Strings files, ignoring any unused keys")
    var searchDuplicatesOnly: Bool
    
    @Flag(wrappedValue: false, help: "Enables analyzer for Localized Strings in SwiftUI Format")
    var inclueSwiftUI: Bool
    
    @Flag(wrappedValue: false, help: "Enables analyzer for Localized Strings in Objective-C Format")
    var includeObjectiveC: Bool
    
    @Flag(wrappedValue: false, help: "Will validate againts all strings")
    var bruteForce: Bool
    
    @Flag(wrappedValue: false, name: .long, help: "Treats warnings as errors")
    var strict: Bool
    
    @Option(wrappedValue: .xcode, name: .long, help: "Choose output reporter. Available: xcode, json", transform: OutputType.init)
    var reporter: OutputType
    
    @Flag(wrappedValue: false, name: .long, help: "Enable debug logs")
    var verbose: Bool
    
    mutating func run() throws {
        var options:FileReaderOptions = []
        var shouldAbort = false
        
        if bruteForce {
            options.update(with: .bruteForce)
        } else {
            inclueSwiftUI ? _ = options.update(with: .swiftui) : nil
            includeObjectiveC ? _ = options.update(with: .objectivec) : nil
        }
        
        if verbose {
            Logger.print(log: BuildLog(message: "ARGUMENTS:", type: .message))
            Logger.print(log: BuildLog(message: "<path>: \(path)", type: .message))
            Logger.print(log: BuildLog(message: "OPTIONS:", type: .message))
            Logger.print(log: BuildLog(message: "--search-duplicates-only: \(searchDuplicatesOnly)", type: .message))
            Logger.print(log: BuildLog(message: "--inclue-swift-ui: \(options.contains(.swiftui))", type: .message))
            Logger.print(log: BuildLog(message: "--include-objective-c: \(options.contains(.objectivec))", type: .message))
            Logger.print(log: BuildLog(message: "--brute-force: \(options.contains(.bruteForce))", type: .message))
            Logger.print(log: BuildLog(message: "--strict: \(strict)", type: .message))
            Logger.print(log: BuildLog(message: "--reporter: \(reporter)", type: .message))
            Logger.print(log: BuildLog(message: "--verbose: \(verbose)", type: .message))
        }
        
        guard let directory = DirectoryHelper(path: path, options: options) else { throw FileReaderError.unreadablePath(path) }
        
        let stringFilesPath = directory.localizableFiles
        
        if verbose {
            Logger.print(log: BuildLog(message: "Available localizable files \(stringFilesPath.count)", type: .message))
            stringFilesPath.forEach({ Logger.print(log: BuildLog(message: "\($0)", type: .message)) })
        }
        
        var stringFiles = try FileReader.readFiles(filePaths: directory.localizableFiles)
        
        if verbose {
            stringFiles.forEach({ Logger.print(log: BuildLog.init(message: $0.description, type: .message)) })
        }
        
        if !searchDuplicatesOnly {
            Logger.print(log: BuildLog(message: "Searching for unused keys", type: .message))
            
            let codeFiles = directory.executableFiles
            
            if verbose {
                Logger.print(log: BuildLog(message: "Available source files \(codeFiles.count)", type: .message))
                codeFiles.forEach({ Logger.print(log: BuildLog(message: $0, type: .message)) })
            }
            
            let localizedKeysInCode = try FileReader.localizedStringsInCode(filePaths: codeFiles, options: options)
            
            if verbose {
                Logger.print(log: BuildLog(message: "Source files with localization: \(localizedKeysInCode.count)", type: .message))
                Logger.print(log: BuildLog(message: "LocalizationFiles files: \(stringFiles.count)", type: .message))
                
                localizedKeysInCode.forEach({
                    Logger.print(log: BuildLog(message: $0.description, type: .message))
                })
            }
            
            try FileReader.evaluateKeys(codeFiles: localizedKeysInCode,
                                        localizationFiles: &stringFiles,
                                        options: options)
        }
        
        switch reporter {
        case .json:
            try JSONMaker().makeJSONFile(with: stringFiles, at: path)
        case .xcode:
            stringFiles.forEach({ file in
                Logger.print(log: BuildLog(message: "\(file.path) violations \(file.ruleViolations)", type: .message))
                file.ruleViolations.forEach { rule in
                    var type: LogType
                    
                    if strict {
                        type = .error
                        shouldAbort = true
                    } else {
                        type = rule.type.isDuplicate ? .error : .warning
                    }
                    
                    Logger.print(log: BuildLog(file: file.path,
                                               line: rule.lineNumber,
                                               message: rule.type.description,
                                               type: type))
                }
            })
        default:
            break
        }
        
        if strict && shouldAbort {
            Localizerlint.exit(withError: LocalizerlintError.strictModeEnabled)
        }
    }
}

Localizerlint.main()
