//
//  MojoDecompiler.swift
//  
//
//  Created by Michael Borgmann on 15/01/2024.
//

import Foundation

/// A decompiler for Mojo opcodes.
public class MojoDecompiler: BaseDecompiler<MojoOpcode> {
    
    /// Handle the decompilation of a Mojo opcode.
    /// - Parameter opcode: The Mojo opcode to handle.
    /// - Returns: The decompilation of the Mojo opcode.
    /// - Throws: An error if handling fails.
    override func handleInstruction(_ opcode: MojoOpcode) throws -> Decompilation {
        
        switch opcode {
            
        case .add:
            return try simpleInstruction(opcode: .add)
        case .subtract:
            return try simpleInstruction(opcode: .subtract)
        case .multiply:
            return try simpleInstruction(opcode: .multiply)
        case .divide:
            return try simpleInstruction(opcode: .divide)
        case .not:
            return try simpleInstruction(opcode: .not)
        case .constant:
            return try constantInstruction(opcode: .constant)
        case .negate:
            return try simpleInstruction(opcode: .negate)
        case .return:
            return try simpleInstruction(opcode: .return)
        case .true:
            return try simpleInstruction(opcode: .true)
        case .false:
            return try simpleInstruction(opcode: .false)
        case .equal:
            return try simpleInstruction(opcode: .equal)
        case .greater:
            return try simpleInstruction(opcode: .greater)
        case .less:
            return try simpleInstruction(opcode: .less)
        case .nil:
            return try simpleInstruction(opcode: .nil)
        case .print:
            return try simpleInstruction(opcode: .print)
        case .pop:
            return try simpleInstruction(opcode: .pop)
        case .global:
            return try constantInstruction(opcode: .global)
        case .get:
            return try constantInstruction(opcode: .get)
        case .set:
            return try constantInstruction(opcode: .set)
        }
    }
    
    /// Handle the decompilation of a Mojo constant instruction.
    /// - Parameter opcode: The Mojo opcode representing a constant instruction.
    /// - Returns: The decompilation of the Mojo constant instruction.
    /// - Throws: An error if handling fails.
    private func constantInstruction(opcode: MojoOpcode) throws -> Decompilation {
        
        guard
            let offset = offset,
            let constant = try chunk?.read(at: offset + 1),
            let value = try chunk?.readConstant(at: Int(constant))
        else {
            throw CompilerError.unknownIndex
        }
        
        let decompilation = Decompilation(offset: offset, opcode: opcode, constant: [constant: value])
        
        self.offset = offset + 2
        
        return decompilation
    }
}
