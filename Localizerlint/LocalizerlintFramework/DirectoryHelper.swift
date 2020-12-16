//
//  DirectoryHelper.swift
//  Localizerlint
//
//  Created by Samuel Lagunes on 12/4/20.
//

import Foundation

public final class DirectoryHelper {
    var path: String
    var options: FileReaderOptions
    
    /// List of files in currentPath - recursive
    lazy var pathFiles: [String] = {
        guard let enumerator = FileManager.default.enumerator(atPath: path),
              let files = (enumerator.allObjects as? [String]) else {
            Logger.print(log: BuildLog(message: "Could not locate files in path directory: \(path)", type: .error))
            abort()
        }
        return files.map({path + $0})
    }()
    
    public init(path: String, options: FileReaderOptions) {
        self.path = path
        self.options = options
    }
    
    /// List of localizable files - not including Localizable files in the Pods
    public var localizableFiles: [String] {
        Logger.print(log: BuildLog(message: "Searching for localization files", type: .message))
        let localizationFiles = pathFiles.filter { $0.hasSuffix(".strings") && !$0.contains("Pods") }
        
        if options.contains(.verbose) {
            Logger.print(log: VerboseLog(message: "Available localizable files \(localizationFiles.count)"))
            localizationFiles.forEach({ Logger.print(log: VerboseLog(message: $0)) })
        }
        
        return localizationFiles
    }
    
    /// List of executable files
    public var executableFiles: [String] {
        Logger.print(log: BuildLog(message: "Searching for source files", type: .message))
        let paths = pathFiles.filter {
            if options.contains(.objectivec) {
                return !$0.localizedCaseInsensitiveContains("test") && (NSString(string: $0).pathExtension == "swift" || NSString(string: $0).pathExtension == "m")
            } else {
                return !$0.localizedCaseInsensitiveContains("test") && NSString(string: $0).pathExtension == "swift"
            }
        }
        
        if options.contains(.verbose) {
            Logger.print(log: VerboseLog(message: "Available source files \(paths.count)"))
            paths.forEach({ Logger.print(log: VerboseLog(message: $0)) })
        }
        
        return paths
    }
}
