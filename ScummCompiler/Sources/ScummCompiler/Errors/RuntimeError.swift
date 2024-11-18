//
//  RuntimeError.swift
//  
//
//  Created by Michael Borgmann on 15/01/2024.
//

import Foundation

enum RuntimeError: LocalizedError, Equatable {
    
    /// An error indicating that the instruction cannot be fetched at the specified offset.
    ///
    /// - Parameters:
    ///   - offset: The offset at which the instruction cannot be fetched.
    case cantFetchInstruction(Int)
    
    /// An error indicating that the operands provided for an operation are invalid.
    ///
    /// This error occurs when an operation expects operands of specific types or values, but incompatible or unexpected types are provided.
    case invalidOperands
    
    /// An error indicating that one or more operands required for an operation are missing.
    ///
    /// This error occurs when the virtual machine attempts to perform an operation but finds that insufficient data has been provided on the stack.
    case missingOperands
    
    /// An error indicating that the variable index used is not recognized.
    ///
    /// This error occurs when attempting to access the constant pool with an invalid or out-of-range index.
    ///
    /// - Parameters:
    ///   - index: The index that caused the error.
    case unknownVariableIndex(index: Int)
    
    /// An error indicating that a referenced variable is undefined.
    ///
    /// This error occurs when attempting to use a variable that has not been declared or assigned a value.
    ///
    /// - Parameters:
    ///   - name: The name of the variable that is undefined.
    case undefinedVariable(name: String)
    
    /// An error indicating that an unrecognized opcode was encountered.
    ///
    /// This error occurs when the virtual machine attempts to execute a bytecode instruction but encounters an unknown or invalid opcode.
    ///
    /// - Parameters:
    ///   - byte: The unrecognized opcode byte.
    case unknownOpcode(byte: UInt8)
    
    /// A human-readable description of the error.
    var errorDescription: String? {
        
        switch self {
        case .cantFetchInstruction:
            return "Can't Fetch Instruction"
        case .missingOperands:
            return "Missing Operands"
        case .invalidOperands:
            return "Invalid Operands"
        case .unknownVariableIndex:
            return "Unknown Variable Index"
        case .undefinedVariable:
            return "Undefined Variable"
        case .unknownOpcode:
            return "Unknown Opcode"
        }
    }
    
    /// A localized message describing what caused the failure.
    var failureReason: String? {
        
        switch self {
        case .cantFetchInstruction(let offset):
            return "No instruction found at byte `\(offset)`."
        case .missingOperands:
            return "Operands must be two numbers or two strings."
        case .invalidOperands:
            return "Operands must be of compatible types. Ensure the operation receives two numbers or two strings."
        case .unknownVariableIndex(let index):
            return "The constant pool does not contain an entry at index \(index)."
        case .undefinedVariable(let name):
            return "The variable '\(name)' was referenced, but it has not been declared or initialized."
        case .unknownOpcode(let byte):
            return "The opcode '\(byte)' encountered in the bytecode is not recognized by the virtual machine."
        }
    }
    
    /// A localized recovery suggestion to resolve the error.
    var recoverySuggestion: String? {
        
        switch self {
        case .cantFetchInstruction:
            return "The data is corrupted, and can be a compilation error. Try to clean the project and compile again."
        case .missingOperands:
            return "Data on the heap is missing, and can be a compilation error. Try to clean to project and compile again."
        case .invalidOperands:
            return "Check the types of the operands. Ensure you're using compatible types (either two strings or two numbers) for the operation."
        case .unknownVariableIndex:
            return "Check the constant pool for valid indices and ensure the bytecode refers to the correct constant."
        case .undefinedVariable(let name):
            return "Ensure that the variable '\(name)' is declared and assigned a value before it is referenced in the code."
        case .unknownOpcode:
            return "Inspect the bytecode for errors or corruption. Ensure all opcodes are valid and supported by the virtual machine."
        }
    }
}
