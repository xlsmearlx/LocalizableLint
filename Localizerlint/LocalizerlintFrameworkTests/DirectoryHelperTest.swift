//
//  DirectoryHelperTest.swift
//  LocalizerlintFrameworkTests
//
//  Created by Samuel Lagunes on 12/15/20.
//

import XCTest
@testable import LocalizerlintFramework

class DirectoryHelperTest: XCTestCase {
    var tmpDirId: String!
    var tmpDir: String!
    
    override func setUpWithError() throws {
        tmpDirId = UUID().uuidString
        tmpDir = try FileManager.default.createTemporaryDirectory(name: tmpDirId)
        
        FileManager.default.createFile(atPath: "\(tmpDir!)/localized.strings", contents: localizedStrings.data(using: .utf8), attributes: .none)
        FileManager.default.createFile(atPath: "\(tmpDir!)/file.swift", contents: localizedCode.data(using: .utf8), attributes: .none)
        FileManager.default.createFile(atPath: "\(tmpDir!)/file.m", contents: localizedCodeObjectiveC.data(using: .utf8), attributes: .none)
    }
    
    override func tearDownWithError() throws {
        try FileManager.default.deleteTemporaryDirectory(name: tmpDirId)
        tmpDirId = .none
        tmpDir = .none
    }
    
    func testInit()  {
        let sut = DirectoryHelper(path: "path", options: [.verbose])
        
        XCTAssertEqual(sut.path, "path")
        XCTAssertEqual(sut.options, [.verbose])
    }
    
    func testPathFilesSuccess() {
        let sut = DirectoryHelper(path: tmpDir!, options: [])
        XCTAssertEqual(sut.pathFiles.count, 3)
    }

    func testLocalizableFiles() {
        let sut = DirectoryHelper(path: tmpDir!, options: [])
        XCTAssertEqual(sut.localizableFiles.count, 1)
    }
    
    func testExecutableFilesShouldRetrieveSwiftFilesOnly() throws {
        let sut = DirectoryHelper(path: tmpDir!, options: [])
        XCTAssertEqual(sut.executableFiles.count, 1)
    }
    
    func testExecutableFilesObjectiveCEnabled() throws {
        let sut = DirectoryHelper(path: tmpDir!, options: [.objectivec])
        XCTAssertEqual(sut.executableFiles.count, 2)
    }
}

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
