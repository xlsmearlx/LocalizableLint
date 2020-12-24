//
//  BuildLog.swift
//  Localizerlint
//
//  Created by Samuel Lagunes on 12/6/20.
//

import Foundation

/// Container for information used by Xcode.
public struct BuildLog: Loggable {
    public var file: String?
    public var line: Int?
    public var message: String
    public var type: LogType
    
    public init(file: String? = .none, line: Int? = .none, message: String, type: LogType) {
        self.file = file
        self.line = line
        self.message = message
        self.type = type
    }
}
