// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ErrorContext",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ErrorContext",
            targets: ["ErrorContext"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/valentinradu/swift-any-error.git", from: .init(0, 0, 1))
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ErrorContext",
            dependencies: [
                .product(name: "AnyError", package: "swift-any-error")
            ]
        ),
        .testTarget(
            name: "ErrorContextTests",
            dependencies: ["ErrorContext"]
        ),
    ]
)
