//
//  TokenType.swift
//  
//
//  Created by Michael Borgmann on 14/12/2023.
//

import Foundation

/// The `TokenType` enum represents the possible types of tokens that can be identified
/// by the lexer. Each case in this enum corresponds to a specific category of tokens,
/// such as parentheses, operators, literals, keywords, and special tokens.
///
/// When creating a `Token` instance, the `type` property is set to one of the cases
/// defined in this enum. The additional properties like `lexeme`, `literal`, and `line`
/// provide more detailed information about the token, making it a comprehensive
/// representation of lexical elements in the source code.
///
/// Example Usage:
/// ```swift
/// let token = Token(type: .leftParen, lexeme: "(", line: 42)
/// ```
///
/// - SeeAlso: `Token`, `Scanner`
enum TokenType: String, CaseIterable {
    
    // MARK: Parentheses
    
    /// Represents the left parenthesis "(".
    case leftParen
    
    /// Represents the right parenthesis ")".
    case rightParen
    
    /// Represents the left brace "{".
    case leftBrace
    
    /// Represents the right brace "}".
    case rightBrace
    
    /// Represents the left square bracket "[".
    case leftBracket
    
    /// Represents the right square bracket "]".
    case rightBracket

    // MARK: Punctuation
    
    /// Represents the comma ",".
    case comma
    
    /// Represents the colon ":".
    case colon
    
    /// Represents the semicolon ";".
    case semicolon
    
    /// Represents the exclamation mark "!".
    case bang
    
    // MARK: Operators

    /// Represents the plus operator "+".
    case plus
    
    /// Represents the minus operator "-".
    case minus
    
    /// Represents the slash operator "/".
    case slash
    
    /// Represents the star operator "*".
    case star
    
    /// Represents the equal sign "=".
    case equal
    
    /// Represents the equality operator "==".
    case equalEqual
    
    /// Represents the not equal operator "!=".
    case bangEqual
    
    /// Represents the less-than operator "<".
    case less
    
    /// Represents the less-than or equal operator "<=".
    case lessEqual
    
    /// Represents the greater-than operator ">".
    case greater
    
    /// Represents the greater-than or equal operator ">=".
    case greaterEqual
    
    /// Represents the plus-equal operator "+=".
    case plusEqual
    
    /// Represents the minus-equal operator "-=".
    case minusEqual
    
    /// Represents the increment operator "++".
    case plusPlus
    
    /// Represents the decrement operator "--".
    case minusMinus
    
    // MARK: Special Characters
    
    /// Represents the hash character "#".
    case hash
    
    /// Represents the backslash character "\".
    case backslash
    
    /// Represents the caret character "^".
    case caret
    
    /// Represents the apostrophe character "'".
    case apostrophe
    
    /// Represents the backtick character "`".
    case backtick
    
    /// Represents the at character "@".
    case at
    
    // MARK: Literals
    
    /// Represents an identifier.
    case identifier
    
    /// Represents a string literal.
    case string
    
    /// Represents a numeric literal.
    case number

    // MARK: Keywords

    /// Represents the keyword "include".
    case include
    
    /// Represents the keyword "if".
    case `if`
    
    /// Represents the keyword "else".
    case `else`
    
    /// Represents the keyword "is".
    case `is`
    
    /// Represents the keyword "true".
    case `true`
    
    /// Represents the keyword "false".
    case `false`
    
    // MARK: Special Tokens
    
    /// Represents a label used in the code.
    case label
    
    /// Represents the end of the input source code.
    case eof
}
