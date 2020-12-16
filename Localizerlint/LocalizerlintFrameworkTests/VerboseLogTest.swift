//
//  VerboseLogTest.swift
//  LocalizerlintFrameworkTests
//
//  Created by Samuel Lagunes on 12/16/20.
//

import XCTest
@testable import LocalizerlintFramework

class VerboseLogTest: XCTestCase {

    func testInitWithAllParams() {
        let sut = VerboseLog(message: "testMessage")
        XCTAssertNil(sut.file)
        XCTAssertNil(sut.line)
        XCTAssertEqual(sut.message, "testMessage")
        XCTAssertEqual(sut.type, .message)
    }

    func testBuildDescription() {
        let sut = VerboseLog(message: "testMessage")
        XCTAssertEqual(sut.description, "testMessage")
    }
}
