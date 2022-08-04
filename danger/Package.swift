// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "Danger-CI",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .library(name: "DangerDeps", type: .dynamic, targets: ["DangerDependencies"])
    ],
    dependencies: [
        .package(name: "danger-swift", url: "https://github.com/danger/swift", .upToNextMajor(from: "3.13.0"))
    ],
    targets: [
        .target(name: "DangerDependencies",
                dependencies: [.product(name: "Danger", package: "danger-swift")],
                path: "DangerFakeSources",
                sources: ["DangerFakeSource.swift"])
    ]
)
