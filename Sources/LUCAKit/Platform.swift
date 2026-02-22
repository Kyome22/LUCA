/*
 Platform.swift
 LUCAKit

 Created by Takuto Nakamura on 2026/02/22.
*/

public enum Platform: String {
    case iOS
    case macOS

    var projectYAMLName: String {
        switch self {
        case .iOS: "project-ios"
        case .macOS: "project-macos"
        }
    }

    var appTemplateName: String {
        switch self {
        case .iOS: "App-iOS"
        case .macOS: "App-macOS"
        }
    }

    var appDelegateName: String {
        switch self {
        case .iOS: "AppDelegate-iOS"
        case .macOS: "AppDelegate-macOS"
        }
    }

    var platformVersion: String {
        switch self {
        case .iOS: ".iOS(.v17)"
        case .macOS: ".macOS(.v14)"
        }
    }
}
