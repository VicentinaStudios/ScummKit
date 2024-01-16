//
//  ScummDecompiler.swift
//
//
//  Created by Michael Borgmann on 15/01/2024.
//

import Foundation

/// A decompiler for SCUMM opcodes.
class ScummDecompiler: BaseDecompiler<ScummOpcode> {
    
    /// Handle the decompilation of a SCUMM opcode.
    /// - Parameter opcode: The SCUMM opcode to handle.
    /// - Returns: The decompilation of the SCUMM opcode.
    /// - Throws: An error if handling fails.
    override func handleInstruction(_ opcode: ScummOpcode) throws -> Decompilation {
        
        switch opcode {
            
        case .breakHere:
            return try simpleInstruction(opcode: .breakHere)
        case .expression:
            return try simpleInstruction(opcode: .expression)
        }
    }
}
