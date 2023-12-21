//
//  Scanner.swift
//  scumm
//
//  Created by Michael Borgmann on 17/07/2023.
//

import Foundation

class Scanner {
    
    // MARK: Properties
    
    private let source: String
    private var tokens: [Token] = []
    
    private var start: String.Index
    private var current: String.Index
    private var line = 1
    
    // MARK: Computed Properties
    
    private var isEndOfFile: Bool {
        current >= source.endIndex
    }
    
    private var next: String.Index {
        source.index(after: current)
    }
    
    private var lookahead: String {
        guard !isEndOfFile else {
            return "\0"
        }
        
        return String(source[current])
    }
    
    private var doubleLookahead: String {
        guard source.index(after: next) <= source.endIndex  else {
            return "\0"
        }
        
        return String(source[next])
    }
    
    private var character: String {
        String(source[current])
    }
    
    // MARK: Lifecycle
    
    /// Inititialze token scanner to scan SCUMM script for lexemes.
    /// - Parameters:
    ///   - source: Source code of SCUMM script.
    init(_ source: String) {
        self.source = source
        start = source.startIndex
        current = start
    }
    
    // MARK: Scanner
    
    /// Scan SCUMM script for Tokens
    /// - Returns: Return all ``Token`` found in SCUMM script
    func scanTokens() throws -> [Token] {
        
        while !isEndOfFile {
            
            start = current
            
            do {
                try scanToken()
            } catch let error as InterpreterError {
                ErrorHandler.handle(error)
            } catch {
                print("others")
                throw error
            }
        }
        
        let eof = Token(
            type: .EOF,
            lexeme: "",
            literal: nil,
            line: line
        )
        
        tokens.append(eof)
        
        return tokens
    }
    
    private func scanToken() throws {
        
        let currentCharacter = character
        current = next
        
        switch currentCharacter {
            
        // single character lexemes
            
        case "(":
            addToken(type: .LEFT_PAREN)
        case ")":
            addToken(type: .RIGHT_PAREN)
        case "{":
            addToken(type: .LEFT_BRACE)
        case "}":
            addToken(type: .RIGHT_BRACE)
        case ",":
            addToken(type: .COMMA)
        case ".":
            addToken(type: .DOT)
        case "-":
            addToken(type: .MINUS)
        case "+":
            addToken(type: .PLUS)
        case ";":
            addToken(type: .SEMICOLON)
        case "*":
            addToken(type: .STAR)
            
            // double character lexemes
            
        case "!":
            addToken(type: match(with: "=") ? .BANG_EQUAL : .BANG)
        case "=":
            addToken(type: match(with: "=") ? .EQUAL_EQUAL : .EQUAL)
        case "<":
            addToken(type: match(with: "=") ? .LESS_EQUAL : .LESS)
        case ">":
            addToken(type: match(with: "=") ? .GREATER_EQUAL : .GREATER)
            
            // double character lexeme comment
            
        case "/":
            
            if match(with: "/") {
                while lookahead != "\n" && !isEndOfFile {
                    current = next
                }
            } else {
                addToken(type: .SLASH)
            }
            
            // whitespaces
            
        case " ", "\r", "\t":
            break
            
        case "\n":
            line += 1
            
            // literals
            
        case "\"":
            
            do {
                try stringLiteral()
            } catch {
                throw error
            }
            
        case "0"..."9":
            numberLiteral()
        
        case "a"..."z", "A"..."Z":
            alphanumericLiteral()
        
            
        default:
            throw InterpreterError.unexpectedCharacter(atLine: line, character: currentCharacter)
        }
        
    }
    
    // MARK: Helper
    
    private func addToken(type: TokenType) {
        addToken(type: type, literal: nil)
    }
    
    private func addToken(type: TokenType, literal: Any?) {
        
        let range = start..<current
        
        let token = Token(
            type: type,
            lexeme: String(source[range]),
            literal: literal,
            line: line
        )
        
        tokens.append(token)
    }
    
    // MARK: Matchers
    
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
    
    private func stringLiteral() throws {
        
        while lookahead != "\"" && !isEndOfFile {
            if lookahead == "\n" {
                line += 1
            }
            current = next
        }
        
        if isEndOfFile {
            throw InterpreterError.unterminatedString(atLine: line)
        }
        
        current = next
        
        let range = start..<current
        addToken(type: .STRING, literal: source[range])
    }
    
    private func numberLiteral() {
        
        while let _ = Int(lookahead) {
            current = next
        }
        
        if lookahead == ".", let _ = Int(doubleLookahead) {
            current = next
            
            while let _ = Int(lookahead) {
                current = next
            }
        }
        
        let range = start..<current
        addToken(type: .NUMBER, literal: Double(source[range]))
    }
    
    // MARK: Keywords & Identifiers
    
    private func alphanumericLiteral() {
        
        while
            let character = lookahead.unicodeScalars.first,
            CharacterSet.alphanumerics.contains(character)
        {
            current = next
        }
        
        let lexeme = source[start..<current]
        
        let type = TokenType.allCases.first {
            $0.rawValue.lowercased() == lexeme
        } ?? .IDENTIFIER
        
        addToken(type: type)
    }
}
