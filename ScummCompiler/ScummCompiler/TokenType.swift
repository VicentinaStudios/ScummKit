//
//  TokenType.swift
//  ScummCompiler
//
//  Created by Michael Borgmann on 27/11/2023.
//

import Foundation

enum TokenType: String, CaseIterable {
    
    // Single-characeter tokens
    case LEFT_PAREN, RIGHT_PAREN, LEFT_BRACE, RIGHT_BRACE
    case COMMA, DOT, MINUS, PLUS, SEMICOLON, SLASH, STAR
    
    // One or two character tokens
    
    case BANG, BANG_EQUAL
    case EQUAL, EQUAL_EQUAL
    case GREATER, GREATER_EQUAL
    case LESS, LESS_EQUAL
    
    // Literals
    case IDENTIFIER, STRING, NUMBER
    
    // Keywords
    
    case LOCAL, VARIABLE, INCLUDE
    case AND, CLASS, ELSE, FALSE, FUNC, FOR, IF, NIL, OR
    case PRINT, RETURN, SUPER, THIS, TRUE, VAR, WHILE
    case EOF, ERROR
    
    // MARK: - Keywords
    
    var keyword: String? {
        switch self {
        case .LOCAL, .VARIABLE, .INCLUDE, .AND, .CLASS, .ELSE,
             .FALSE, .FUNC, .FOR, .IF, .NIL, .OR, .PRINT,
             .RETURN, .SUPER, .THIS, .TRUE, .VAR, .WHILE:
            
            return self.rawValue.lowercased()
            
        default:
            return nil
        }
    }
}
