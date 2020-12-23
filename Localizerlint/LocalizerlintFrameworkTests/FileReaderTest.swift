//
//  FileReaderTest.swift
//  LocalizerlintFrameworkTests
//
//  Created by Samuel Lagunes on 12/14/20.
//

import XCTest
@testable import LocalizerlintFramework

class FileReaderTest: XCTestCase {
    var tmpDirId: String!
    var tmpDir: String!
    
    override func setUpWithError() throws {
        tmpDirId = UUID().uuidString
        tmpDir = try FileManager.default.createTemporaryDirectory(name: tmpDirId)
        
        FileManager.default.createFile(atPath: "\(tmpDir!)/localized.strings", contents: localizedStrings.data(using: .utf8), attributes: .none)
        FileManager.default.createFile(atPath: "\(tmpDir!)/emptyFile.swift", contents: .none, attributes: .none)
        FileManager.default.createFile(atPath: "\(tmpDir!)/file.swift", contents: localizedCode.data(using: .utf8), attributes: .none)
        FileManager.default.createFile(atPath: "\(tmpDir!)/file.m", contents: localizedCodeObjectiveC.data(using: .utf8), attributes: .none)
    }
    
    override func tearDownWithError() throws {
        try FileManager.default.deleteTemporaryDirectory(name: tmpDirId)
        tmpDirId = .none
        tmpDir = .none
    }
    
    func testLoadFileContentSuccess() {
        XCTAssertNoThrow(try FileReader.contentOfFile(atPath: "\(tmpDir!)/localized.strings"))
    }
    
    func testLoadFileContentFailThrowsError() {
        XCTAssertThrowsError(try FileReader.contentOfFile(atPath: "\(tmpDir!)/invalidLocalizedPath.strings"), "") { (error) in
            XCTAssert(error is FileReaderError)
            XCTAssertEqual(error.localizedDescription, "Unreadable path: \(tmpDir!)/invalidLocalizedPath.strings")
        }
    }
    
    func testReadLocalizedFile() throws {
        let output = try FileReader.readFiles(filePaths: ["\(tmpDir!)/localized.strings"])
        XCTAssertEqual(output.count, 1)
        XCTAssertEqual(output[0].path, "\(tmpDir!)/localized.strings")
        XCTAssertEqual(output[0].keys.count, 4)
    }
    
    func testReadFilesHaveDuplicatedKeysViolations() throws {
        let sut = try FileReader.readFiles(filePaths: ["\(tmpDir!)/localized.strings"])
        XCTAssertEqual(sut[0].ruleViolations.count, 1)
    }

    func testLocalizedStringsInCodeBruteForce() throws {
        let output = try FileReader.localizedStringsInCode(filePaths: ["\(tmpDir!)/file.swift", "\(tmpDir!)/file.m"], options: [.bruteForce])
        XCTAssertEqual(output.count, 2)
        XCTAssertEqual(output[0].path, "\(tmpDir!)/file.swift")
        XCTAssertEqual(output[0].keys.count, 5)
        XCTAssertEqual(output[1].path, "\(tmpDir!)/file.m")
        XCTAssertEqual(output[1].keys.count, 4)
    }

    func testLocalizedStringsInCodeDefaultSearch() throws {
        let output = try FileReader.localizedStringsInCode(filePaths: ["\(tmpDir!)/file.swift", "\(tmpDir!)/file.m"], options: [])
        XCTAssertEqual(output.count, 2)
        XCTAssertEqual(output[0].path, "\(tmpDir!)/file.swift")
        XCTAssertEqual(output[0].keys.count, 2)
        XCTAssertEqual(output[1].path, "\(tmpDir!)/file.m")
        XCTAssertEqual(output[1].keys.count, 1)
    }


    func testLocalizedStringsInCodeWithOptions() throws {
        let output = try FileReader.localizedStringsInCode(filePaths: ["\(tmpDir!)/file.swift", "\(tmpDir!)/file.m"], options: [.swiftui, .objectivec])
        XCTAssertEqual(output.count, 2)
        XCTAssertEqual(output[0].path, "\(tmpDir!)/file.swift")
        XCTAssertEqual(output[0].keys.count, 3)
        XCTAssertEqual(output[1].path, "\(tmpDir!)/file.m")
        XCTAssertEqual(output[1].keys.count, 2)
    }

    func testLocalizedStringsInCodeWithNoResults() throws {
        let output = try FileReader.localizedStringsInCode(filePaths: ["\(tmpDir!)/emptyFile.swift"], options: [])
        XCTAssertEqual(output.count, 0)
    }
    
    func testEvaluateKeysShouldFoundTwoDeadKeys() throws {
        var localizableString = try FileReader.readFiles(filePaths: ["\(tmpDir!)/localized.strings"])
        let codefiles = try FileReader.localizedStringsInCode(filePaths: ["\(tmpDir!)/file.swift", "\(tmpDir!)/file.m"], options: [])
        try FileReader.evaluateKeys(codeFiles: codefiles, localizationFiles: &localizableString, options: [])
        XCTAssertEqual(localizableString[0].ruleViolations.count, 3)
        XCTAssertEqual(localizableString[0].path, "\(tmpDir!)/localized.strings")
    }
}
