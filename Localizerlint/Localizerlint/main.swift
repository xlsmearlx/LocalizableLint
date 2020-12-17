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
    
    @Flag(help: "Search diplicate keys in Localized Strings files, ignoring any unused keys")
    var searchDuplicatesOnly = false
    
    @Flag(help: "Enables analyzer for Localized Strings in SwiftUI Format")
    var inclueSwiftUI = false
    
    @Flag(help: "Enables analyzer for Localized Strings in Objective-C Format")
    var includeObjectiveC = false
    
    @Flag(help: "Will validate againts all strings")
    var bruteForce = false
    
    @Flag(name: .shortAndLong, help: "Treats warnings as erros")
    var strict = false
    
    @Flag(name: .shortAndLong, help: "Shows details about the results of running Localizerlint")
    var verbose = false
    
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
            Logger.print(log: BuildLog(message: "Path: \(path)", type: .message))
            Logger.print(log: BuildLog(message: "Brute force enabled: \(options.contains(.bruteForce))", type: .message))
            Logger.print(log: BuildLog(message: "SwiftUI enabled: \(options.contains(.swiftui))", type: .message))
            Logger.print(log: BuildLog(message: "Objective-C enabled: \(options.contains(.objectivec))", type: .message))
            Logger.print(log: BuildLog(message: "Force enabled: \(strict)", type: .message))
            Logger.print(log: BuildLog(message: "Verbose enabled: \(verbose)", type: .message))
        }
        
        guard let directory = DirectoryHelper(path: path, options: options) else { throw FileReaderError.unreadablePath(path) }
        
        let stringFilesPath = directory.localizableFiles
        
        if verbose {
            Logger.print(log: BuildLog(message: "Available localizable files \(stringFilesPath.count)", type: .message))
            stringFilesPath.forEach({ Logger.print(log: BuildLog(message: "\($0)", type: .message)) })
        }
        
        let stringFiles = try FileReader.readFiles(filePaths: directory.localizableFiles)
        
        for stringFile in stringFiles {
            stringFile.ruleViolations.forEach({
                Logger.print(log: BuildLog(file: stringFile.path,
                                           line: $0.lineNumber,
                                           message: $0.type.description,
                                           type: strict ? .error : .warning))
                shouldAbort = true
            })
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
            
            let violations = try FileReader.evaluateKeys(codeFiles: localizedKeysInCode, localizationFiles: stringFiles, options: options)
            
            for violation in violations {
                violation.violations.forEach({
                    Logger.print(log: BuildLog(file: violation.path,
                                               line: $0.lineNumber,
                                               message: $0.type.description,
                                               type: strict ? .error : .warning))
                    shouldAbort = true
                })
            }
        }
        
        if shouldAbort {
            Localizerlint.exit(withError: LocalizerlintError.strictModeEnabled)
        }
    }
}

Localizerlint.main()
