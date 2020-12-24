//
//  JsonMaker.swift
//  LocalizerlintFramework
//
//  Created by Samuel Lagunes on 12/17/20.
//

import Foundation

public struct JSONMaker {
    
    public init() { }
    
    /// Encodes and creates a json file at the given path.
    /// - Parameters:
    ///   - files: A list of LocalizedStringsFile.
    ///   - path: The path to create the file.
    /// - Throws: Error if FileManager fails to create the file.
    public func makeJSONFile(with files:[LocalizedStringsFile], at path: String) throws {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            try FileManager.default.createFile(atPath: "\(path)LocalizerlintReport.json", contents: encoder.encode(files), attributes: .none)
    }
}
