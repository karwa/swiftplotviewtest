// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftPlotViewTest",
    platforms: [.macOS("10.15"), .iOS("13.0"), .tvOS("13.0"), .watchOS("13.0")],
    products: [
      .executable(name: "SwiftPlotViewTest", targets: ["SwiftPlotViewTest"])
    ],
    dependencies: [
                .package(url: "https://github.com/karwa/swiftplot.git", .branch("dev")),
//        .package(path: "/Volumes/Code/swiftplot")
    ],
    targets: [
        .target(
            name: "SwiftPlotViewTest",
            dependencies: ["SwiftPlot", "QuartzRenderer"]),
    ]
)
