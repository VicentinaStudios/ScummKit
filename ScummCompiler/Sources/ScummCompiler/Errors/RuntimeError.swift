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
    
    /// A human-readable description of the error.
    var errorDescription: String? {
        
        switch self {
        case .cantFetchInstruction:
            return "Can't Fetch Instruction"
        }
    }
    
    /// A localized message describing what caused the failure.
    var failureReason: String? {
        
        switch self {
        case .cantFetchInstruction(let offset):
            return "No instruction found at byte `\(offset)`."
        }
    }
    
    /// A localized recovery suggestion to resolve the error.
    var recoverySuggestion: String? {
        
        switch self {
        case .cantFetchInstruction:
            return "The data is corrupted, and can be a compilation error. Try to clean the project and compile again."
        }
    }
}
