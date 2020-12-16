//
//  LocalizedKeyView.swift
//  Shared
//
//  Created by Samuel Lagunes on 12/4/20.
//

import Foundation

struct LocalizedKeyView: Identifiable {
    var id = UUID()
    let key: String
    let value: String

    init(key: String) {
        self.key = key
        self.value = NSLocalizedString(key, comment: "")
    }
}
