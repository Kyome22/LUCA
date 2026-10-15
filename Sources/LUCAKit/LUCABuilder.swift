/*
 LUCABuilder.swift
 LUCAKit

 Created by Takuto Nakamura on 2025/12/18.
*/

import Foundation
import PathKit
import ProjectSpec
import Version
import XcodeGenKit

public struct LUCABuilder {
    var name: String
    var organizationID: String
    var platform: Platform
    var projectURL: URL

    public init(name: String, organizationID: String, platform: Platform, path: String?) {
        self.name = name.replacingOccurrences(of: "[ -/]", with: "_", options: .regularExpression)
        self.organizationID = organizationID
        self.platform = platform
        self.projectURL = if let path {
            URL(filePath: path)
        } else {
            URL(filePath: FileManager.default.currentDirectoryPath)
        }
    }

    public func run() throws {
        try checkDirectoryExistence()
        try copyLocalPackage()
        try copyApp()
        try generateXcodeProject()
    }

    func checkDirectoryExistence() throws {
        guard FileManager.default.fileExists(atPath: projectURL.path()) else {
            throw LUCAError.directoryDoesNotExist(path: projectURL.path())
        }
    }

    func copyLocalPackage() throws {
        guard let localPackageURL = ResourceBundle.bundle.url(forResource: "LocalPackage", withExtension: nil) else {
            throw LUCAError.resouceDoesNotFound(name: "LocalPackage")
        }
        guard let appDelegateURL = ResourceBundle.bundle.url(forResource: platform.appDelegateName, withExtension: "swift") else {
            throw LUCAError.resouceDoesNotFound(name: platform.appDelegateName)
        }
        let destLocalPackageURL = projectURL.appending(path: "LocalPackage")
        let destAppDelegateURL = destLocalPackageURL.appending(path: "Sources/Model/AppDelegate.swift")
        let destPackageSwiftURL = destLocalPackageURL.appending(path: "Package.swift")

        let copyOutput = Shell.run("""
            cd \(projectURL.path())
            cp -r \(localPackageURL.path()) ./LocalPackage
            cp \(appDelegateURL.path()) \(destAppDelegateURL.path())
            """)
        guard copyOutput.succeeded else {
            throw LUCAError.failedToCopyLocalPackage
        }

        var packageSwift = try String(contentsOf: destPackageSwiftURL, encoding: .utf8)
        packageSwift = packageSwift.replacingOccurrences(of: "PLATFORM_VERSION", with: platform.platformVersion)
        guard FileManager.default.createFile(
            atPath: destPackageSwiftURL.path(),
            contents: packageSwift.data(using: .utf8)
        ) else {
            throw LUCAError.failedToCopyLocalPackage
        }
    }

    func copyApp() throws {
        guard let appURL = ResourceBundle.bundle.url(forResource: platform.appTemplateName, withExtension: nil) else {
            throw LUCAError.resouceDoesNotFound(name: platform.appTemplateName)
        }
        let output = Shell.run("""
            cd \(projectURL.path())
            cp -r \(appURL.path()) ./\(name)
            mv \(name)/PROJECT_NAME.swift \(name)/\(name)App.swift
            """)
        guard output.succeeded else {
            throw LUCAError.failedToCopyApp
        }

        let destAppSwiftURL = projectURL.appending(path: "\(name)/\(name)App.swift")
        var appSwift = try String(contentsOf: destAppSwiftURL, encoding: .utf8)
        appSwift = appSwift.replacingOccurrences(of: "PROJECT_NAME", with: name)
        guard FileManager.default.createFile(
            atPath: destAppSwiftURL.path(),
            contents: appSwift.data(using: .utf8)
        ) else {
            throw LUCAError.failedToCopyApp
        }
    }

    func generateXcodeProject() throws {
        guard let projectYAMLURL = ResourceBundle.bundle.url(forResource: platform.projectYAMLName, withExtension: "yml") else {
            throw LUCAError.resouceDoesNotFound(name: "\(platform.projectYAMLName).yml")
        }
        var projectYAML = try String(contentsOf: projectYAMLURL, encoding: .utf8)
        projectYAML = projectYAML.replacingOccurrences(of: "PROJECT_NAME", with: name)
        projectYAML = projectYAML.replacingOccurrences(of: "ORGANIZATION_IDENTIFIER", with: organizationID)
        let projectDirectoryPath = Path(projectURL.path(percentEncoded: false))
        let projectYAMLPath = projectDirectoryPath + "project.yml"
        try projectYAMLPath.write(projectYAML)
        defer { try? projectYAMLPath.delete() }

        let project = try SpecLoader(version: Version(2, 46, 0)).loadProject(path: projectYAMLPath)
        try project.validate()
        let fileWriter = FileWriter(project: project)
        try fileWriter.writePlists()
        let userName = ProcessInfo.processInfo.environment["USER"] ?? NSUserName()
        let xcodeProject = try ProjectGenerator(project: project).generateXcodeProject(in: projectDirectoryPath, userName: userName)
        try fileWriter.writeXcodeProject(xcodeProject, to: projectDirectoryPath + "\(project.name).xcodeproj")
    }
}
