//
//  LocalizationCodeFileTest.swift
//  LocalizerlintFrameworkTests
//
//  Created by Samuel Lagunes on 12/17/20.
//

import XCTest
@testable import LocalizerlintFramework

class LocalizationCodeFileTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDescriptionWithValues() throws {
        let keysSet = Set(arrayLiteral: "LOCALIZED_KEY_1", "LOCALIZED_KEY_2", "LOCALIZED_KEY_3")
        let sut = LocalizationCodeFile(path: "MyPath", keys: keysSet)
        XCTAssertEqual(sut.description, "file MyPath has 3 localizedStrings. \(keysSet)")
    }
    
    func testDescriptionWithNoValues() throws {
        let sut = LocalizationCodeFile(path: "MyPath", keys: [])
        XCTAssertEqual(sut.description, "file MyPath has 0 localizedStrings.")
    }
}
