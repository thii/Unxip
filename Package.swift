// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Unxip",
    products: [
        .executable(
            name: "unxip",
            targets: ["Unxip"]),
        .library(
            name: "UnxipKit",
            targets: ["UnxipKit"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Unxip",
            dependencies: ["UnxipKit"]),
        .target(
            name: "UnxipKit",
            dependencies: []),
    ]
)
