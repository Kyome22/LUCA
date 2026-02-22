// swift-tools-version: 6.2

import PackageDescription

let swiftSettings: [SwiftSetting] = [
    .enableUpcomingFeature("ExistentialAny"),
]

let package = Package(
    name: "LUCA",
    platforms: [
        .macOS(.v15),
    ],
    products: [
        .executable(
            name: "luca",
            targets: ["LUCA"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", exact: "1.6.2"),
    ],
    targets: [
        .target(
            name: "LUCAKit",
            resources: [
                .process("Resources/project-ios.yml"),
                .process("Resources/project-macos.yml"),
                .process("Resources/AppDelegate-iOS.swift"),
                .process("Resources/AppDelegate-macOS.swift"),
                .copy("Resources/LocalPackage"),
                .copy("Resources/App-iOS"),
                .copy("Resources/App-macOS"),
            ],
            swiftSettings: swiftSettings
        ),
        .executableTarget(
            name: "LUCA",
            dependencies: [
                "LUCAKit",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ],
        ),
    ]
)
