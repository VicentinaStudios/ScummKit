// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let isCustomGarbageCollectionEnabled = false

let package = Package(
    name: "ScummCompiler",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ScummCompiler",
            targets: ["ScummCompiler"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ScummCompiler",
            swiftSettings: isCustomGarbageCollectionEnabled ? [.define("CUSTOM_GARBAGE_COLLECTION")] : []
        ),
        .testTarget(
            name: "ScummCompilerTests",
            dependencies: ["ScummCompiler"],
            swiftSettings: isCustomGarbageCollectionEnabled ? [.define("CUSTOM_GARBAGE_COLLECTION")] : []
        ),
    ]
)
