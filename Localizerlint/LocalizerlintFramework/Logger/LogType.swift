//
//  LogType.swift
//  LocalizerlintFramework
//
//  Created by Samuel Lagunes on 12/15/20.
//

import Foundation

/// Types of logs that can be displayed in Xcode
public enum LogType: String {
    case warning = "warning: "
    case error = "error: "
    case message = ""
}
