//
//  RuleViolationTest.swift
//  LocalizerlintFrameworkTests
//
//  Created by Samuel Lagunes on 12/17/20.
//

import XCTest
@testable import LocalizerlintFramework

class RuleViolationTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDuplicatedKeyDescription() throws {
        let sut = RuleViolation(lineNumber: 0, type: .duplicatedKey(key: "SOME_KEY"))
        XCTAssertEqual(sut.type.description, "SOME_KEY is duplicated")
    }
    
    func testUnusedKeyDescription() throws {
        let sut = RuleViolation(lineNumber: 0, type: .unusedKey(key: "SOME_KEY"))
        XCTAssertEqual(sut.type.description, "SOME_KEY was defined but never used")
    }
}
