// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Navigate",
    platforms: [
        .iOS(.v14), .macOS(.v11), .tvOS(.v14), .watchOS(.v7),
    ],
    products: [
        .library(name: "Navigate", targets: ["Navigate"]),
    ],
    dependencies: [
        .package(url: "https://github.com/johnpatrickmorgan/NavigationBackport", from: "0.0.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(name: "Navigate", dependencies: [ "NavigationBackport" ], path: "Sources"),
        .testTarget(name: "NavigateTests", dependencies: ["Navigate"], path: "Tests"),
    ]
)
