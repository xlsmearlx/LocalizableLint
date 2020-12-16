//
//  BuildLogTest.swift
//  LocalizerLintTest
//
//  Created by Samuel Lagunes on 12/14/20.
//

import XCTest
@testable import LocalizerlintFramework

class BuildLogTest: XCTestCase {

    func testInitWithAllParams() {
        let sut = BuildLog(file: "filePath", line: 1, message: "testMessage", type: .error)
        
        XCTAssertEqual(sut.file, "filePath")
        XCTAssertEqual(sut.line, 1)
        XCTAssertEqual(sut.message, "testMessage")
        XCTAssertEqual(sut.type, .error)
    }
    
    func testBuildDescriptionWithAllParams() {
        let sutError = BuildLog(file: "filePath", line: 1, message: "testMessage", type: .error)
        XCTAssertEqual(sutError.description, "filePath:1: error: testMessage")
        
        let sutWarning = BuildLog(file: "filePath", line: 1, message: "testMessage", type: .warning)
        XCTAssertEqual(sutWarning.description, "filePath:1: warning: testMessage")
    }
    
    func testBuildDescriptionWithTypeAndMessageOnly() {
        let sutError = BuildLog(message: "testMessage", type: .error)
        XCTAssertEqual(sutError.description, "error: testMessage")
        
        let sutWarning = BuildLog(message: "testMessage", type: .warning)
        XCTAssertEqual(sutWarning.description, "warning: testMessage")
    }

}
