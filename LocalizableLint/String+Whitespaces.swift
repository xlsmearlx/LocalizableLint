//
//  StringExt.swift
//  LocalizableLint
//
//  Created by Samuel Lagunes on 12/4/20.
//

import Foundation

extension StringProtocol where Self: RangeReplaceableCollection {
    var removingAllWhiteSpaces: Self {
        filter { !$0.isWhitespace }
    }
    
    mutating func removeAllWhiteSpaces() {
        removeAll(where: \.isWhitespace)
    }
}
