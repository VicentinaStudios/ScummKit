//
//  MojoVM.swift
//
//
//  Created by Michael Borgmann on 16/12/2023.
//

import Foundation

/// A virtual machine implementation specialized for executing bytecode with custom opcodes.
public class MojoVM: BaseVM {
    
    // MARK: Actions
    
    /// Executes the bytecode stored in the associated `chunk` using custom opcodes.
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
            
            guard let instruction = Opcode(rawValue: byte) else {
                throw CompilerError.unknownOpcode(byte)
            }
            
            try handleInstruction(instruction)
        }
    }
}

// MARK: - Debug

extension MojoVM {
    
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

extension MojoVM {
    
    /// Handles the execution of instructions based on their opcodes.
    ///
    /// - Parameters:
    ///   - instruction: The opcode to be executed.
    /// - Throws: An error of type `VirtualMachineError` if an issue occurs during instruction execution.
    private func handleInstruction(_ instruction: Opcode) throws {
        
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
            try handleConstant()
            
        case .negate:
            try push(value: -pop())
            
        case .expression:
            break
        }
    }
    
    /// Handles the execution of the constant instruction.
    ///
    /// - Throws: An error of type `VirtualMachineError` if an issue occurs during constant handling.
    private func handleConstant() throws {
        
        guard let chunk = chunk else {
            throw VirtualMachineError.emptyChunk
        }
        
        let index = try Int(readNextByte())
        let constant = try chunk.readConstant(at: index)
        try push(value: constant)
    }
}
