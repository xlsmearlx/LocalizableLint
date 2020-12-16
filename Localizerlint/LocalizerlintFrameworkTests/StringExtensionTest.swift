//
//  StringExtensionTest.swift
//  LocalizerlintFrameworkTests
//
//  Created by Samuel Lagunes on 12/15/20.
//

import XCTest
@testable import LocalizerlintFramework

class StringExtensionTest: XCTestCase {

    func testWhiteSpaces() throws {
        let sut = "Hello My String"
        XCTAssertEqual(sut.removingAllWhiteSpaces, "HelloMyString")
    }
    
    func testWhiteSpacesMutable() throws {
        var sut = "Hello My String"
        sut.removeAllWhiteSpaces()
        XCTAssertEqual(sut, "HelloMyString")
    }

}
