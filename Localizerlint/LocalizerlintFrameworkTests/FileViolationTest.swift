//
//  FileViolationTest.swift
//  LocalizerlintFrameworkTests
//
//  Created by Samuel Lagunes on 12/17/20.
//

import XCTest
@testable import LocalizerlintFramework

class FileViolationTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testAddRuleViolation() throws {
        var sut = FileViolation(path: "", violations: [])
        XCTAssertTrue(sut.violations.isEmpty)
        sut.addRuleViolation(.init(lineNumber: 0, type: .duplicatedKey(key: "key")))
        XCTAssertEqual(sut.violations.count, 1)
    }

}
