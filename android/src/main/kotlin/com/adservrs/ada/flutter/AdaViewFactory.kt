package com.adservrs.ada.flutter

import android.content.Context
import android.util.Log
import com.adservrs.ada.AdaConfig
import com.adservrs.ada.AdaScaleType
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

        val scaleType = args["scaleType"].toAdaScaleType()
        if (scaleType != null) {
            config = config.copy(scaleType = scaleType)
        }

        val packageName = args["packageName"] as? String
        if (packageName != null) {
            config = config.copy(packageName = packageName)
        }

        val macros = args["macros"] as? Map<*, *>
        if (macros != null) {
            config = config.copy(macros = macros.entries.associate {
                it.key.toString() to it.value.toString()
            })
        }

        return config
    }

    fun Any?.toAdaScaleType() = when (this) {
        "fill" -> AdaScaleType.Fill
        "center" -> AdaScaleType.Center
        "centerCrop" -> AdaScaleType.CenterCrop
        "centerInside" -> AdaScaleType.CenterInside
        else -> null
    }
}
