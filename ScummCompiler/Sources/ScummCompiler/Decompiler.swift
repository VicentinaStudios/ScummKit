//
//  File.swift
//  
//
//  Created by Michael Borgmann on 15/12/2023.
//

import Foundation

public struct Decompilation {
    let offset: Int
    let opcode: Opcode
    var constant: [UInt8: Value]? = nil
}

public class Decompiler {
    
    private var chunk: Chunk?
    private var offset: Array.Index?
    
    private func reset(with chunk: Chunk) {
        self.chunk = chunk
        offset = 0
    }
    
    public init() { }
        
    public func decompile(_ chunk: Chunk) throws -> [Decompilation]? {
        
        reset(with: chunk)
        
        var decompilation: [Decompilation]?
        
        while let current = offset, current < chunk.size {
            
            let instruction = try decompileInstruction(at: current)
            decompilation = (decompilation ?? []) + [instruction]
        }
        
        return decompilation
    }
    
    public func trace(_ chunk: Chunk, offset: Int) throws  {
        
        reset(with: chunk)
        self.offset = offset
        
        let decompilation = try decompileInstruction(at: offset)
        
        printInstruction(decompilation)
    }
    
    public func prettyPrint(_ decompilation: [Decompilation], name: String) {
        
        printHeader(name: name)
        
        decompilation.forEach { instruction in
            printInstruction(instruction)
        }
    }
    
    func printHeader(name: String) {
        
        print("== \(name) ==")
        
        print(
            "Offset".withCString { String(format: "%-6s", $0) },
            "Line".withCString { String(format: "%-4s", $0) },
            "Opcode".withCString { String(format: "%-16s", $0) },
            "@".withCString { String(format: "%-1s", $0) },
            "###".withCString { String(format: "%-3s", $0) }
        )
    }
    
    private func printInstruction(_ instruction: Decompilation) {
            
        let offset = String(format: "%04d", instruction.offset)
        let line = String(format: "%4d", chunk!.lines[instruction.offset])
        let opcode = instruction.opcode.name.withCString { String(format: "%-16s", $0) }
        
        if instruction.offset > 0,
           chunk?.lines[instruction.offset] == chunk?.lines[instruction.offset - 1]
        {
            print("[\(offset)]", "   |" , opcode, terminator: "")
        } else {
            print("[\(offset)]", line, opcode, terminator: "")
        }
        
        if let constant = instruction.constant,
           let key = constant.keys.first,
           let value = constant[key]
        {
            print(" \(key)", "'\(value)'", terminator: "")
        }
        
        print()
    }
    
    private func decompileInstruction(at offset: Int) throws -> Decompilation {
        
        guard let instruction = try chunk?.read(at: offset) else {
            throw CompilerError.cantFetchInstruction(offset)
        }
        
        guard let opcode = Opcode(rawValue: instruction) else {
            throw CompilerError.unknownOpcode(instruction)
        }
        
        switch opcode {
        case .breakHere:
            return try simpleInstruction(opcode: .breakHere)
        case .add:
            return try simpleInstruction(opcode: .add)
        case .subtract:
            return try simpleInstruction(opcode: .subtract)
        case .multiply:
            return try simpleInstruction(opcode: .multiply)
        case .divide:
            return try simpleInstruction(opcode: .divide)
        case .return:
            return try simpleInstruction(opcode: .breakHere)
        case .constant:
            return try constantInstruction(opcode: .constant)
        case .negate:
            return try simpleInstruction(opcode: .negate)
        }
    }
    
    private func simpleInstruction(opcode: Opcode) throws -> Decompilation {
        
        guard let offset = offset else {
            throw CompilerError.unknownIndex
        }
        
        let decompilation = Decompilation(offset: offset, opcode: opcode)
        
        self.offset = offset + 1
        
        return decompilation
    }
    
    private func constantInstruction(opcode: Opcode) throws -> Decompilation {
        
        guard
            let offset = offset,
            let constant = try chunk?.read(at: offset + 1),
            let value = chunk?.readConstant(byte: Int(constant - 1))
        else {
            throw CompilerError.unknownIndex
        }
        
        let decompilation = Decompilation(offset: offset, opcode: opcode, constant: [constant: value])
        
        self.offset = offset + 2
        
        return decompilation
    }
}
