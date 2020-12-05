////
//  main.swift
//  LocalizableLint
//
//  Created by Samuel Lagunes on 12/3/20.
//

import Foundation
import ArgumentParser

//if CommandLine.shouldAskForArguments {
    var input: String
    #if DEBUG
    //CommandLine.arguments.append("--help")
    CommandLine.arguments.append("/Users/slagunes/Developer/LocalizableLint/SampleApp/")
    CommandLine.arguments.append("--brute-force")
    CommandLine.arguments.append("--inclue-swift-ui")
    CommandLine.arguments.append("--include-objective-c")
    #else
    input = CommandLine.askForArgument(message: "Enter params in JSON format:")
    #endif

    //CommandLine.arguments.append(input)
//}

func printPretty(_ string: String) {
    print(string.replacingOccurrences(of: "\\", with: ""))
}

struct Localizerlint: ParsableCommand {
//    @Argument(help: "The phrase to repeat.")
//    var phrase: String

    @Argument(wrappedValue: "\(FileManager.default.currentDirectoryPath)/", help: "The root path of the project")
    var path: String

    @Flag(help: "Will validate againts all strings")
    var bruteForce = false
    
    @Flag(help: "Enables analyzer for Localized Strings in SwiftUI Format")
    var inclueSwiftUI = false
    
    @Flag(help: "Enables analyzer for Localized Strings in Objective-C Format")
    var includeObjectiveC = false
//
//    @Option(name: .shortAndLong, help: "The number of times to repeat 'phrase'.")
//    var count: Int?

    mutating func run() throws {
        print("------------ STARTING LINTNG ------------")
        
        var options:FileReaderOptions = []
        
        if bruteForce {
            options.update(with: .bruteForce)
        } else {
            inclueSwiftUI ? _ = options.update(with: .swiftui) : nil
            includeObjectiveC ? _ = options.update(with: .objectivec) : nil
        }
        
        #if DEBUG
        print("Analying path: \(path)")
        print("Brute force enabled: \(options.contains(.bruteForce))")
        print("SwiftUI enabled: \(options.contains(.swiftui))")
        print("Objective-C enabled: \(options.contains(.objectivec))")
        #endif

        let directory = DirectoryHelper(path: path)
        let filePaths = directory.localizableFiles
        let sourceFiles = directory.executableFiles
        
        let stringFiles = filePaths.map(LocalizationStringsFile.init(path:))
        let localizedKeysInCode = FileReader.localizedStringsInCode(filePaths: sourceFiles, options: options)

        FileAnalyzer.validateDeadKeys(localizedKeysInCode, localizationFiles: stringFiles)
    }
}

Localizerlint.main()
