// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DRSKit",
    products: [
        .library(name: "DRSKit", targets: ["DRSKit"])
    ],
    dependencies: [
        .package(url: "https://github.com/CoreOffice/XMLCoder", .upToNextMajor(from: "0.17.1")),
        .package(url: "https://github.com/apple/swift-argument-parser.git", .upToNextMajor(from: "1.2.2")),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "read-drs-swift",
            dependencies: [.product(name: "XMLCoder", package: "XMLCoder"), .product(name: "ArgumentParser", package: "swift-argument-parser"), .target(name: "DRSKit")]),
        .target(name: "DRSKit")
    ]
)
