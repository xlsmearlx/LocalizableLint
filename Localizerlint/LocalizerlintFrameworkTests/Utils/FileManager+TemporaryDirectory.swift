//
//  FileManager+TemporaryDirectory.swift
//  LocalizerlintFrameworkTests
//
//  Created by Samuel Lagunes on 23/12/20.
//

import Foundation

extension FileManager{    
    func createTemporaryDirectory(name: String) throws -> String {
        let url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(name, isDirectory: true)
        try createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        print("Temporal Directory: \(url.path)")
        return url.path
    }
    
    func deleteTemporaryDirectory(name: String) throws {
        let url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(name, isDirectory: true)
        try removeItem(at: url)
        print("Deleted Temporal Directory: \(url.path)")
    }
}
