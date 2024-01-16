//
//  ScummVM.swift
//
//
//  Created by Michael Borgmann on 16/12/2023.
//

import Foundation

/// A virtual machine implementation specialized for executing bytecode with SCUMM opcodes.
///
/// `ScummVM` is a concrete implementation of the `BaseVM` class, providing a runtime environment
/// for interpreting and executing bytecode instructions using the opcodes defined in the
/// `ScummOpcode` enumeration.
public class ScummVM: BaseVM<ScummOpcode> {
    
    /// Run the SCUMM virtual machine.
    ///
    /// - Throws: An error of type `VirtualMachineError` if an issue occurs during execution.
    internal override func run() throws {
        
        try super.run()
        
        while
            let instructionPointer = instructionPointer,
            let chunk = chunk,
            instructionPointer < chunk.size
        {
            
            try printDecompilation()
            
            let byte = try readNextByte()
            
            guard let instruction = ScummOpcode(rawValue: byte) else {
                throw CompilerError.unknownOpcode(byte)
            }
            
            try handleInstruction(instruction)
        }
    }
}

// MARK: Debug

extension ScummVM {
    
    /// Prints the decompilation of the current instruction if decompiler is enabled.
    ///
    /// - Throws: An error of type `VirtualMachineError` if an issue occurs during decompilation.
    private func printDecompilation() throws {
        
        guard let instructionPointer = instructionPointer else {
            throw VirtualMachineError.undefinedInstructionPointer
        }
        
        guard let chunk = chunk else {
            throw VirtualMachineError.emptyChunk
        }
        
        if let decompilation = try decompiler?.trace(chunk, offset: instructionPointer) {
            print(decompilation)
        }
    }
}

// MARK: - SCUMM

extension ScummVM {
    
    /// Handles the execution of a SCUMM opcode.
    /// - Parameter instruction: The SCUMM opcode to handle.
    /// - Throws: An error of type `VirtualMachineError` if an issue occurs during opcode execution.
    private func handleInstruction(_ instruction: ScummOpcode) throws {
        
        guard let instructionPointer = instructionPointer else {
            throw VirtualMachineError.undefinedInstructionPointer
        }
        
        guard let chunk = chunk else {
            throw VirtualMachineError.emptyChunk
        }
        
        switch instruction {
        case .breakHere:
            debugPrint("break here")
        case .expression:
            try expression(chunk: chunk, offset: instructionPointer)
        }
    }
    
    /// Executes a SCUMM expression opcode.
    /// - Parameters:
    ///   - chunk: The chunk containing the bytecode.
    ///   - offset: The offset of the expression opcode.
    /// - Throws: An error of type `VirtualMachineError` if an issue occurs during expression execution.
    private func expression(chunk: Chunk, offset: Int) throws {
        
        let variableNumber = try chunk.readWord(at: offset)
        
        var current = offset + 2
        
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
        
        guard
            let instructionPointer = instructionPointer,
            instructionPointer < chunk.size
        else {
            throw VirtualMachineError.undefinedInstructionPointer
        }
        
        self.instructionPointer = instructionPointer + current
    }
}
