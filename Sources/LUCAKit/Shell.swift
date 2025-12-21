/*
 Shell.swift
 LUCAKit

 Created by Takuto Nakamura on 2025/12/21.
*/

import Foundation

enum Shell {
    @discardableResult
    static func run(_ args: String...) -> ShellOutput {
        let task = Process()
        task.launchPath = "/bin/sh"
        task.arguments = ["-c", args.joined(separator: " ")]
        let outputPipe = Pipe()
        let errorPipe = Pipe()
        task.standardOutput = outputPipe
        task.standardError = errorPipe
        task.launch()
        task.waitUntilExit()
        return ShellOutput(
            terminationStatus: task.terminationStatus,
            outputFileHandle: outputPipe.fileHandleForReading,
            errorFileHandle: errorPipe.fileHandleForReading
        )
    }
}

struct ShellOutput {
    var succeeded: Bool
    var outputs: [String]
    var errors: [String]

    init(
        terminationStatus: Int32,
        outputFileHandle: FileHandle,
        errorFileHandle: FileHandle
    ) {
        succeeded = (terminationStatus == .zero)

        let outputData = outputFileHandle.readDataToEndOfFile()
        let output = String(data: outputData, encoding: .utf8)
        outputs = output?.components(separatedBy: .newlines) ?? []

        let errorData = errorFileHandle.readDataToEndOfFile()
        let error = String(data: errorData, encoding: .utf8)
        errors = error?.components(separatedBy: .newlines) ?? []
    }

    func printOutput() {
        outputs.forEach { print($0) }
    }

    func printError() {
        errors.forEach { print($0) }
    }
}
