//
//  FlutterError.swift
//  ada
//
//  Created by Zhanna Moskaliuk on 25.05.2026.
//

import Flutter

extension FlutterError {
    static func notImplemented(name: String) -> FlutterError {
        FlutterError(code: "0", message: "\(name) method is not implemented", details: nil)
    }

    static func missingArguments() -> FlutterError {
        FlutterError(code: "1", message: "Arguments are missing", details: nil)
    }

    static func sdkError(message: String) -> FlutterError {
        FlutterError(code: "2", message: message, details: nil)
    }

    static func notReady() -> FlutterError {
        FlutterError(code: "3", message: "Ad player is not ready", details: nil)
    }
}
