//
//  JsonMaker.swift
//  LocalizerlintFramework
//
//  Created by Samuel Lagunes on 12/17/20.
//

import Foundation

public struct JSONMaker {
    
    public init() { }
    
    public func makeJSONFile(with files:[LocalizedStringsFile], at path: String) throws {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            try FileManager.default.createFile(atPath: "\(path)LocalizerlintReport.json", contents: encoder.encode(files), attributes: .none)
    }
}
