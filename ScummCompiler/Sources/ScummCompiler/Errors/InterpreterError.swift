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
    
    /// Error indicating division by zero in a binary expression.
    ///
    /// - Parameters:
    ///   - line: The line number in the source code where the error occurred.
    case divisionByZero(line: Int)
    
    /// Error indicating a failure to evaluate an expression.
    ///
    /// This error occurs when an expression cannot be evaluated due to incompatible operands or invalid operations.
    case expressionEvaluationFailed
    
    /// A human-readable description of the error.
    var errorDescription: String? {
        
        switch self {
            
        case .unsupportedOperator:
            return "Unsupported Operator"
            
        case .missingOperand:
            return "Missing Integer Operand"
            
        case .divisionByZero:
            return "Division by Zero"
            
        case .expressionEvaluationFailed:
            return "Expression Evaluation Failed"
        }
    }
    
    /// A localized message describing what caused the failure.
    var failureReason: String? {
        
        switch self {
            
        case .unsupportedOperator(let type, let line):
            return "Unsupported \(type) operator at line \(line)"
            
        case .missingOperand(let type, let line):
            return "\(type.capitalized) expression at line \(line) expects in operand."
            
        case .divisionByZero(let line):
            return "Division by zero at line \(line)"
            
        case .expressionEvaluationFailed:
            return "Failed to evaluate expression operands."
        }
    }

    /// A localized recovery suggestion to resolve the error.
    var recoverySuggestion: String? {
        
        switch self {
            
        case .unsupportedOperator:
            return "Review the expression and ensure that it uses supported operators."
            
        case .missingOperand:
            return "Check the expression for missing operands and correct the syntax."
            
        case .divisionByZero:
            return "Ensure that the divisor in the expression is not zero."
            
        case .expressionEvaluationFailed:
            return "Review the literal expression structure and ensure correct usage of operands and operators."
        }
    }
}
