// swift-tools-version: 5.9

import CompilerPluginSupport
import PackageDescription

let package = Package(
  name: "swift-perception",
  platforms: [
    .iOS(.v13),
    .macOS(.v10_15),
    .tvOS(.v13),
    .watchOS(.v6),
  ],
  products: [
    .library(name: "Perception", targets: ["Perception"]),
    .library(name: "PerceptionCore", targets: ["PerceptionCore"]),
  ],
  dependencies: [
    .package(url: "https://github.com/theleftbit/swift-syntax-xcframeworks.git", from: "600.0.1"),
    .package(url: "https://github.com/pointfreeco/xctest-dynamic-overlay", from: "1.2.2"),
  ],
  targets: [
    .target(
      name: "Perception",
      dependencies: [
        "PerceptionCore",
        "PerceptionMacros",
      ]
    ),
    .target(
      name: "PerceptionCore",
      dependencies: [
        .product(name: "IssueReporting", package: "xctest-dynamic-overlay"),
      ]
    ),
    .testTarget(
      name: "PerceptionTests",
      dependencies: ["Perception"]
    ),

    .macro(
      name: "PerceptionMacros",
      dependencies: [
        .product(name: "SwiftSyntaxWrapper", package: "swift-syntax-xcframeworks"),
      ]
    ),
  ]
)

for target in package.targets where target.type != .system {
  target.swiftSettings = target.swiftSettings ?? []
  target.swiftSettings?.append(contentsOf: [
    .enableExperimentalFeature("StrictConcurrency"),
  ])
}
