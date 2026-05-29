import Flutter
import UIKit

public class AdaPlugin: NSObject {
    private static var instance = AdaPlugin()

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
        
        // view
        registrar.register(
            FLNativeViewFactory(messenger: messenger),
            withId: "AdaView"
        )
    }
}
