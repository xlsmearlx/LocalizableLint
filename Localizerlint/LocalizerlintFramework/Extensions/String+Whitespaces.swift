//
//  StringExt.swift
//  Localizerlint
//
//  Created by Samuel Lagunes on 12/4/20.
//

import Foundation

extension StringProtocol where Self: RangeReplaceableCollection {
    /// Removes all whitespaces from the String
    var removingAllWhiteSpaces: Self {
        filter { !$0.isWhitespace }
    }
    
    /// Removes all whitespaces from the String
    mutating func removeAllWhiteSpaces() {
        removeAll(where: \.isWhitespace)
    }
}
