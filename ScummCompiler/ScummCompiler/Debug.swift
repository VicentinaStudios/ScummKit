//
//  Debug.swift
//  ScummCompiler
//
//  Created by Michael Borgmann on 24/11/2023.
//

import Foundation

func disassembleChunk(chunk: Chunk, name: String) {
    
    print("== \(name) --")
    
    var offset = 0
    
    while offset < chunk.code.count {
        offset = disassembleInstruction(chunk: chunk, offset: offset)
    }
}

func disassembleInstruction(chunk: Chunk, offset: Int) -> Int {
    
    print(String(format: "%04d", offset), terminator: " ")
    
    if offset > 0 && chunk.lines[offset] == chunk.lines[offset - 1] {
        print("   |", terminator: " ")
    } else {
        print(String(format: "%4d", chunk.lines[offset]), terminator: " ")
    }
    
    let instruction = chunk.code[offset]
    
    switch Opcode(rawValue: instruction) {
    case .constant:
        return constantInstruction(name: "constant", chunk: chunk, offset: offset)
    case .return:
        return simpleInstruction(name: "return", offset: offset)
    default:
        print("Unknown opcode", instruction)
        return offset + 1
    }
}

func simpleInstruction(name: String, offset: Int) -> Int {
    
    print(name)
    
    return offset + 1
}

func constantInstruction(name: String, chunk: Chunk, offset: Int) -> Int{
    
    let constant = chunk.code[offset + 1]
    
    //let formattedString = String(format: "%-16s %04d '", name, constant)
    //let formatted = String(format: "%-12s %04d", name, constant)
    let formatted = name.withCString { String(format: "%-16s %4d", $0, constant) }
    
    print(formatted, terminator: " ")
    print("'\(chunk.constants.values[Int(constant) - 1])'")
    
    return offset + 2
}

func printValue(value: Value) {
    print(value)
}
