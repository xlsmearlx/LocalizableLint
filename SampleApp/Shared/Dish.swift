//
//  Dish.swift
//  LocalizableLintSample
//
//  Created by Samuel Lagunes on 12/4/20.
//

import Foundation

struct Dish: Identifiable {
    var id = UUID()
    let name: String
    let description: String

    init(name: String) {
        self.name = name
        self.description = NSLocalizedString("DESCRIPTION_LABEL", comment: "")
    }
}
