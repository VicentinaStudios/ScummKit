//
//  Token.swift
//  scumm
//
//  Created by Michael Borgmann on 17/07/2023.
//

import Foundation

/// Token structure for lexemes
struct Token {
    
    /// Specifies the ``TokenType``
    let type: TokenType
    
    /// Sequence of characters found in the source code  that was matched by a language rule.
    let lexeme: String
    
    /// Fixed value representation of found lexeme
    let literal: Any?
    
    /// Line of code the lexem was found
    let line: Int
    
    // String representation of the token
    var description: String {
        "\(type.rawValue) \(lexeme) \(String(describing: literal))"
    }
}
