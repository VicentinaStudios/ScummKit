//
//  main.swift
//  ScummInterpreter
//
//  Created by Michael Borgmann on 15/07/2023.
//

import Foundation

// MARK: - Properties

private let cli = CLI(
    args: Array(CommandLine.arguments.dropFirst())
)

// MARK: Parse Arguments

if cli.args.isEmpty {
    runPrompt()
}

if cli.args.shouldShowVersion {
    print("SCUMM Script Interpreter 0.1".escape.greenBold)
    exit(1)
} else if cli.args.shouldShowHelp {
    cli.printUsage()
    exit(1)
}

let scummVersion = cli.args.extractTargetVersion ?? 5

guard (0...8).contains(scummVersion) else {
    let message = "Invalid SCUMM version.".escape.whiteBold
    CLI.writeMessage(message, to: .error)
    exit(1)
}

guard scummVersion == 5 else {
    let message = "SCUMM version not supported.".escape.whiteBold
    CLI.writeMessage(message, to: .error)
    exit(1)
}

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

filenames.forEach { filename in
    runFile(filename: filename)
}

// MARK: - REPL

fileprivate func runPrompt() {
    
    print("SCUMM Script Interpreter v0.1".escape.greenBold)
    
    while true {
        
        print(">>> ", terminator: "")
        
        if let line = readLine() {
            run(line)
        } else {
            break
        }
    }
    
    exit(10)
}

fileprivate func runFile(filename: String) {
    
    print("Build", filename)
    
    guard let script = try? String(contentsOfFile: filename, encoding: .utf8) else {
        let message = "Can't read file: \(filename)"
        CLI.writeMessage(message, to: .error)
        exit(1)
    }
    
    run(script)
    
    exit(1)
}

fileprivate func run(_ code: String) {
    
    do {
        
        let scanner = Scanner(code)
        let tokens = try scanner.scanTokens()
        let parser = Parser(tokens: tokens)
        let statements = parser.parse()
        let interpreter = Interpreter()
        interpreter.interpret(statements: statements)
        
    } catch {
        ErrorHandler.handle(error)
    }
}
