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

// demos()

if args.count == 1 {
    repl()
} else if args.count == 2 {
    run(args[1])
} else if args.count == 3 {
    Configuration.DEBUG_TRACE_EXECUTION = true
    run(args[1])
} else {
    fputs("Usage: scumm [path] [-d]\n", stderr);
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
        
    do {
        try? vm.interpret(source: source)
    } catch {
        print(error)
    }
}

func demos() {
    
    Configuration.DEBUG_TRACE_EXECUTION = true
    
    print("** Chunk Demo **")
    let chunk = chunkVM
    
    print("... completed\n")
    
    print("** Decompiler Demo **")
    let decompiler = Decompiler()
    guard let decompilation = try? decompiler.decompile(chunk) else {
        fatalError()
    }
    print(decompiler.prettyPrint(decompilation, name: "Demo Chunk"))
    print("... completed\n")
    
    print("** Virtual Machine Demo **")
    let vm = VirtualMachine()
    try? vm.interpret(chunk: chunk)
    print("... completed\n")
    
    exit(0)
}

var chunkVM: Chunk {
    
    // -((1 + 3) / 2)
    
    let chunk = Chunk()
    
    var constant = chunk.addConstant(value: 1)
    chunk.write(byte: Opcode.constant.rawValue, line: 1)
    chunk.write(byte: UInt8(constant), line: 1)
    
    constant = chunk.addConstant(value: 3)
    chunk.write(byte: Opcode.constant.rawValue, line: 1)
    chunk.write(byte: UInt8(constant), line: 1)
    
    chunk.write(byte: Opcode.add.rawValue, line: 1)
    
    constant = chunk.addConstant(value: 2)
    chunk.write(byte: Opcode.constant.rawValue, line: 1)
    chunk.write(byte: UInt8(constant), line: 1)
    
    chunk.write(byte: Opcode.divide.rawValue, line: 1)
    
    chunk.write(byte: Opcode.negate.rawValue, line: 3)
    
    return chunk
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
