// swift-tools-version: 6.0
import PackageDescription

// Manifest for React Native's SwiftPM mode (react-native >= 0.87); CocoaPods apps use the podspec.
// The ReactNative and React-GeneratedCode paths are relative to the autolinker's
// build/generated/autolinking/libs/FlyreelSdkReactNative symlink in the app.
// SwiftPM can't mix Swift and Objective-C in one target, so the RCT_EXTERN declarations
// live in their own target; neither target imports the other.
let package = Package(
    name: "FlyreelSdkReactNative",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "FlyreelSdkReactNative",
            targets: ["FlyreelSdkReactNativeSwift", "FlyreelSdkReactNativeObjC"]
        ),
    ],
    dependencies: [
        .package(name: "ReactNative", path: "../../../../xcframeworks"),
        .package(name: "React-GeneratedCode", path: "../../../ios"),
        // Keep in step with spm_dependency in flyreel_sdk_react_native.podspec
        .package(url: "https://github.com/Flyreel/flyreel-sdk-ios.git", exact: "1.2.3"),
    ],
    targets: [
        .target(
            name: "FlyreelSdkReactNativeSwift",
            dependencies: [
                .product(name: "ReactHeaders", package: "ReactNative"),
                .product(name: "ReactNativeHeaders", package: "ReactNative"),
                .product(name: "ReactNativeDependenciesHeaders", package: "ReactNative"),
                .product(name: "ReactAppHeaders", package: "React-GeneratedCode"),
                .product(name: "Flyreel", package: "flyreel-sdk-ios"),
            ],
            path: ".",
            exclude: [
                "FlyreelSdkReactNative-Bridging-Header.h",
                "ObjC",
                "Package.swift",
            ],
            sources: ["FlyreelSdkReactNative.swift"],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .target(
            name: "FlyreelSdkReactNativeObjC",
            dependencies: [
                .product(name: "ReactHeaders", package: "ReactNative"),
                .product(name: "ReactNativeHeaders", package: "ReactNative"),
                .product(name: "ReactNativeDependenciesHeaders", package: "ReactNative"),
                .product(name: "ReactAppHeaders", package: "React-GeneratedCode"),
            ],
            path: "ObjC",
            // No public headers; SwiftPM rejects the default "include" when it doesn't exist.
            publicHeadersPath: ".",
            cxxSettings: [
                .define("DEBUG", .when(configuration: .debug)),
                .define("NDEBUG", .when(configuration: .release)),
            ]
        ),
    ],
    cxxLanguageStandard: .cxx20
)
