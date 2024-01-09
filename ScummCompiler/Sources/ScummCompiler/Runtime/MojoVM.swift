//
//  MojoVM.swift
//
//
//  Created by Michael Borgmann on 16/12/2023.
//

import Foundation

public class MojoVM: BaseVM {
    
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
                let constant = try chunk.readConstant(at: index)
                try push(value: constant)
            case .negate:
                try push(value: -pop())
            case .expression:
                break
            }
        }
    }
}
