// swift-tools-version: @ign-var:SWIFT_TOOLS_VERSION=6.0@

import PackageDescription

let package = Package(
  name: "@ign-var:PROJECT_NAME={current_dir}@",
  platforms: [
    .iOS(.v@ign-var:IOS_PACKAGE_PLATFORM_VERSION=17@),
    .macOS(.v14)
  ],
  products: [
    .library(name: "@ign-var:IOS_FEATURE_TARGET=AppFeature@", targets: ["@ign-var:IOS_FEATURE_TARGET=AppFeature@"])
  ],
  targets: [
    .target(name: "@ign-var:IOS_FEATURE_TARGET=AppFeature@"),
    .testTarget(
      name: "@ign-var:IOS_FEATURE_TARGET=AppFeature@Tests",
      dependencies: ["@ign-var:IOS_FEATURE_TARGET=AppFeature@"]
    )
  ],
  swiftLanguageModes: [.v6]
)
