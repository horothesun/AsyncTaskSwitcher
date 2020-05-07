// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "AsyncTaskSwitcher",
    platforms: [
        .macOS(.v10_14),
        .iOS(.v12),
        .watchOS(.v5),
        .tvOS(.v12)
    ],
    products: [
        .library(
            name: "AsyncTaskSwitcher",
            targets: ["AsyncTaskSwitcher"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/horothesun/ConcurrentDictionary", from: "0.1.0"),
    ],
    targets: [
        .target(
            name: "AsyncTaskSwitcher",
            dependencies: ["ConcurrentDictionary"]
        ),
        .testTarget(
            name: "AsyncTaskSwitcherTests",
            dependencies: ["AsyncTaskSwitcher"]
        ),
    ]
)
