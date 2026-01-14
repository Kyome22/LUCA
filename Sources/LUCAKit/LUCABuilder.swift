/*
 LUCABuilder.swift
 LUCAKit

 Created by Takuto Nakamura on 2025/12/18.
*/

import Foundation

public struct LUCABuilder {
    var name: String
    var organizationID: String
    var projectURL: URL

    public init(name: String, organizationID: String, path: String?) {
        self.name = name.replacingOccurrences(of: "[ -/]", with: "_", options: .regularExpression)
        self.organizationID = organizationID
        self.projectURL = if let path {
            URL(filePath: path)
        } else {
            URL(filePath: FileManager.default.currentDirectoryPath)
        }
    }

    public func run() throws {
        try checkDirectoryExistence()
        try checkXcodegenExistence()
        try copyLocalPackage()
        try copyApp()
        try generateXcodeProject()
    }

    func checkDirectoryExistence() throws {
        guard FileManager.default.fileExists(atPath: projectURL.path()) else {
            throw LUCAError.directoryDoesNotExist(path: projectURL.path())
        }
    }

    func checkXcodegenExistence() throws {
        let output = Shell.run("xcodegen --version >/dev/null 2>&1")
        guard output.succeeded else {
            throw LUCAError.xcodegenDoesNotExist
        }
    }

    func copyLocalPackage() throws {
        guard let localPackageURL = ResourceBundle.bundle.url(forResource: "LocalPackage", withExtension: nil) else {
            throw LUCAError.resouceDoesNotFound(name: "LocalPackage")
        }
        let output = Shell.run("""
            cd \(projectURL.path())
            cp -r \(localPackageURL.path()) ./LocalPackage
            """)
        guard output.succeeded else {
            throw LUCAError.failedToCopyLocalPackage
        }
    }

    func copyApp() throws {
        guard let appURL = ResourceBundle.bundle.url(forResource: "App", withExtension: nil) else {
            throw LUCAError.resouceDoesNotFound(name: "App")
        }
        let output = Shell.run("""
            cd \(projectURL.path())
            cp -r \(appURL.path()) ./\(name)
            mv \(name)/PROJECT_NAME.swift \(name)/\(name)App.swift
            sed -r "s/PROJECT_NAME/\(name)/g" \(name)/\(name)App.swift
            """)
        guard output.succeeded else {
            throw LUCAError.failedToCopyApp
        }
    }

    func generateXcodeProject() throws {
        guard let projectYAMLURL = ResourceBundle.bundle.url(forResource: "project", withExtension: "yml") else {
            throw LUCAError.resouceDoesNotFound(name: "project.yml")
        }
        var projectYAML = try String(contentsOf: projectYAMLURL, encoding: .utf8)
        projectYAML = projectYAML.replacingOccurrences(of: "PROJECT_NAME", with: name)
        projectYAML = projectYAML.replacingOccurrences(of: "ORGANIZATION_IDENTIFIER", with: organizationID)
        FileManager.default.createFile(
            atPath: projectURL.appending(path: "project.yml").path(),
            contents: projectYAML.data(using: .utf8)
        )
        let output = Shell.run("""
            cd \(projectURL.path())
            xcodegen generate
            rm project.yml
            """)
        guard output.succeeded else {
            output.printError()
            throw LUCAError.failedToGenerateXcodeProject
        }
    }
}
