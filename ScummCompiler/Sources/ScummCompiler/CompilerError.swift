//
//  CompilerError.swift
//
//
//  Created by Michael Borgmann on 14/12/2023.
//

import Foundation

enum CompilerError: LocalizedError, Equatable {
    
    case cantFetchInstruction(Int)
    case unknownOpcode(UInt8)
    case emptyCodeChunk
    case outOfBounds(String, Int, Int)          // Type, Index, Total
    case unknownIndex
    case unexpectedCharacter(Character)
    case unterminatedString(String)
    
    var errorDescription: String? {
        
        switch self {
        
        case .cantFetchInstruction:
            return "Can't Fetch Instruction"
            
        case .unknownOpcode:
            return "Unknown Opcode"
            
        case .emptyCodeChunk:
            return "Empty Code Chunk"
            
        case .outOfBounds:
            return "Out of Bounds"
            
        case .unknownIndex:
            return "Unknown Index"
            
        case .unexpectedCharacter:
            return "Unexpected Character"
            
        case .unterminatedString:
            return "Unterminated Character"
        }
        
    }
    
    var failureReason: String? {
        
        switch self {
            
        case .cantFetchInstruction(let offset):
            return "No instruction found at byte `\(offset)`"
            
        case .unknownOpcode(let byte):
            return "No opcode is assigned for the instruction byte `\(byte)`."
            
        case .emptyCodeChunk:
            return "The chunk is empty, but should have byte code."
            
        case .outOfBounds(let type, _, _):
            return "Index out of bound for `\(type)`."
            
        case .unknownIndex:
            return "Unknown index for operation."
            
        case .unexpectedCharacter(let character):
            return "Unexpected character `\(character) in the source code.`"
            
        case .unterminatedString(let string):
            return "The string \(string)\" (<~~) isn't terminated"
        }
    }
    
    var recoverySuggestion: String? {
        
        switch self {
            
        case .cantFetchInstruction:
            return "The data is corrupted, and can be a compilation error. Try to clean the project and compile again."
            
        case .unknownOpcode:
            return "The data is corrupted, and can be a compilation error. Try to clean the project and compile again."
            
        case .emptyCodeChunk:
            return "Try to clean the project and compile again."
        
        case .outOfBounds(_, let index, let total):
            return "Make sure the index @`\(index)` is within the bounds of `\(total)`."
            
        case .unknownIndex:
            return "Try to clean the project and compile again."
            
        case .unexpectedCharacter:
            return "Check your code for correctness and compile again."
            
        case .unterminatedString:
            return "Check the string and make sure it's properly terminated with an `\"`."
        }
    }
}
