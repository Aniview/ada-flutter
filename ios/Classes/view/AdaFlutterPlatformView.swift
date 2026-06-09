//
//  AdaFlutterPlatformView.swift
//  ada
//
//  Created by Zhanna Moskaliuk on 20.05.2026.
//

import Flutter
import UIKit
import AdaSdk

final class AdaFlutterPlatformView: NSObject, FlutterPlatformView {
    private let containerView: AdaContainerView

    init(
        frame: CGRect,
        viewId: Int64,
        args: Any?,
        messenger: FlutterBinaryMessenger
    ) {
        guard let config = AdaConfigParser.parseConfig(from: args) else {
            fatalError("AdaView requires valid pubId and tagId in config")
        }
        containerView = AdaContainerView(
            frame: frame,
            viewId: viewId,
            config: config,
            messenger: messenger
        )
        super.init()
    }

    func view() -> UIView {
        containerView
    }
}

final class AdaContainerView: UIView {

    // MARK: - Properties

    private let adView: AdaView
    private let channel: FlutterMethodChannel
    private var currentHeight: CGFloat = 480

    // MARK: - Init

    init(
        frame: CGRect,
        viewId: Int64,
        config: AdaSdk.AdaConfig,
        messenger: FlutterBinaryMessenger
    ) {

        adView = AdaView(config: config)
        channel = FlutterMethodChannel(
            name: "AdaView_\(viewId)",
            binaryMessenger: messenger
        )

        super.init(frame: frame)
        
        setupChannel()
        setupUI()

        // delegates
        adView.delegate = self
        adView.sizeDelegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Channel

    private func setupChannel() {
        channel.setMethodCallHandler { [weak self] call, result in
            switch call.method {
            case "startLoading":
                self?.adView.startLoading()
            default:
                break
            }
            result(nil)
        }
    }

    // MARK: - UI

    private func setupUI() {
        backgroundColor = .clear
        clipsToBounds = true
        adView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(adView)

        NSLayoutConstraint.activate([
            adView.leadingAnchor.constraint(equalTo: leadingAnchor),
            adView.trailingAnchor.constraint(equalTo: trailingAnchor),
            adView.topAnchor.constraint(equalTo: topAnchor),
            adView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    // MARK: - Size Reporting

    private func notifyFlutterSizeChanged(height: CGFloat) {

        channel.invokeMethod(
            "onAdSizeChanged",
            arguments: [
                "width": bounds.width,
                "height": height
            ]
        )
    }
}

// MARK: - AdaViewDelegate

extension AdaContainerView: AdaSdk.AdaViewDelegate {

    func onEvent(_ event: AdaSdk.AdaEvent) {
        switch event {
        case .onLoaded:
            channel.invokeMethod("onAdLoaded", arguments: nil)
        case .onImpression:
            channel.invokeMethod("onAdImpression", arguments: nil)
        case .onAdCanRefresh:
            channel.invokeMethod("onAdCanRefresh", arguments: nil)
        case .onClicked:
            channel.invokeMethod("onAdClicked", arguments: nil)
        case .onAdError:
            channel.invokeMethod("onAdError", arguments: nil)
            
        @unknown default:
            break
        }
    }
}

// MARK: - SizeDelegate

extension AdaContainerView: AdaSdk.SizeDelegate {

    func onHeightChange(_ newValue: CGFloat) {
        guard currentHeight != newValue else {
            return
        }
        currentHeight = newValue
        
        // request height change on flutter
        notifyFlutterSizeChanged(height: newValue)
    }
}
