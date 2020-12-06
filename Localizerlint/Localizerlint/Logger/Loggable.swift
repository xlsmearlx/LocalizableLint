//
//  Loggable.swift
//  LocalizableLint
//
//  Created by Samuel Lagunes on 12/6/20.
//

import Foundation

enum LogType: String {
    case warning = " warning: "
    case error = " error: "
    case message = ""
}

protocol Loggable {
    var file: String? { get }
    var line: Int? { get }
    var message: String { get }
    var type: LogType { get }
}

extension Loggable {
    var description: String {
        var output = ""
        file.map({ output.append("\($0):") })
        line.map({ output.append("\($0):") })
        output.append("\(type.rawValue)")
        output.append("\(message)")
        
        return output
    }
}
