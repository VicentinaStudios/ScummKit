//
//  ScannerError.swift
//  
//
//  Created by Michael Borgmann on 05/01/2024.
//

import Foundation

/// Enum representing errors that may occur during the scanning process in the `Scanner` class.
enum ScannerError: LocalizedError, Equatable {
    
    /// Error indicating an unexpected character was found in the source code.
    ///
    /// - Parameters:
    ///   - found: The unexpected character.
    ///   - line: The line number where the character was found.
    case unexpectedCharacter(found: Character, line: Int)
    
    /// Error indicating an unterminated string was found in the source code.
    ///
    /// - Parameters:
    ///   - found: The unterminated string.
    ///   - line: The line number where the string was found.
    case unterminatedString(found: String, line: Int)
    
    /// A human-readable description of the error.
    var errorDescription: String? {
        
        switch self {
            
        case .unexpectedCharacter:
            return "Unexpected Character"
            
        case .unterminatedString:
            return "Unterminated Character"
        }
    }
    
    /// A localized message describing what caused the failure.
    var failureReason: String? {
        
        switch self {
            
        case .unexpectedCharacter(let found, let line):
            return "Unexpected character '\(found)' at line \(line)."

        case .unterminatedString(let found, let line):
            return "The string '\(found)' at line \(line) isn't terminated."
        }
    }
    
    /// A localized recovery suggestion to resolve the error.
    var recoverySuggestion: String? {
        
        switch self {
            
        case .unexpectedCharacter:
            return "Check your code for correctness. An unexpected character may indicate a syntax error."

        case .unterminatedString:
            return "Check the string and make sure it's properly terminated with an '\"."
        }
    }
}
