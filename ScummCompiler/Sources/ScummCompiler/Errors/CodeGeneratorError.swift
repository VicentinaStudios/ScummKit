//
//  CodeGeneratorError.swift
//
//
//  Created by Michael Borgmann on 15/01/2024.
//

import Foundation

/// An enumeration representing errors that can occur during code generation.
enum CodeGeneratorError: LocalizedError, Equatable {
    
    /// An error indicating that the line number is unknown for the equivalent bytecode sequence.
    /// - Parameters:
    ///   - bytes: The bytecode sequence with an unknown line number.
    case unknownLine(bytes: [UInt8])
    
    /// An error indicating that a valid integer value could not be extracted from the given literal expression.
    case unknownLiteral
    
    /// An error indicating that the evaluation of expression operands has failed.
    case expressionEvaluationFailed
    
    /// An error indicating that the maximum limit of constants in one chunk has been exceeded.
    case tooManyConstants
    
    case invalidOperandType
    
    /// A human-readable description of the error.
    var errorDescription: String? {
        
        switch self {
            
        case .unknownLine:
            return "Unknown Line"
            
        case .unknownLiteral:
            return "Unknown Literal"
            
        case .expressionEvaluationFailed:
            return "Expression Evaluation Failed"
            
        case .tooManyConstants:
            return "Too Many Constants"
            
        case .invalidOperandType:
            return "Invalid Operant Type"
        }
    }
    
    /// A localized message describing what caused the failure.
    var failureReason: String? {
        
        switch self {
            
        case .unknownLine(let bytes):
            return "Unknown line number in source code for the equivalent bytecode sequence: '\(bytes.map { "\($0)" }.joined(separator: ", "))'."
            
        case .unknownLiteral:
            return "Unable to extract a valid integer value from the given literal expression."
            
        case .expressionEvaluationFailed:
            return "Failed to evaluate expression operands."
            
        case .tooManyConstants:
            return "Exceeded the maximum limit of constants in one chunk."
            
        case .invalidOperandType:
            return "The operand type is invalid for the operation. Expected a numeric value (Int or Double) for unary minus operations, or a boolean value for the logical NOT operation."
        }
    }
    
    /// A localized recovery suggestion to resolve the error.
    var recoverySuggestion: String? {
        
        switch self {
            
        case .unknownLine:
            return "Compiler configuration or line number assignment during compilation may be causing this issue. Please review the compiler settings and ensure correct line number assignment for each token during the compilation process."
            
        case .unknownLiteral:
            return "Ensure that the literal expression contains a valid integer value."
   
        case .expressionEvaluationFailed:
            return "Review the literal expression structure and ensure correct usage of operands and operators."

        case .tooManyConstants:
            return "Reduce the number of constants in the code or split them into multiple chunks."
            
        case .invalidOperandType:
            return "Ensure that the operands used in the expression match the expected types (e.g., use numeric types for operations like unary minus, and boolean for logical NOT)."
        }
    }
}
