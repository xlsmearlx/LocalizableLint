//
//  OutputTypeTest.swift
//  LocalizerlintFrameworkTests
//
//  Created by Samuel Lagunes on 12/20/20.
//

import XCTest
@testable import LocalizerlintFramework

class OutputTypeTest: XCTestCase {
    
    func testInitWithValidRawValue() throws {
        XCTAssertNoThrow(try OutputType.init("xcode"))
        XCTAssertNoThrow(try OutputType.init("json"))
    }
    
    func testInitWithInValidRawValueThrowsError() throws {
        XCTAssertThrowsError(try OutputType("invalid_raw_value"), "") { (error) in
            XCTAssert(error is OutputTypeError)
            XCTAssertEqual(error.localizedDescription, "\'invalid_raw_value\' is not a valid reporter. Available reporters: xcode, json")
            
        }
    }
    
    func testInitWithCommaSeparatedString() throws {
        XCTAssertNoThrow(try OutputType.typesFromString("json,xcode"))
        
        let sut = try OutputType.typesFromString("json,xcode,json")
        XCTAssertEqual(sut.count, 2)
        XCTAssertTrue(sut.contains(.json))
        XCTAssertTrue(sut.contains(.xcode))
    }

}
