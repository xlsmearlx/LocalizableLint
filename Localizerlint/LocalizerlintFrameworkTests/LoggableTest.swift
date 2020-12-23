//
//  LoggableTest.swift
//  LocalizerlintFrameworkTests
//
//  Created by Samuel Lagunes on 12/20/20.
//

import XCTest
@testable import LocalizerlintFramework

fileprivate struct LoggableDummyImp: Loggable {
    var message: String = ""
    var type: LogType = .message
}

class LoggableTest: XCTestCase {

    func testDefaultProtocolValues() throws {
        let sut = LoggableDummyImp()
        XCTAssertNil(sut.file)
        XCTAssertNil(sut.line)
    }

}
