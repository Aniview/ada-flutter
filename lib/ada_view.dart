import 'dart:async';

import 'package:ada/ada_config.dart';
import 'package:ada/ada_view_event.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

///
/// Main placement controller for displaying Ads
///
class AdaViewController {
  final AdaConfig config;

  MethodChannel? _channel;
  final _size = StreamController<Size>.broadcast();
  final _events = StreamController<AdaViewEvent>.broadcast();

  late final events = _events.stream;

  AdaViewController({required this.config});

  ///
  /// Load next Ad
  ///
  void loadNextAd({bool force = false}) {
    _channel?.invokeMethod("loadNextAd", {"force": force});
  }

  void startLoading() {
    _channel?.invokeMethod("startLoading");
  }

  void _attach({required int viewId}) {
    _channel?.setMethodCallHandler(null);
    _channel = MethodChannel("AdaView_$viewId");
    _channel?.setMethodCallHandler(_handleMethodCall);

    _events.add(const OnControllerAttachedEvent());
  }

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case "onAdSizeChanged":
        return _size.add(Size(call.arguments["width"], call.arguments["height"]));
      case "onAdLoaded":
        return _events.add(const OnAdLoadedEvent());
      case "onAdImpression":
        return _events.add(const OnAdImpressionEvent());
      case "onAdCanRefresh":
        return _events.add(const OnAdCanRefreshEvent());
      case "onAdClicked":
        return _events.add(const OnAdClickedEvent());
      case "onAdError":
        return _events.add(const OnAdErrorEvent());
    }
  }
}

///
/// Main placement view that displays Ads
///
class AdaView extends StatelessWidget {
  static const _nativeViewType = "AdaView";

  final AdaViewController controller;

  AdaView({required this.controller}) : super(key: ValueKey(controller));

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Size>(
      stream: controller._size.stream,
      builder: (context, snapshot) {
        final size = snapshot.data ?? const Size(300, 480);

        return SizedBox(
          width: double.infinity,
          height: size.height,
          child: _buildPlatformView(context),
        );
      },
    );
  }
  
  Widget _buildPlatformView(BuildContext context) {
    final platform = defaultTargetPlatform;

    switch (platform) {
      case TargetPlatform.android:
        return _buildAndroidView(context);

      case TargetPlatform.iOS:
        return _buildIosView(context);

      default:
        return Text("Platform $platform not supported");
    }
  }

  Widget _buildAndroidView(BuildContext context) {
    return PlatformViewLink(
      viewType: _nativeViewType,
      surfaceFactory: (context, controller) {
        return AndroidViewSurface(
          controller: controller as AndroidViewController,
          gestureRecognizers: const {},
          hitTestBehavior: PlatformViewHitTestBehavior.opaque,
        );
      },
      onCreatePlatformView: (params) {
        controller._attach(viewId: params.id);

        return PlatformViewsService.initSurfaceAndroidView(
          id: params.id,
          viewType: _nativeViewType,
          layoutDirection: TextDirection.ltr,
          creationParams: _buildCreationArgs(),
          creationParamsCodec: const StandardMessageCodec(),
          onFocus: () {
            params.onFocusChanged(true);
          },
        )
          ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
          ..create();
      },
    );
  }

    Widget _buildIosView(BuildContext context) {
    return UiKitView(
      viewType: _nativeViewType,
      creationParams: _buildCreationArgs(),
      creationParamsCodec: const StandardMessageCodec(),
      onPlatformViewCreated: (id) {
        controller._attach(viewId: id);
      },
    );
  }

  Map<String, dynamic> _buildCreationArgs() {
    final config = controller.config;

    return {
      "pubId": config.publisherId,
      "tagId": config.tagId,
      "environment": config.environment,
      "enableAutoRefresh": config.enableAutoRefresh,
      "scaleType": config.scaleType?.name,
      "packageName": config.packageName,
      "macros": config.macros,
    };
  }
}