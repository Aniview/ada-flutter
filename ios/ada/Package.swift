// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ada",
    platforms: [
        .iOS("15.0")
    ],
    products: [
        .library(name: "ada", targets: ["ada"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework"),
        .package(url: "https://github.com/Aniview/ada-sdk-ios-spm.git", from: "1.4.0"),
    ],
    targets: [
        .target(
            name: "ada",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework"),
                .product(name: "AdaSdk", package: "ada-sdk-ios-spm"),
            ]
        )
    ]
)
