// swift-tools-version: @ign-var:SWIFT_TOOLS_VERSION=6.0@

import PackageDescription

let package = Package(
  name: "@ign-var:PROJECT_NAME={current_dir}@",
  platforms: [
    .macOS(.@ign-var:MACOS_VERSION=v14@)
  ],
  products: [
    .library(name: "@ign-var:SWIFT_LIBRARY_TARGET=AppCore@", targets: ["@ign-var:SWIFT_LIBRARY_TARGET=AppCore@"]),
    .executable(name: "@ign-var:EXECUTABLE_NAME={current_dir}@", targets: ["@ign-var:SWIFT_EXECUTABLE_TARGET=AppCLI@"])
  ],
  targets: [
    .target(name: "@ign-var:SWIFT_LIBRARY_TARGET=AppCore@"),
    .executableTarget(
      name: "@ign-var:SWIFT_EXECUTABLE_TARGET=AppCLI@",
      dependencies: ["@ign-var:SWIFT_LIBRARY_TARGET=AppCore@"]
    ),
    .testTarget(
      name: "@ign-var:SWIFT_LIBRARY_TARGET=AppCore@Tests",
      dependencies: ["@ign-var:SWIFT_LIBRARY_TARGET=AppCore@"]
    )
  ],
  swiftLanguageModes: [.v6]
)
