//
//  Scanner.swift
//  
//
//  Created by Michael Borgmann on 21/12/2023.
//

import Foundation

/// The `Scanner` class is responsible for tokenizing the source code into a sequence of tokens.
///
/// It scans the source code character by character, identifying various tokens such as identifiers,
/// numbers, and symbols, and creates corresponding tokens for further processing in the compiler.
///
/// # Usage
/// To use the `Scanner`, create an instance with the source code and call `scanAllTokens()` to obtain
/// an array of tokens.
///
/// ```swift
/// let sourceCode = "local variable x"
/// let scanner = Scanner(source: sourceCode)
///
/// do {
///     let tokens = try scanner.scanAllTokens()
///     // Process tokens as needed
/// } catch let error as ScannerError {
///     // Handle scanning errors
///     print("Scanning error: \(error.localizedDescription)")
/// }
/// ```
/// - SeeAlso:
///   - `ScannerError` for potential errors.
///   - `Token` representing the individual tokens generated by the scanner.
///   - `TokenType` enumerates the possible types of tokens.
class Scanner {
    
    // MARK: Properties
    
    /// The source code to be scanned.
    private let source: String
    
    /// The start index for scanning.
    private var start: String.Index
    
    /// The current index during scanning.
    private var current: String.Index
    
    /// The current line number in the source code.
    private var line: Int = 1
    
    // MARK: Computed Propertes
    
    /// A boolean flag indicating whether the end of the file has been reached.
    private var isEndOfFile: Bool {
        current == source.endIndex
    }
    
    /// The current character being processed during scanning.
    private var character: Character {
        source[current]
    }
    
    /// Advances the scanning position and returns the current character.
    ///
    /// - Returns: The character at the current position.
    private var advance: Character {
        
        defer {
            current = source.index(after: current)
        }
        
        return character
    }
    
    // MARK: Lifecycle
    
    /// Initializes the `Scanner` with the provided source code.
    ///
    /// - Parameter source: The source code to be scanned.
    init(source: String) {
        
        self.source = source
        
        start = source.startIndex
        current = start
    }
    
    // MARK: Actions
    
    /// Scans all tokens in the source code and returns an array of `Token` objects.
    ///
    /// - Returns: An array of `Token` objects representing the tokens in the source code.
    /// - Throws: A `ScannerError` if an error occurs during scanning.
    func scanAllTokens() throws -> [Token] {
        
        var tokens: [Token] = []
        
        while !isEndOfFile {
            tokens.append(try scanToken())
        }
        
        tokens.append(Token(type: .eof, lexeme: "\0", line: line))
        
        return tokens
    }
    
    /// Scans the next token in the source code.
    ///
    /// - Returns: A `Token` object representing the next token.
    /// - Throws: A `ScannerError` if an error occurs during scanning.
    func scanToken() throws -> Token {
        
        skipWhitespace()
        
        guard !isEndOfFile else {
            return Token(type: .eof, lexeme: "", line: line)
        }
        
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
            return createToken(type: .leftParen)
            
        case ")":
            return createToken(type: .rightParen)
            
        case "{":
            return createToken(type: .leftBrace)
            
        case "}":
            return createToken(type: .rightBrace)
            
        case "[":
            return createToken(type: .leftBracket)
            
        case "]":
            return createToken(type: .rightBracket)
            
        case ",":
            return createToken(type: .comma)
            
        case ":":
            return createToken(type: .colon)
            
        case ";":
            return createToken(type: .semicolon)
            
        case "+":
            return createToken(type: .plus)
            
        case "-":
            return createToken(type: .minus)
            
        case "/":
            return createToken(type: .slash)
            
        case "*":
            return createToken(type: .star)
            
        case "#":
            return createToken(type: .hash)
            
        case "\\":
            return createToken(type: .backslash)
            
        case "^":
            return createToken(type: .caret)
            
        case "'":
            return createToken(type: .apostrophe)
            
        case "`":
            return createToken(type: .backtick)
            
        case "@":
            return createToken(type: .at)
            
            // double character lexemes
            
        case "!":
            return createToken(type: match(with: "=") ? .bangEqual : .bang)
            
        case "=":
            return createToken(type: match(with: "=") ? .equalEqual : .equal)
            
        case "<":
            return createToken(type: match(with: "=") ? .lessEqual : .less)
            
        case ">":
            return createToken(type: match(with: "=") ? .greaterEqual : .greater)
            
            // literals
            
        case "\"":
            return try stringLiteral()
            
        default:
            throw ScannerError.unexpectedCharacter(found: character, line: line)
        }
    }
}

// MARK: - Helper

extension Scanner {
    
    /// Creates a new `Token` object based on the provided `TokenType`, optional literal, and the current scanning state.
    ///
    /// - Parameters:
    ///   - type: The type of the token to be created.
    ///   - literal: An optional literal value associated with the token.
    /// - Returns: A `Token` object representing the scanned token.
    private func createToken(type: TokenType, literal: Any? = nil) -> Token {
        
        Token(
            type: type,
            lexeme: String(source[start..<current]),
            literal: literal,
            line: line
        )
    }
    
    /// Checks if the current character matches the specified character and advances the scanning position if there is a match.
    ///
    /// - Parameter character: The character to match.
    /// - Returns: `true` if the characters match; otherwise, `false`.
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
    
    /// Skips whitespace characters and advances the scanning position until a non-whitespace character is encountered.
    private func skipWhitespace() {
        
        while !isEndOfFile {
            
            if character.isNewline {
                
                line += 1
                _ = advance
                
            } else if character.isWhitespace {
                
                _ = advance
            } else {
                
                return
            }
        }
    }
    
    /// Scans a string literal, starting from the current position, and creates a corresponding `Token`.
    ///
    /// - Returns: A `Token` object representing the scanned string literal.
    /// - Throws: A `ScannerError` if the string literal is not terminated.
    private func stringLiteral() throws -> Token {
        
        while !isEndOfFile && character != "\"" {
            
            if character.isNewline {
                line += 1
            }
            
            _ = advance
        }
        
        if isEndOfFile {
            throw ScannerError.unterminatedString(found: String(source[start..<current]), line: line)
        }
        
        _ = advance
        
        let string = source[start..<current]
        return createToken(type: .string, literal: String(string))
    }
    
    /// Scans a number literal, starting from the current position, and creates a corresponding `Token`.
    ///
    /// - Returns: A `Token` object representing the scanned number literal.
    private func numberLiteral() -> Token {
        
        while !isEndOfFile, character.isNumber {
            _ = advance
        }
        
        let integer = Int(source[start..<current])
        return createToken(type: .number, literal: integer)
    }
    
    /// Scans an identifier, starting from the current position, and creates a corresponding `Token`.
    ///
    /// - Returns: A `Token` object representing the scanned identifier.
    private func identifier() -> Token {
        
        while !isEndOfFile, character.isLetter || character.isNumber {
            _ = advance
        }
        
        return createToken(type: identifierType)
    }
    
    /// Determines the type of an identifier based on the starting character and additional checks.
    ///
    /// - Returns: The `TokenType` of the identifier.
    private var identifierType: TokenType {
        
        switch source[start] {
        case "e":
            return checkKeyword(start: 1, length: 3, rest: "lse", type: .else)
        case "f":
            return checkKeyword(start: 1, length: 4, rest: "alse", type: .false)
        case "i":
            
            if current > source.index(start, offsetBy: 1) {
                switch source[source.index(start, offsetBy: 1)] {
                case "f":
                    return checkKeyword(start: 2, length: 0, rest: "", type: .if)
                case "s":
                    return checkKeyword(start: 2, length: 0, rest: "", type: .is)
                case "n":
                    return checkKeyword(start: 2, length: 5, rest: "clude", type: .include)
                default:
                    break
                }
            }
        case "t":
            return checkKeyword(start: 1, length: 3, rest: "rue", type: .true)
            
        default:
            break
        }
        
        return .identifier
    }
    
    /// Checks if a keyword matches the expected substring and updates the scanning position accordingly.
    ///
    /// - Parameters:
    ///   - start: The starting index of the expected substring.
    ///   - length: The length of the expected substring.
    ///   - rest: The expected substring.
    ///   - type: The `TokenType` to return if the keyword matches.
    /// - Returns: The determined `TokenType`.
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
