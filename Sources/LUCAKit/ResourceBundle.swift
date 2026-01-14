/*
 ResourceBundle.swift
 LUCAKit

 Created by Takuto Nakamura on 2025/01/15.
*/

import Foundation

enum ResourceBundle {
    static let bundle: Bundle = {
        let bundleName = "LUCA_LUCAKit"

        guard let executableURL = Bundle.main.executableURL else {
            fatalError("Could not determine executable path")
        }
        let resolvedURL = executableURL.resolvingSymlinksInPath()
        let executableDir = resolvedURL.deletingLastPathComponent()

        let bundleURL = executableDir.appendingPathComponent("\(bundleName).bundle")
        if let bundle = Bundle(url: bundleURL) {
            return bundle
        }

        let mainBundlePath = Bundle.main.bundleURL
            .appendingPathComponent("\(bundleName).bundle")
        if let bundle = Bundle(url: mainBundlePath) {
            return bundle
        }

        fatalError("Could not load resource bundle: \(bundleURL.path)")
    }()
}
