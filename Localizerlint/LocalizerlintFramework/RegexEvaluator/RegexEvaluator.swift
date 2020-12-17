//
//  RegexEvaluator.swift
//  Localizerlint
//
//  Created by Samuel Lagunes on 12/15/20.
//

import Foundation

struct RegexEvaluator {
    typealias KeyValueMatch = (keys: [String], values: [String])
    
    /// Creates an instance of NSRegularExpression with the given parttern
    /// - Parameter pattern: RegexPattern to use
    /// - Throws: An Error if the RegexPattern is not valid
    /// - Returns: An instance of NSRegularExpression
    private static func make(pattern: RegexPattern) throws -> NSRegularExpression {
        var regex: NSRegularExpression
        
        do {
            regex = try NSRegularExpression(pattern: pattern.expression, options: [])
        } catch {
            throw RegexEvaluatorError.invalidPattern(pattern.expression)
        }
        
        return regex
    }
    
    /// Reads the content and finds all the pattern matches
    /// - Parameters:
    ///   - pattern: RegexPattern to use
    ///   - content: content to match
    /// - Throws: An Error if the RegexPattern is not valid
    /// - Returns: An array of NSTextCheckingResult that matches that matches regex pattern from content
    private static func matchesFor(pattern: RegexPattern, content: String) throws -> [NSTextCheckingResult] {
        let regex = try make(pattern: pattern)
        
        return regex.matches(in: content,
                             options: [],
                             range: .init(location: 0, length: content.utf16.count))
    }
    
    /// Reads the content and finds all the pattern matches
    /// - Parameters:
    ///   - pattern: regex pattern
    ///   - content: content to match
    /// - Returns: Returns a list of strings that match regex pattern from content
    static func matchesFor(pattern: RegexPattern, content: String) throws -> [String] {
        let regexMatches: [NSTextCheckingResult] = try matchesFor(pattern: pattern, content: content)
        
        return regexMatches.compactMap({
            Range($0.range(at: 1), in: content).map { String(content[$0]) }
        })
    }
    
    /// Reads the content and finds all the pattern matches
    /// - Parameters:
    ///   - pattern: regex pattern
    ///   - content: content to match
    /// - Returns: Returns a tuple with all the keys and values that match regex pattern from content
    static func matchFor(pattern: RegexPattern, content: String) throws -> KeyValueMatch {
        let regexMatches: [NSTextCheckingResult] = try matchesFor(pattern: pattern, content: content)
        
        var keys = [String]()
        var values = [String]()
        
        regexMatches.forEach({
            guard let key = Range($0.range(at: 1), in: content).map({ String(content[$0]) }),
                  let value = Range($0.range(at: 2), in: content).map({ String(content[$0]) }) else {
                    return
            }
            keys.append(key)
            values.append(value)
        })
        
        return KeyValueMatch(keys,values)
    }
}
