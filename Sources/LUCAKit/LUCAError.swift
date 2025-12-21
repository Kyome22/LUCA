/*
 LUCAError.swift
 LUCAKit

 Created by Takuto Nakamura on 2025/12/21.
*/

import Foundation

public enum LUCAError: LocalizedError {
    case directoryDoesNotExist(path: String)
    case resouceDoesNotFound(name: String)
    case xcodegenDoesNotExist
    case failedToCopyLocalPackage
    case failedToCopyApp
    case failedToGenerateXcodeProject

    public var errorDescription: String? {
        switch self {
        case let .directoryDoesNotExist(path):
            "The directory \(path) does not exist."
        case let .resouceDoesNotFound(name):
            "The resource \(name) does not found."
        case .xcodegenDoesNotExist:
            "xcodegen command does not exist. Please install it."
        case .failedToCopyLocalPackage:
            "Failed to copy LocalPackage."
        case .failedToCopyApp:
            "Failed to copy App."
        case .failedToGenerateXcodeProject:
            "Failed to generate XcodeProject."
        }
    }
}
