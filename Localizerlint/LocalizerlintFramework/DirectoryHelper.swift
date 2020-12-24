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
    
    /// List of files in currentPath - recursive.
    var pathFiles: [String]
    
    /// Initializer for DirectoryHelper.
    /// - Parameters:
    ///   - path: The root path to search for files.
    ///   - options: FileReaderOptions to determine file extensions.
    public init?(path: String, options: FileReaderOptions) {
        self.path = path
        self.options = options
        
        guard let enumerator = FileManager.default.enumerator(atPath: path),
              let files = (enumerator.allObjects as? [String]) else {
            Logger.print(log: BuildLog(message: "Could not locate files in path directory: \(path)", type: .error))
            return nil
        }
        
        self.pathFiles = files.map({path + $0})
    }
    
    /// List of LocalizedStrings files - excluding files in the Pods.
    public var localizableFiles: [String] {
        Logger.print(log: BuildLog(message: "Searching for localization files", type: .message))
        return pathFiles.filter { $0.hasSuffix(".strings") && !$0.contains("Pods") }
    }
    
    /// List of source files - excluding UnitTests files.
    public var executableFiles: [String] {
        Logger.print(log: BuildLog(message: "Searching for source files", type: .message))
        return pathFiles.filter {
            if options.contains(.objectivec) {
                return !$0.localizedCaseInsensitiveContains("test") && (NSString(string: $0).pathExtension == "swift" || NSString(string: $0).pathExtension == "m")
            }
            return !$0.localizedCaseInsensitiveContains("test") && NSString(string: $0).pathExtension == "swift"
        }
    }
}
