//
//  RegexEvaluatorTest.swift
//  LocalizerlintFrameworkTests
//
//  Created by Samuel Lagunes on 12/15/20.
//

import XCTest
@testable import LocalizerlintFramework

class RegexEvaluatorTest: XCTestCase {
    var localizedCodeContent: String!
    
    override func setUpWithError() throws {
        localizedCodeContent = localizedCode.appending(localizedCodeObjectiveC)
    }
    
    override func tearDownWithError() throws {
        localizedCodeContent = .none
    }
    
    func testMakeSuccessForPatterns() {
        XCTAssertNoThrow(try RegexEvaluator.matchesFor(pattern: .bruteForce, content: "") as [String])
        XCTAssertNoThrow(try RegexEvaluator.matchesFor(pattern: .swiftui, content: "") as [String])
        XCTAssertNoThrow(try RegexEvaluator.matchesFor(pattern: .bundleLocalized, content: "") as [String])
        XCTAssertNoThrow(try RegexEvaluator.matchesFor(pattern: .bundleLocalizedObjc, content: "") as [String])
        XCTAssertNoThrow(try RegexEvaluator.matchesFor(pattern: .nslocalized, content: "") as [String])
        XCTAssertNoThrow(try RegexEvaluator.matchesFor(pattern: .localizedString, content: "") as [String])
    }
    
    func testMakeFailWithInvalidPattern() {
        XCTAssertThrowsError(try RegexEvaluator.matchesFor(pattern: .custom("[e/\""), content: "") as [String])
    }
    
    func testMakeFailWithInvalidPatternMessage() {
        do {
            _ = try RegexEvaluator.matchesFor(pattern: .custom("[e/\""), content: "") as [String]
        } catch {
            XCTAssertEqual(error.localizedDescription, "Invalid regex format: [e/\"")
        }
    }
    
    func testMatchesForBruteForcePattern() throws {
        let matches: [String] = try RegexEvaluator.matchesFor(pattern: .bruteForce, content: localizedCodeContent)
        XCTAssertEqual(matches.count, 9)
    }
    
    func testMatchesForNSLocalized() throws {
        let matches: [String] = try RegexEvaluator.matchesFor(pattern: .nslocalized, content: localizedCodeContent)
        XCTAssertEqual(matches.count, 2)
        XCTAssertEqual(matches[0], "DESCRIPTION_LABEL")
        XCTAssertEqual(matches[1], "DISH_ID")
    }
    
    func testMatchesForBundleLocalized() throws {
        let matches: [String] = try RegexEvaluator.matchesFor(pattern: .bundleLocalized, content: localizedCodeContent)
        XCTAssertEqual(matches.count, 1)
        XCTAssertEqual(matches[0], "DISH_NAME_LABEL")
    }
    
    func testMatchesForBundleLocalizedObjectiveC() throws {
        let matches: [String] = try RegexEvaluator.matchesFor(pattern: .bundleLocalizedObjc, content: localizedCodeContent)
        XCTAssertEqual(matches.count, 1)
        XCTAssertEqual(matches[0], "DISH_NAME_INGREDIENTS")
    }
    
    func testMatchesForSwiftUI() throws {
        let matches: [String] = try RegexEvaluator.matchesFor(pattern: .swiftui, content: localizedCodeContent)
        XCTAssertEqual(matches.count, 1)
        XCTAssertEqual(matches[0], "DISH_AVAILABILITY")
    }
    
    func testMatchesForLocalizedStringFile() throws{
        
        let matches: [String] = try RegexEvaluator.matchesFor(pattern: .localizedString,
                                                              content: localizedStrings.removingAllWhiteSpaces)
        XCTAssertEqual(matches.count, 4)
    }
    
    func testMatchesForKeyValueLocalizedStringFiles() throws {
        let matches: RegexEvaluator.KeyValueMatch = try RegexEvaluator.matchesFor(pattern: .localizedString,
                                                                                  content: localizedStrings.removingAllWhiteSpaces)
        XCTAssertEqual(matches.keys.count, 4)
        XCTAssertEqual(matches.values.count, 4)
        XCTAssertEqual(matches.keys[2], "DESCRIPTION_LABEL")
        XCTAssertEqual(matches.values[2], "Description")
    }
}
