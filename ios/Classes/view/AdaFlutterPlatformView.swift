//
//  AdaFlutterPlatformView.swift
//  ada
//
//  Created by Zhanna Moskaliuk on 20.05.2026.
//

import Flutter
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
        
        self.containerView = AdaContainerView(
            frame: frame,
            viewId: viewId,
            config: config,
            messenger: messenger
        )
        
        super.init()
    }
    
    func view() -> UIView {
        return containerView
    }
}

final class AdaContainerView: UIView {
    
    // MARK: - Properties
    
    let adView: AdaView
    
    private let channel: FlutterMethodChannel
    
    private var reportedWidth: CGFloat = 0
    private var reportedHeight: CGFloat = 0
    
    // MARK: - Init
    
    init(
        frame: CGRect,
        viewId: Int64,
        config: AdaSdk.AdaConfig,
        messenger: FlutterBinaryMessenger
    ) {
        
        // Create SDK view
        self.adView = AdaView(config: config)
        
        // Flutter channel
        self.channel = FlutterMethodChannel(
            name: "AdaView_\(viewId)",
            binaryMessenger: messenger
        )
        
        super.init(frame: frame)
        
        setupChannel()
        setupUI()
        
        adView.delegate = self
        adView.sizeDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        measureAndReportSize()
    }
    
    // MARK: - Setup method channel
    private func setupChannel() {
        channel.setMethodCallHandler { [weak self] call, result in
            switch call.method {
            case "startLoading":
                self?.handleStartLoading()
            default:
                break
            }
        }
    }
    
    private func handleStartLoading() {
        adView.startLoading()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        clipsToBounds = true
        backgroundColor = .white
        isOpaque = true
        
        adView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(adView)
        
        NSLayoutConstraint.activate([
            adView.leadingAnchor.constraint(equalTo: leadingAnchor),
            adView.trailingAnchor.constraint(equalTo: trailingAnchor),
            adView.topAnchor.constraint(equalTo: topAnchor),
            adView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    
    // MARK: - Measurement
    
    private func measureAndReportSize() {
        guard bounds.width > 0 else { return }
        
        adView.layoutIfNeeded()
        
        let targetSize = CGSize(
            width: bounds.width,
            height: UIView.layoutFittingCompressedSize.height
        )
        
        let fittingSize = adView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        
        let width = ceil(fittingSize.width)
        let height = ceil(fittingSize.height)
        
        guard width != reportedWidth ||
                height != reportedHeight else {
            return
        }
        
        reportedWidth = width
        reportedHeight = height
        
        notifyFlutterSizeChanged(
            width: width,
            height: height
        )
    }
    
    private func notifyFlutterSizeChanged(width: CGFloat, height: CGFloat) {
        channel.invokeMethod(
            "onAdSizeChanged",
            arguments: [
                "width": width,
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
        case .onAdError:
            channel.invokeMethod("onAdError", arguments: nil)
        case .onImpression:
            channel.invokeMethod("onAdImpression", arguments: nil)
        case .onAdCanRefresh:
            channel.invokeMethod("onAdCanRefresh", arguments: nil)
        case .onClicked:
            channel.invokeMethod("onAdClicked", arguments: nil)
        @unknown default:
            break
        }
    }
}

// MARK: - SizeDelegate

extension AdaContainerView: AdaSdk.SizeDelegate {
    
    func onHeightChange(_ newValue: CGFloat) {
        Task { @MainActor [weak self] in
            self?.setNeedsLayout()
        }
    }
}
