//
//  Logger.swift
//  Localizerlint
//
//  Created by Samuel Lagunes on 12/5/20.
//

import Foundation

struct Logger {
    static func print(log: Loggable) {
        Swift.print(log.description)
    }
    
    static func print(logs: [Loggable]) {
        logs.forEach({ Swift.print($0.description) })
    }
}
