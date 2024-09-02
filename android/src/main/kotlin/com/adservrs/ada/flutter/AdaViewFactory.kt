package com.adservrs.ada.flutter

import android.content.Context
import android.util.Log
import com.adservrs.ada.AdaConfig
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

internal class AdaViewFactory(
    private val flutterPluginBinding: FlutterPlugin.FlutterPluginBinding,
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    companion object {
        private const val TAG = "$baseLogTag-AdaViewFactory"
    }

    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        Log.d(TAG, "create: viewId = $viewId, args = $args")

        return AdaViewWrapper(
            context = context,
            viewId = viewId,
            config = buildAdaConfig(args as Map<*, *>),
            binding = flutterPluginBinding,
        )
    }

    private fun buildAdaConfig(args: Map<*, *>): AdaConfig {
        var config = AdaConfig(
            pubId = args["pubId"] as String,
            tagId = args["tagId"] as String,
        )

        val environment = args["environment"] as? String
        if (environment != null) {
            config = config.copy(environment = environment)
        }

        val enableAutoRefresh = args["enableAutoRefresh"] as? Boolean
        if (enableAutoRefresh != null) {
            config = config.copy(enableAutoRefresh = enableAutoRefresh)
        }

        return config
    }
}
