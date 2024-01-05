//
//  InterpreterError.swift
//  
//
//  Created by Michael Borgmann on 05/01/2024.
//

import Foundation

/// Enum representing errors that may occur during interpretation in the `Interpreter` class.
enum InterpreterError: LocalizedError, Equatable {
    
    /// Error indicating an attempt to use an unsupported operator in an expression.
    ///
    /// - Parameters:
    ///   - type: The type of operation (e.g., "unary", "binary").
    ///   - line: The line number in the source code where the error occurred.
    case unsupportedOperator(type: String, line: Int)
    
    /// Error indicating a missing operand in an expression.
    ///
    /// - Parameters:
    ///   - type: The type of expression (e.g., "unary", "binary").
    ///   - line: The line number in the source code where the error occurred.
    case missingOperand(type: String, line: Int)
    
    /// A human-readable description of the error.
    var errorDescription: String? {
        
        switch self {
        case .unsupportedOperator:
            return "Unsupported Operator"
        case .missingOperand:
            return "Missing Integer Operand"
        }
    }
    
    /// A localized message describing what caused the failure.
    var failureReason: String? {
        
        switch self {
        case .unsupportedOperator(let type, let line):
            return "Unsupported \(type) operator at line \(line)"
        case .missingOperand(let type, let line):
            return "\(type.capitalized) expression at line \(line) expects in operand."
        }
    }

    /// A localized recovery suggestion to resolve the error.
    var recoverySuggestion: String? {
        
        switch self {
        case .unsupportedOperator:
            return "Review the expression and ensure that it uses supported operators."
        case .missingOperand:
            return "Check the expression for missing operands and correct the syntax."
        }
    }
}
