//
//  Token.swift
//
//
//  Created by Michael Borgmann on 21/12/2023.
//

import Foundation

/// Represents a token generated during lexical analysis in the compiler.
///
/// A token consists of a type, a lexeme (the actual text that matched the token),
/// an optional literal value associated with the token, and the line number in the
/// source code where the token appears.
///
/// - Note: The `literal` property is of type `Any?` to accommodate various types of
///   literals, such as integers and strings. Care should be taken when handling
///   literals to ensure type safety.
///
/// Example Usage:
/// ```swift
/// let token = Token(type: .number, lexeme: "42", literal: 42, line: 10)
/// ```
/// - SeeAlso: `Token`, `Scanner`
struct Token {
    
    /// The type of the token, representing its category.
    let type: TokenType
    
    /// The actual text that matched the token in the source code.
    let lexeme: String
    
    /// An optional literal value associated with the token.
    ///
    /// - Note: The type is `Any?` to allow flexibility in handling different types of literals.
    let literal: Any?
    
    /// The line number in the source code where the token appears.
    let line: Int
    
    /// Initializes a new instance of `Token`.
    ///
    /// - Parameters:
    ///   - type: The type of the token.
    ///   - lexeme: The actual text that matched the token.
    ///   - literal: An optional literal value associated with the token.
    ///   - line: The line number in the source code where the token appears.
    init(type: TokenType, lexeme: String, literal: Any? = nil, line: Int) {
        self.type = type
        self.lexeme = lexeme
        self.literal = literal
        self.line = line
    }
}
