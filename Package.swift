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
                .process("Resources/project.yml"),
                .copy("Resources/LocalPackage"),
                .copy("Resources/App"),
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
