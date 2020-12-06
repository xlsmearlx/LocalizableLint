//
//  BuildLog.swift
//  LocalizableLint
//
//  Created by Samuel Lagunes on 12/6/20.
//

import Foundation

struct BuildLog: Loggable {
    var file: String?
    var line: Int?
    var message: String
    var type: LogType
    
    init(file: String? = .none, line: Int? = .none, message: String, type: LogType) {
        self.file = file
        self.line = line
        self.message = message
        self.type = type
    }
}
