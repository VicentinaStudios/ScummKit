//
//  MojoVM.swift
//
//
//  Created by Michael Borgmann on 16/12/2023.
//

import Foundation

/// A virtual machine implementation specialized for executing bytecode with Mojo opcodes.
///
/// `MojoVM` is a concrete implementation of the `BaseVM` class, providing a runtime environment
/// for interpreting and executing bytecode instructions using the opcodes defined in the
/// `MojoOpcode` enumeration.
public class MojoVM: BaseVM<MojoOpcode> {
    
    // MARK: Actions
    
    /// Executes the bytecode stored in the associated `chunk` using Mojo opcodes.
    ///
    /// The `run` method of `MojoVM` interprets and executes the bytecode instructions in the
    /// associated `chunk` using the opcodes defined in the `MojoOpcode` enumeration.
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
            
            guard let instruction = MojoOpcode(rawValue: byte) else {
                throw CompilerError.unknownOpcode(byte)
            }
            
            try handleInstruction(instruction)
            
            if Configuration.DEBUG_TRACE_EXECUTION {
                showStack()
            }
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
    
    /// Handles the execution of Mojo opcodes.
    ///
    /// The `handleInstruction` method processes and executes instructions based on the provided Mojo opcode.
    ///
    /// - Parameters:
    ///   - instruction: The Mojo opcode to be executed.
    /// - Throws: An error of type `VirtualMachineError` if an issue occurs during instruction execution.
    private func handleInstruction(_ instruction: MojoOpcode) throws {
        
        switch instruction {
            
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
