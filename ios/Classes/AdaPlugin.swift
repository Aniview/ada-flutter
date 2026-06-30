import Flutter
import UIKit

public class AdaPlugin: NSObject {
    private static var instance = AdaPlugin()
    private lazy var adaHandler = AdaMethodHandler()
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}

extension AdaPlugin: FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let messenger = registrar.messenger()
        // AdaSdk main interface
        instance.adaHandler.registerChannel(registrar, messenger: messenger)
        
        // view
        registrar.register(
            FLNativeViewFactory(messenger: messenger),
            withId: "AdaView"
        )
    }
}
