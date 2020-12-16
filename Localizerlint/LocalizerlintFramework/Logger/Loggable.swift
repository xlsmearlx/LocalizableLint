//
//  Loggable.swift
//  Localizerlint
//
//  Created by Samuel Lagunes on 12/6/20.
//

import Foundation

public protocol Loggable {
    var file: String? { get }
    var line: Int? { get }
    var message: String { get }
    var type: LogType { get }
}

extension Loggable {
    public var file: String? { .none  }
    public var line: Int? { .none }
}

extension Loggable {
    var description: String {
        var output = ""
        file.map({ output.append("\($0):") })
        line.map({ output.append("\($0): ") })
        output.append("\(type.rawValue)")
        output.append("\(message)")
        
        return output
    }
}
