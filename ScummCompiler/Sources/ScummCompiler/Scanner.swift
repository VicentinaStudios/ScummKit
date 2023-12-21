//
//  File.swift
//  
//
//  Created by Michael Borgmann on 21/12/2023.
//

import Foundation

/// The `Scanner` class is responsible for lexical analysis of the source code,
/// breaking it down into individual tokens.
class Scanner {
    
    /// The source code string that the scanner analyzes.
    private let source: String
    
    /// The starting index for scanning.
    private var start: String.Index
    
    /// The current index indicating the current position during scanning.
    private var current: String.Index
    
    /// The current line number being processed.
    private var line: Int
    
    /// A boolean flag indicating whether the end of the source code has been reached.
    private var isEndOfFile: Bool {
        current == source.endIndex
    }
    
    /// Returns the current character being processed.
    private var character: Character {
        source[current]
    }
    
    /// Advances the scanning position to the next character and returns the current character.
    private var advance: Character {
        
        defer {
            current = source.index(after: current)
        }
        
        return character
    }
    
    /// Initializes the scanner with the provided source code.
    ///
    /// - Parameter source: The source code string to be scanned.
    init(source: String) {
        
        self.source = source
        
        start = source.startIndex
        current = start
        line = 1
    }
    
    /// Scans the source code for the next token.
    ///
    /// - Returns: A `Token` representing the scanned token.
    /// - Throws: A `CompilerError` in case of unexpected characters or errors during scanning.
    func scanToken() throws -> Token {
        
        guard !isEndOfFile else {
            return Token(type: .eof, lexeme: "", line: line)
        }
        
        skipWhitespace()
        
        start = current
        
        let character = advance
        
        if character.isLetter {
            return identifier()
        }
        
        if character.isNumber {
            return numberLiteral()
        }
        
        switch character {
            
        // single character lexemes
            
        case "(":
            return createToken(token: .lparen)
            
        case ")":
            return createToken(token: .rparen)
            
        case "{":
            return createToken(token: .lbrace)
            
        case "}":
            return createToken(token: .rbrace)
            
        case "[":
            return createToken(token: .lbracket)
            
        case "]":
            return createToken(token: .rbracket)
            
        case ",":
            return createToken(token: .comma)
            
        case ":":
            return createToken(token: .colon)
            
        case ";":
            return createToken(token: .semicolon)
            
        case "+":
            return createToken(token: .plus)
            
        case "-":
            return createToken(token: .minus)
            
        case "/":
            return createToken(token: .slash)
            
        case "*":
            return createToken(token: .star)
            
        case "#":
            return createToken(token: .hash)
            
        case "\\":
            return createToken(token: .backslash)
            
        case "^":
            return createToken(token: .caret)
            
        case "'":
            return createToken(token: .apostrophe)
            
        case "`":
            return createToken(token: .backtick)
            
        case "@":
            return createToken(token: .at)
            
        // double character lexemes
            
        case "!":
            return createToken(token: match(with: "=") ? .bangEqual : .bang)
            
        case "=":
            return createToken(token: match(with: "=") ? .equalEqual : .equal)
            
        case "<":
            return createToken(token: match(with: "=") ? .lessEqual : .less)
            
        case ">":
            return createToken(token: match(with: "=") ? .greaterEqual : .greater)
            
        // literals
            
        case "\"":
            return try! stringLiteral()
            
        default:
            throw CompilerError.unexpectedCharacter(character)
        }
    }
    
    /// Creates a `Token` with the specified type, lexeme, literal, and line information.
    ///
    /// - Parameters:
    ///   - token: The type of the token.
    ///   - literal: The literal value associated with the token (optional).
    /// - Returns: A `Token` object.
    private func createToken(token: TokenType, literal: Any? = nil) -> Token {
        
        Token(
            type: token,
            lexeme: String(source[start..<current]),
            literal: literal,
            line: line
        )
    }
    
    /// Attempts to match the current character with the provided character.
    ///
    /// - Parameter character: The character to match.
    /// - Returns: `true` if there is a match; otherwise, `false`.
    private func match(with character: Character) -> Bool {
        
            guard
                !isEndOfFile,
                source[current] == character
            else {
                return false
            }
            
            current = source.index(after: current)
            
            return true
        }
    
    /// Skips whitespace characters, including space, tab, and carriage return, and updates the line number for newline characters.
    private func skipWhitespace() {
        
        while true {
            
            switch String(character) {
                
            case " ", "\r", "\t":
                _ = advance
                
            case "\n":
                line += 1
                _ = advance
                
            default:
                return
            }
        }
    }
    
    /// Scans the source code for a string literal enclosed in double quotes.
    ///
    /// - Returns: A `Token` representing the scanned string literal.
    /// - Throws: A `CompilerError` if an unterminated string is encountered.
    private func stringLiteral() throws -> Token {
        
        while character != "\"" && !isEndOfFile {
            
            if character.isNewline {
                line += 1
            }
            
            _ = advance
        }
        
        if isEndOfFile {
            throw CompilerError.unterminatedString(String(source[start..<current]))
        }
        
        _ = advance
        
        let string = source[start..<current]
        return createToken(token: .string, literal: String(string))
    }
    
    /// Scans the source code for a numeric literal.
    ///
    /// - Returns: A `Token` representing the scanned numeric literal.
    private func numberLiteral() -> Token {
        
        while !isEndOfFile, character.isNumber {
            _ = advance
        }
        
        let integer = Int(source[start..<current])
        return createToken(token: .number, literal: integer)
    }
    
    /// Scans the source code for an identifier, which may consist of letters and numbers.
    ///
    /// - Returns: A `Token` representing the scanned identifier.
    private func identifier() -> Token {
        
        while !isEndOfFile, character.isLetter || character.isNumber {
            _ = advance
        }
        
        return createToken(token: identifierType)
    }
    
    /// Determines the type of identifier or keyword based on the current state.
    ///
    /// - Returns: The `TokenType` of the identifier or keyword.
    private var identifierType: TokenType {
        
        switch source[start] {
        case "e":
            return checkKeyword(start: 1, length: 3, rest: "lse", type: .else)
        case "i":
            
            if current > source.index(start, offsetBy: 1) {
                switch source[source.index(start, offsetBy: 1)] {
                case "f":
                    return checkKeyword(start: 2, length: 0, rest: "", type: .if)
                case "n":
                    return checkKeyword(start: 2, length: 5, rest: "clude", type: .include)
                default:
                    break
                }
            }
            
        default:
            break
        }
        
        return .identifier
    }
    
    /// Checks if the current identifier matches a keyword and returns the corresponding `TokenType`.
    ///
    /// - Parameters:
    ///   - start: The offset from the current position to start checking.
    ///   - length: The length of the keyword to check.
    ///   - rest: The remaining part of the keyword to check.
    ///   - type: The `TokenType` to return if the keyword matches.
    /// - Returns: The `TokenType` of the keyword or `.identifier` if no match is found.
    private func checkKeyword(start: Int, length: Int, rest: String, type: TokenType) -> TokenType {
        
        let startIndex = source.index(self.start, offsetBy: start)
        let endIndex = source.index(startIndex, offsetBy: length)
        
        guard
            endIndex == current,
            source[startIndex..<endIndex] == rest
        else {
            return .identifier
        }
        
        return type
    }
}
