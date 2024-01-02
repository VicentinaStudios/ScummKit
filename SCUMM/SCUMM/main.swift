//
//  main.swift
//  SCUMM
//
//  Created by Michael Borgmann on 14/12/2023.
//

import Foundation
import ScummCompiler

let vm = VirtualMachine()

let args = Array(CommandLine.arguments)

if args.count == 1 {
    repl()
} else if args.count == 2 {
    run(args[1])
} else {
    
    fputs("Usage: clox [path]\n", stderr);
    exit(ExitStatusCodes.commandLineUsageError.rawValue)
}

func repl() {
    
    while true {
        
        print("> ", terminator: "")

        if let line = readLine() {
            try? vm.interpret(source: line)
        } else {
            break
        }
    }
}

func run(_ filename: String) {
    
    guard
        let source = try? String(contentsOfFile: filename, encoding: .utf8)
    else {
        fatalError("Can't read file: \(filename)")
    }
    
    try? vm.interpret(source: source)
}

func demos() {
    print("** Chunk Demo **")
    let chunk = Chunk()
    chunk.write(byte: Opcode.breakHere.rawValue)
    print("... completed")
    
    print("** Decompiler Demo **")
    let decompiler = Decompiler()
    guard let decompilation = try? decompiler.decompile(chunk) else {
        fatalError()
    }
    print(decompilation)
    print("... completed")
    
    print("** Virtual Machine Demo **")
    let vm = VirtualMachine()
    try? vm.interpret(chunk: chunk)
    print("... completed")
}

enum ExitStatusCodes: Int32 {
    
    case successfulTermination = 0
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
