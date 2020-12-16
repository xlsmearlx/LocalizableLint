//
//  Logger.swift
//  Localizerlint
//
//  Created by Samuel Lagunes on 12/5/20.
//

import Foundation

public struct Logger {
    public static func print(log: Loggable) {
        Swift.print(log.description)
    }
    
    public static func print(logs: [Loggable]) {
        logs.forEach({ Swift.print($0.description) })
    }
}
