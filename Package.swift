// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "swirc-message-parser",
    products: [
        .library(
            name: "SWIRCMessageParser",
            targets: ["SWIRCMessageParser"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SWIRCMessageParser",
            dependencies: [],
            path: "Src"
        ),
        .testTarget(
            name: "SWIRCMessageParserTests",
            dependencies: ["SWIRCMessageParser"],
            path: "Tests"
        )
    ]
)
