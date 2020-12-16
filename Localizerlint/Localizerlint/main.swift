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
        
        let directory = DirectoryHelper(path: path, options: options)
        
        do {
            let stringFiles = try FileReader.readFiles(filePaths: directory.localizableFiles, options: options)
            
            if !searchDuplicatesOnly {
                Logger.print(log: BuildLog(message: "Searching for unused keys", type: .message))
                
                let localizedKeysInCode = try FileReader.localizedStringsInCode(filePaths: directory.executableFiles, options: options)
                
                if verbose {
                    Logger.print(log: BuildLog(message: "Source files with localization: \(localizedKeysInCode.count)", type: .message))
                    Logger.print(log: BuildLog(message: "LocalizationFiles files: \(stringFiles.count)", type: .message))
                }
                
                let logs = try FileReader.evaluateKeys(codeFiles: localizedKeysInCode, localizationFiles: stringFiles, options: options)
                
                if !logs.isEmpty {
                    Logger.print(logs: logs)
                    options.contains(.strict) ? abort() : nil
                }
            }
        } catch {
            Logger.print(log: BuildLog(message: error.localizedDescription, type: .message))
            abort()
        }
    }
}

Localizerlint.main()
