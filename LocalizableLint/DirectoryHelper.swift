//
//  DirectoryHelper.swift
//  LocalizableLint
//
//  Created by Samuel Lagunes on 12/4/20.
//

import Foundation

final class DirectoryHelper {
    var path: String
    
    init(path: String) {
        self.path = path
    }
    
    /// List of files in currentPath - recursive
    private var pathFiles: [String] {
        guard let enumerator = FileManager.default.enumerator(atPath: path),
            let files = (enumerator.allObjects as? [String])
            else { fatalError("Could not locate files in path directory: \(path)") }
        return files.map({path + $0})
    }

    /// List of localizable files - not including Localizable files in the Pods
    var localizableFiles: [String] {
        print("------------ Searching for localization files ------------")
        //let localizationFiles = pathFiles.filter { $0.hasSuffix("Localizable.strings") && !$0.contains("Pods") }
        let localizationFiles = pathFiles.filter { $0.hasSuffix(".strings") && !$0.contains("Pods") }

        #if DEBUG
        print("------------ Available localizable files \(localizationFiles.count) ------------")
        localizationFiles.forEach({ print($0) })
        #endif
        
        return localizationFiles
    }
    
    /// List of executable files
    var executableFiles: [String] {
        print("------------ Searching for source files ------------")
        let paths = pathFiles.filter {
            !$0.localizedCaseInsensitiveContains("test")
                && (NSString(string: $0).pathExtension == "swift" || NSString(string: $0).pathExtension == "m")
        }
        
        #if DEBUG
        print("------------ Available source files \(paths.count) ------------")
        paths.forEach({ print($0) }) 
        #endif
        
        return paths
    }

}
