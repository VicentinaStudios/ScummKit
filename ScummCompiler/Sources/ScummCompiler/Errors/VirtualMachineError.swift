//
//  VirtualMachineError.swift
//
//
//  Created by Michael Borgmann on 09/01/2024.
//

import Foundation

enum VirtualMachineError: LocalizedError, Equatable {
    
    /// An error indicating an attempt to pop from an empty stack.
    ///
    /// This error occurs when attempting to retrieve a value from the stack, but the stack is empty.
    ///
    /// - Throws: `VirtualMachineError.emptyStack` if the stack is empty.
    case emptyStack
    
    /// An error indicating an attempt to push onto a full stack.
    ///
    /// This error occurs when trying to add a value to the stack, but the stack has reached its maximum capacity.
    ///
    /// - Throws: `VirtualMachineError.fullStack` if the stack is full.
    case fullStack
    
    /// An error indicating an undefined instruction pointer.
    ///
    /// This error occurs when attempting to execute an instruction, but the instruction pointer is not properly set.
    ///
    /// - Throws: `VirtualMachineError.undefinedInstructionPointer` if the instruction pointer is undefined.
    case undefinedInstructionPointer
    
    /// An error indicating division by zero.
    ///
    /// This error occurs when dividing a number by zero during arithmetic operations, and an optional line number may be provided.
    ///
    /// - Parameters:
    ///   - line: The line number where the division by zero occurred, or `nil` if the line is unknown.
    /// - Throws: `VirtualMachineError.divisionByZero` if division by zero occurs.
    case divisionByZero(line: Int?)
    
    /// A human-readable description of the error.
    var errorDescription: String? {
        
        switch self {
            
        case .emptyStack:
            return "Empty Stack"
            
        case .fullStack:
            return "Full Stack"
            
        case .undefinedInstructionPointer:
            return "Undefined Instruction Pointer"
            
        case .divisionByZero:
            return "Division by Zero"
        }
    }
    
    /// A localized message describing what caused the failure.
    var failureReason: String? {
        
        switch self {
            
        case .emptyStack:
            return "Attempted to pop from an empty stack."
            
        case .fullStack:
            return "Attempted to push onto a full stack."
            
        case .undefinedInstructionPointer:
            return "Instruction pointer is not defined."
            
        case .divisionByZero(let line):
            return "Division by zero at line: '\(line.map { "\($0)" } ?? "unknown")'"
        }
    }
    
    /// A localized recovery suggestion to resolve the error.
    var recoverySuggestion: String? {
        
        switch self {
            
        case .emptyStack:
            return "Make sure to check the stack before popping."
            
        case .fullStack:
            return "Ensure the stack has enough space before pushing."
            
        case .undefinedInstructionPointer:
            return "Set a valid instruction pointer before executing instructions."
            
        case .divisionByZero:
            return "Ensure that the divisor in the expression is not zero."
        }
    }
}
