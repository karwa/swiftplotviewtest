// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftPlotViewTest",
    platforms: [.macOS("10.15"), .iOS("13.0"), .tvOS("13.0"), .watchOS("6.0")],
    products: [
        .library(name: "SwiftPlotViews", targets: ["SwiftPlotViews"]),
        .executable(name: "SwiftPlotViewTest", targets: ["SwiftPlotViewTest"])
    ],
    dependencies: [
        .package(url: "https://github.com/karwa/swiftplot.git", .branch("dev")),
        //        .package(path: "/Volumes/Code/swiftplot")
    ],
    targets: [
        .target(name: "SwiftPlotViews", dependencies: ["SwiftPlot", "QuartzRenderer"]),
        .target(
            name: "SwiftPlotViewTest",
            dependencies: ["SwiftPlot", "SwiftPlotViews"]),
    ]
)
