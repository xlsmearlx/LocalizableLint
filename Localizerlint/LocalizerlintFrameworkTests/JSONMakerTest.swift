//
//  JSONMakerTest.swift
//  LocalizerlintFrameworkTests
//
//  Created by Samuel Lagunes on 23/12/20.
//

import XCTest
@testable import LocalizerlintFramework

class JSONMakerTest: XCTestCase {
    var tmpDirId: String!
    var tmpDir: String!
    
    override func setUpWithError() throws {
        tmpDirId = UUID().uuidString
        tmpDir = try FileManager.default.createTemporaryDirectory(name: tmpDirId)
    }
    
    override func tearDownWithError() throws {
        try FileManager.default.deleteTemporaryDirectory(name: tmpDirId)
        tmpDirId = .none
        tmpDir = .none
    }

    func testMakerCreateAFileAtGivenPath() throws {
        let sut = JSONMaker()
        let file = LocalizedStringsFile(path: "DemoPath", kv: [:], ruleViolations: [])
        try sut.makeJSONFile(with: [file], at: "\(tmpDir!)/")
        
        FileManager.default.fileExists(atPath: "\(tmpDir!)/LocalizerlintReport.json")
    }

}
