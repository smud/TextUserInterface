import PackageDescription

let package = Package(
    name: "TextUserInterface",
    dependencies: [
        .Package(url: "https://github.com/smud/Smud.git", majorVersion: 0),
        .Package(url: "https://github.com/smud/ScannerUtils.git", majorVersion: 1),
    ]
)
