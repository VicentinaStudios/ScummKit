//
//  main.swift
//  ScummCompiler
//
//  Created by Michael Borgmann on 24/11/2023.
//

import Foundation

let DEBUG_TRACE_EXECUTION = false
let DEBUG_PRINT_CODE = true
let appName = "SCUMM Script Compiler"
let version = "v0.1"

var virtualMachine = VirtualMachine()

private let cli = CLI(
    args: Array(CommandLine.arguments.dropFirst())
)

// Show REPL when no args are passed
if cli.args.isEmpty {
    repl()
}

// Show version or help
if cli.args.shouldShowVersion {
    print("\(appName) \(version)".escape.greenBold)
    exit(1)
} else if cli.args.shouldShowHelp {
    cli.printUsage()
    exit(1)
}

// Get SCUMM version
guard let scummVersion = cli.args.extractTargetVersion else {
    let message = "No SCUMM version specified.".escape.whiteBold
    CLI.writeMessage(message, to: .error)
    exit(1)
}

guard (0...8).contains(scummVersion) else {
    let message = "Invalid SCUMM version.".escape.whiteBold
    CLI.writeMessage(message, to: .error)
    exit(1)
}

// Get SCUMM files to compile

guard let filenames = cli.args.extractFilenames else {
    let message = "No input file(s)".escape.whiteBold
    CLI.writeMessage(message, to: .error)
    exit(1)
}

let filesNotFound = filenames.filter { filename in
    !FileManager.default.fileExists(atPath: filename)
}

guard filesNotFound.isEmpty else {
    let message = "Files not found: \(filesNotFound.joined(separator: ", "))".escape.whiteBold
    CLI.writeMessage(message, to: .error)
    exit(1)
}

guard let fileName = filenames.first else {
    let message = "No file(s) to compile".escape.whiteBold
    CLI.writeMessage(message, to: .error)
    exit(1)
}

runFile(fileName)

// Run REPL

fileprivate func repl() {
    
    print("\(appName) \(version)".escape.greenBold)
    
    while true {
        
        print(">>> ", terminator: "")
        
        if let line = readLine() {
            interpret(line)
        } else {
            break
        }
    }
    
    exit(1)
}

// Run file

func runFile(_ fileName: String) {
    
    print("Build", fileName)
    
    guard let source = try? String(contentsOfFile: fileName, encoding: .utf8) else {
        let message = "Can't read file: \(fileName)"
        CLI.writeMessage(message, to: .error)
        exit(1)
    }
    
    let result = interpret(source)
    
    if result == .compileError {
        exit(65)
    } else if result == .runtimeError {
        exit(70)
    }
}

// Interpret SCUMM script code

fileprivate func interpret(_ code: String) -> InterpretResult {
    
    //compile(source: code)
    virtualMachine.interpret(source: code)
    
    return .ok
}
