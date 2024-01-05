//
//  ParserError.swift
//
//
//  Created by Michael Borgmann on 05/01/2024.
//

import Foundation

/// Enum representing errors that can occur during parsing.
enum ParserError: LocalizedError, Equatable {
    
    /// Indicates that an expression is expected at a specific line in the source code.
    ///
    /// - Parameters:
    ///   - line: The line number where the expression is expected.
    case expressionExpected(line: Int)
    
    /// Indicates the presence of an unexpected token during parsing.
    ///
    /// - Parameters:
    ///   - message: Additional details or message associated with the unexpected token.
    case unexpectedToken(message: String)
    
    /// A human-readable description of the error.
    var errorDescription: String? {
        
        switch self {
            
        case .expressionExpected:
            return "Expression Expected"
            
        case .unexpectedToken:
            return "Unexpected Token"
        }
    }
    
    /// A localized message describing what caused the failure.
    var failureReason: String? {
        
        switch self {
            
        case .expressionExpected(let line):
            return "An expression is expected at line \(line)."
            
        case .unexpectedToken(let message):
            return message
        }
    }
    
    /// A localized recovery suggestion to resolve the error.
    var recoverySuggestion: String? {
        
        switch self {
            
        case .expressionExpected:
            return "Ensure that the token at the specified line can initiate an expression. Check for correct syntax or consider adding a valid expression at this position."
            
        case .unexpectedToken:
            return "Review the source code for any unexpected tokens or syntax errors. Make sure the input adheres to the language grammar rules."
        }
    }
}
