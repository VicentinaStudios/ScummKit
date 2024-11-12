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
    case invalidOperands
    
    case missingOperands
    
    /// A human-readable description of the error.
    var errorDescription: String? {
        
        switch self {
        case .cantFetchInstruction:
            return "Can't Fetch Instruction"
        case .missingOperands:
            return "Missing Operands"
        case .invalidOperands:
            return "Invalid Operands"
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
        }
    }
}
