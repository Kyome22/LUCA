/*
 main.swift
 LUCA

 Created by Takuto Nakamura on 2025/12/18.
*/

import ArgumentParser
import Foundation
import LUCAKit

extension Platform: ExpressibleByArgument {}

struct LUCA: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "luca",
        abstract: "A tool to construct LUCA for Xcode project.",
        version: "2.0.0"
    )

    @Option(
        name: .shortAndLong,
        help: "The project name."
    )
    var name: String

    @Option(
        name: .shortAndLong,
        help: "The organization identifier (e.g., com.company)."
    )
    var organizationID: String

    @Option(
        name: .long,
        help: "The target platform (iOS or macOS).",
    )
    var platform: Platform = .iOS

    @Option(
        name: .shortAndLong,
        help: "The path to the directory to create Xcode project.",
        completion: .directory,
    )
    var path: String?

    mutating func run() throws {
        try LUCABuilder(name: name, organizationID: organizationID, platform: platform, path: path).run()
    }
}

LUCA.main()
