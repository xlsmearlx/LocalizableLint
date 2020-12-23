//
//  LocalizedStringsFileTest.swift
//  LocalizerlintFrameworkTests
//
//  Created by Samuel Lagunes on 12/17/20.
//

import XCTest
@testable import LocalizerlintFramework

class LocalizedStringsFileTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDescriptionWithValues() throws {
        let kv = ["LOCALIZED_KEY_1": "Val1", "LOCALIZED_KEY_2": "Val2", "LOCALIZED_KEY_3": "Val3"]
        let sut = LocalizedStringsFile(path: "MyPath", kv: kv, ruleViolations: [])
        XCTAssertEqual(sut.description, "file MyPath has 3 localizedStrings. \(kv.keys)")
    }
    
    func testDescriptionWithNoValues() throws {
        let sut = LocalizedStringsFile(path: "MyPath", kv: [:], ruleViolations: [])
        XCTAssertEqual(sut.description, "file MyPath has 0 localizedStrings.")
    }
    
    func testEncode() throws {
        let sut = LocalizedStringsFile(path: "MyPath", kv: [:], ruleViolations: [])
        
        let encoder = JSONEncoder()
        XCTAssertNoThrow(try encoder.encode(sut))
        XCTAssertNotNil(try encoder.encode(sut))
    }
}
