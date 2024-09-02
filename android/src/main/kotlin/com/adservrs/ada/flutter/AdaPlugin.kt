package com.adservrs.ada.flutter

import android.util.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin

internal const val baseLogTag = "ADAF"

class AdaPlugin : FlutterPlugin {
    companion object {
        private const val TAG = "$baseLogTag-AdaPlugin"
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        Log.d(TAG, "onAttachedToEngine")

        flutterPluginBinding.platformViewRegistry.registerViewFactory(
            "AdaView",
            AdaViewFactory(flutterPluginBinding),
        )
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        Log.d(TAG, "onDetachedFromEngine")
    }
}
