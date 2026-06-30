//
//  AdaMethodHandler.swift
//  ada
//
//  Created by Zhanna Moskaliuk on 26.06.2026.
//

import Flutter
import AdaSdk

public final class AdaMethodHandler {
    private var registrar: FlutterPluginRegistrar?
    private var messenger: FlutterBinaryMessenger?
   
    func registerChannel(
        _ registrar: FlutterPluginRegistrar,
        messenger: FlutterBinaryMessenger
    ) {
        self.registrar = registrar
        self.messenger = messenger
        
        let channel = FlutterMethodChannel(name:  "com.adservrs.ada/Ada", binaryMessenger: messenger)
        channel.setMethodCallHandler { [weak self] call, result in
            self?.handle(call, result: result)
        }
    }
    
    // MARK: - Handle method calls through channel
    private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "initialize":
            handleInitializeSDK(arguments: call.arguments, result: result)
        default:
            result(FlutterError.notImplemented(name: call.method))
        }
    }
    
    // MARK: - Init 'AdaSDK'
    private func handleInitializeSDK(arguments: Any?, result: @escaping FlutterResult) {
        guard let params = arguments as? [String: String],
              let storeURLString = params["iosStoreUrl"],
              let storeURL = URL(string: storeURLString)
        else {
            result(FlutterError.missingArguments())
            fatalError("Missing required parameter 'iosStoreUrl'. Please provide a valid App Store URL.")
        }
        AdaSDK.initSDK(storeUrl: storeURL)
        result(nil)
    }
}
