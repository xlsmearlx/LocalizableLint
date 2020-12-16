//
//  VerboseLog.swift
//  LocalizerlintFramework
//
//  Created by Samuel Lagunes on 12/16/20.
//

import Foundation

public struct VerboseLog: Loggable {
    public var message: String
    public var type: LogType
    
    public init(message: String) {
        self.message = message
        self.type = .message
    }
}
