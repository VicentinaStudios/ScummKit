//
//  CompilerError.swift
//
//
//  Created by Michael Borgmann on 14/12/2023.
//

import Foundation

// MARK: - Compiler Error

enum CompilerError: LocalizedError, Equatable {
    
    case cantFetchInstruction(Int)
    case unknownOpcode(UInt8)
    case emptyCodeChunk
    case unknownIndex

    case compileError
    
    // MARK: Error Descriptions
    
    var errorDescription: String? {
        
        switch self {
        
        case .cantFetchInstruction:
            return "Can't Fetch Instruction"
            
        case .unknownOpcode:
            return "Unknown Opcode"
            
        case .emptyCodeChunk:
            return "Empty Code Chunk"
        
        case .unknownIndex:
            return "Unknown Index"
            
        case .compileError:
            return "Compile Error"
        }
        
    }
    
    // MARK: Failure Reason
    
    var failureReason: String? {
        
        switch self {
            
        case .cantFetchInstruction(let offset):
            return "No instruction found at byte `\(offset)`."
            
        case .unknownOpcode(let byte):
            return "No opcode is assigned for the instruction byte `\(byte)`."
            
        case .emptyCodeChunk:
            return "The chunk is empty, but should have byte code."
            
        case .unknownIndex:
            return "Unknown index for operation."
            
        case .compileError:
            return "Failed to compile the source code."
        }
    }
    
    // MARK: Recovery Suggestions
    
    var recoverySuggestion: String? {
        
        switch self {
            
        case .cantFetchInstruction:
            return "The data is corrupted, and can be a compilation error. Try to clean the project and compile again."
            
        case .unknownOpcode:
            return "The data is corrupted, and can be a compilation error. Try to clean the project and compile again."
            
        case .emptyCodeChunk:
            return "Try to clean the project and compile again."
            
        case .unknownIndex:
            return "Try to clean the project and compile again."
            
        case .compileError:
            return "Check the source code is using the correct syntax."
        }
    }
}

// MARK: - Runtime Error

enum RuntimeError: LocalizedError, Equatable {
    
}
