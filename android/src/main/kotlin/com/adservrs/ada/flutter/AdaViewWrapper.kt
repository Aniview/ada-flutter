package com.adservrs.ada.flutter

import android.content.Context
import android.util.Log
import android.view.View
import android.view.ViewGroup
import com.adservrs.ada.AdaConfig
import com.adservrs.ada.AdaView
import com.adservrs.ada.AdaViewListener
import com.adservrs.ada.events.AdClickedEvent
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView

internal class AdaViewWrapper(
    context: Context,
    viewId: Int,
    config: AdaConfig,
    binding: FlutterPlugin.FlutterPluginBinding,
) : PlatformView, MethodChannel.MethodCallHandler {
    companion object {
        private const val TAG = "$baseLogTag-AdaViewWrapper"
    }

    private val channel = MethodChannel(binding.binaryMessenger, "AdaView_${viewId}")
    private val view = SizeReporter(AdaView(context, config, Listener()))

    init {
        channel.setMethodCallHandler(this)
    }

    override fun getView(): View {
        return view
    }

    override fun dispose() {
        Log.d(TAG, "dispose")
        view.view.destroy()
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        Log.d(TAG, "onMethodCall: method = ${call.method}, arguments = ${call.arguments}")

        when (call.method) {
            "loadNextAd" -> {
                view.view.loadNextAd(force = call.argument("force") ?: false)
            }

            else -> result.notImplemented()
        }
    }

    private inner class Listener : AdaViewListener {
        override fun onAdLoaded() {
            Log.d(TAG, "onAdLoaded")
            channel.invokeMethod("onAdLoaded", null)
        }

        override fun onAdImpression() {
            Log.d(TAG, "onAdImpression")
            channel.invokeMethod("onAdImpression", null)
        }

        override fun onAdCanRefresh() {
            Log.d(TAG, "onAdCanRefresh")
            channel.invokeMethod("onAdCanRefresh", null)
        }

        override fun onAdClicked(event: AdClickedEvent) {
            Log.d(TAG, "onAdClicked: event = $event")
            channel.invokeMethod("onAdClicked", null)
        }
    }

    private inner class SizeReporter(val view: AdaView) : ViewGroup(view.context) {
        private var lastWidth = -1
        private var lastHeight = -1

        init {
            addView(view)
        }

        override fun onMeasure(widthMeasureSpec: Int, heightMeasureSpec: Int) {
            super.onMeasure(widthMeasureSpec, heightMeasureSpec)

            // flutter always passes EXACTLY, so we need to adapt
            view.measure(
                MeasureSpec.makeMeasureSpec(MeasureSpec.getSize(widthMeasureSpec), MeasureSpec.AT_MOST),
                MeasureSpec.makeMeasureSpec(MeasureSpec.getSize(heightMeasureSpec), MeasureSpec.AT_MOST)
            )

            if (lastWidth != view.measuredWidth || lastHeight != view.measuredHeight) {
                lastWidth = view.measuredWidth
                lastHeight = view.measuredHeight

                val arguments = mapOf(
                    "width" to lastWidth.toDouble(),
                    "height" to lastHeight.toDouble(),
                )
                channel.invokeMethod("onAdSizeChanged", arguments)
            }
        }

        override fun onLayout(changed: Boolean, l: Int, t: Int, r: Int, b: Int) {
            val x = (width - view.measuredWidth) / 2
            val y = (height - view.measuredHeight) / 2
            view.layout(x, y, x + view.measuredWidth, y + view.measuredHeight)
        }
    }
}
