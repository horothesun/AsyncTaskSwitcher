// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "AsyncTaskSwitcher",
    products: [
        .library(
            name: "AsyncTaskSwitcher",
            targets: ["AsyncTaskSwitcher"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/horothesun/ConcurrentDictionary", .exact("0.1.1"))
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
