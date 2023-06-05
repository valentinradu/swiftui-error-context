// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ErrorBoundary",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ErrorBoundary",
            targets: ["ErrorBoundary"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/valentinradu/swift-any-error.git", from: .init(0, 0, 1))
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ErrorBoundary",
            dependencies: [
                .product(name: "AnyError", package: "swift-any-error")
            ],
            swiftSettings: [.unsafeFlags(["-Xfrontend", "-warn-concurrency"])]
        ),
        .testTarget(
            name: "ErrorBoundaryTests",
            dependencies: ["ErrorBoundary"]
        ),
    ]
)
