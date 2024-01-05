//
//  main.swift
//  SCUMM
//
//  Created by Michael Borgmann on 14/12/2023.
//

import Foundation
import ScummCompiler

let args = Array(CommandLine.arguments)

//demos()

if CommandLine.shouldDisableANSI {
    Options.isAnsiEnabled = false
}

if CommandLine.shouldEnableDebug {
    Options.isDebugEnabled = true
    Configuration.DEBUG_TRACE_EXECUTION = true
}

if CommandLine.shouldShowVersion {
    print("SCUMM Compiler v0.1".escape.greenBold)
    exit(ExitStatusCodes.successfulTermination.rawValue)
} else if CommandLine.shouldShowHelp {
    let executableName = (CommandLine.arguments[0] as NSString).lastPathComponent
    print("Syntax:\n\t\t\(executableName) [OPTIONS] FILENAME")
    print("Options:\n\t\t-v5     Input Script is v5")
    exit(ExitStatusCodes.successfulTermination.rawValue)
}

Options.frontend = CommandLine.extractFrontend ?? "decent"
Options.backend = CommandLine.extractBackend ?? "scumm"
Options.runtime = CommandLine.extractRuntime ?? "scumm"

if Options.backend == "scumm" {
    
    Options.version = CommandLine.extractTargetVersion ?? 5
    
    guard (0...8).contains(Options.version) else {
        let error = "Error:".escape.red
        let message = "Invalid SCUMM version.".escape.whiteBold
        fputs("\(error) \(message)\n", stderr)
        exit(ExitStatusCodes.terminateApp.rawValue)
    }
    
    guard Options.version == 5 else {
        let error = "Error:".escape.red
        let message = "SCUMM version not supported.".escape.whiteBold
        fputs("\(error) \(message)\n", stderr)
        exit(ExitStatusCodes.terminateApp.rawValue)
    }
}

guard let filenames = CommandLine.extractFilenames else {
    repl()
    exit(ExitStatusCodes.terminateApp.rawValue)
}

let filesNotFound = filenames.filter { filename in
    !FileManager.default.fileExists(atPath: filename)
}

guard filesNotFound.isEmpty else {
    let error = "Error:".escape.red
    let message = "Files not found: \(filesNotFound.joined(separator: ", "))".escape.whiteBold
    fputs("\(error) \(message)\n", stderr)
    exit(ExitStatusCodes.terminateApp.rawValue)
}

filenames.forEach { filename in
    run(filename)
}

exit(ExitStatusCodes.terminateApp.rawValue)

func repl() {
    
    while true {
        
        print("> ", terminator: "")

        if let line = readLine() {
            let vm = MojoVM()
            try? vm.interpret(source: line)
        } else {
            break
        }
    }
}

func run(_ filename: String) {
    
    guard
        let source = try? String(contentsOfFile: filename, encoding: .utf8),
        let frontend = Configuration.ParserType(rawValue: Options.frontend),
        let backend = Configuration.Backend(rawValue: Options.backend),
        let runtime = Configuration.Runtime(rawValue: Options.runtime)
    else {
        fatalError("Can't read file: \(filename)")
    }
    
    Configuration.PARSER = frontend
    Configuration.BACKEND = backend
    
    do {
        let compiler = Compiler()
        
        guard let chunk = try compiler.compile(source: source) else {
            print("empty chunk")
            exit(ExitStatusCodes.terminateApp.rawValue)
        }
        
        switch runtime {
        case .ast:
            print("Abstratc Syntax Tree")
        case .interpreter:
            print("Interpreter")
        case .mojo:
            print("Mojo VM")
            let vm = MojoVM()
            try vm.interpret(chunk: chunk)
        case .scumm:
            print("SCUMM VM")
            let vm = ScummVM()
            try vm.interpret(chunk: chunk)
        case .decompiler:
            print("Mojo Decompiler")
            let decompiler = Decompiler()
            if let decompilation = try decompiler.decompile(chunk){
                decompiler.prettyPrint(decompilation, name: "Demo Chunk")
            }
        }
    } catch {
        print(error)
    }
}

enum ExitStatusCodes: Int32 {
    
    case successfulTermination = 0
    case terminateApp = 1
    case commandLineUsageError = 64
    case dataFormatError = 65
    case cannotOpenInput = 66
    case addresseeUnknown = 67
    case hostNameUnknown = 68
    case serviceUnavailable = 69
    case internalSoftwareError = 70
    case systemError = 71
    case criticalOperatingSystemFileMissing = 72
    case cantCreateUserOutputFile = 73
    case inputOutputError = 74
    case tempFailureUserInvitedToRetry = 75
    case remoteErrorInOrotocol = 76
    case permissionDenied = 77
    case configurationError = 78
}
