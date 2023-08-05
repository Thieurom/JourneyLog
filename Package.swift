// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "JourneyLog",
    platforms: [.iOS(.v15), .macOS(.v12)],
    products: [
        .library(
            name: "JourneyLog",
            targets: ["JourneyLog"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "JourneyLog",
            dependencies: []
        ),
        .testTarget(
            name: "JourneyLogTests",
            dependencies: ["JourneyLog"]
        )
    ]
)
