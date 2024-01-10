//
//  ScummVM.swift
//
//
//  Created by Michael Borgmann on 16/12/2023.
//

import Foundation

public class ScummVM: BaseVM {
    
    internal override func run() throws {
        
        try super.run()
        
        while
            let instructionPointer = instructionPointer,
            let chunk = chunk,
            instructionPointer < chunk.size
        {
            
            if let decompilation = try decompiler?.trace(chunk, offset: instructionPointer) {
                print(decompilation)
            }
            
            let byte = try readNextByte()
            
            guard let instruction = Opcode(rawValue: byte) else {
                throw CompilerError.unknownOpcode(byte)
            }
            
            switch instruction {
            case .breakHere:
                debugPrint("break here")
            case .add:
                try binaryOperation(op: +)
            case .subtract:
                try binaryOperation(op: -)
            case .multiply:
                try binaryOperation(op: *)
            case .divide:
                try binaryOperation(op: /)
            case .return:
                 break
            case .constant:
                let index = try Int(readNextByte())
                let constant = try chunk.readConstant(at: index - 1)
                try push(value: constant)
            case .negate:
                try push(value: -pop())
            case .expression:
                
                try expression(chunk: chunk, offset: instructionPointer)
            }
        }
    }
}

// MARK: - SCUMM

extension ScummVM {
    
    private func expression(chunk: Chunk, offset: Int) throws {
        
        let variableNumber = try chunk.readWord(at: offset + 1)
        
        var current = offset + 3
        
        while
            let subOpcode = try? chunk.read(at: current),
            subOpcode != 0xff
        {
            
            current += 1
            
            switch subOpcode {
            
            case 0x1:
                
                let value = try chunk.readWord(at: current)
                try push(value: Int(value))
                current += 2
            
            case 0x2:
                try binaryOperation(op: +)
                
            case 0x3:
                try binaryOperation(op: -)
                
            case 0x4:
                try binaryOperation(op: *)
                
            case 0x5:
                try binaryOperation(op: /)
                
            default:
                throw CompilerError.compileError
            }
        }
    }
}
