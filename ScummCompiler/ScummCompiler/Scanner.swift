//
//  Scanner.swift
//  ScummCompiler
//
//  Created by Michael Borgmann on 27/11/2023.
//

import Foundation

struct Scanner {
    
    var start: String.Index
    var current: String.Index
    var line: Int = 1
    
    let source: String
    
    init(source: String) {
        start = source.startIndex
        current = source.startIndex
        
        self.source = source
    }
    
    mutating func scanToken()  -> Token {
        
        skipWhitespace()
        
        start = current
        
        if isAtEnd {
            return makeToken(type: .EOF)
        }
        
        let c = advance()
        
        if isAlpha(c) {
            return identifier()
        }
        
        if isDigit(c) {
            return number()
        }
        
        switch c {
        case "(":
            return makeToken(type: .LEFT_PAREN)
        case ")":
            return makeToken(type: .RIGHT_PAREN)
        case "{":
            return makeToken(type: .LEFT_BRACE)
        case "}":
            return makeToken(type: .RIGHT_BRACE)
        case ",":
            return makeToken(type: .COMMA)
        case ".":
            return makeToken(type: .DOT)
        case "-":
            return makeToken(type: .MINUS)
        case "+":
            return makeToken(type: .PLUS)
        case ";":
            return makeToken(type: .SEMICOLON)
        case "*":
            return makeToken(type: .STAR)
            
        case "!":
            return makeToken(type: match(with: "=") ? .BANG_EQUAL : .BANG)
        case "=":
            return makeToken(type: match(with: "=") ? .EQUAL_EQUAL : .EQUAL)
        case "<":
            return makeToken(type: match(with: "=") ? .LESS_EQUAL : .LESS)
        case ">":
            return makeToken(type: match(with: "=") ? .GREATER_EQUAL : .GREATER)
            
        case "\"":
            return string()
            
        default:
            fatalError("Unknown token")
        }
        
        return errorToken(message: "Unexpected character")
    }
    
    var isAtEnd: Bool {
        current >= source.endIndex
    }
    
    private mutating func match(with character: Character) -> Bool {
        guard
            !isAtEnd,
            source[current] == character
        else {
            return false
        }
        
        current = source.index(after: current)
        
        return true
    }
    
    func makeToken(type: TokenType) -> Token {
        Token(
            type: type,
            start: start,
            lenght: source.distance(from: start, to: current),
            line: line
        )
    }
    
    func errorToken(message: String) -> Token {
        Token(
            type: .ERROR,
            start: start,
            lenght: source.distance(from: start, to: current),
            line: line
        )
    }
    
    mutating func advance() -> String {
        let result = String(source[current])
        current = source.index(after: current)
        return result
    }
    
    mutating func skipWhitespace() {
        
        let c = peek()
        
        switch c {
        case " ", "\r", "\t":
            advance()
        case "\n":
            line += 1
            advance()
        case "/":
            
            if peekNext() == "/" {
                while peek() != "\n" && isAtEnd {
                    advance()
                }
            } else {
                return
            }
            
        default:
            return
        }
    }
    
    func peek() -> Character {
        source[current]
    }
    
    func peekNext() -> Character {
        
        if isAtEnd {
            return "\0"
        }
        
        let lookahead = source.index(after: current)
        return source[lookahead]
    }
    
    mutating func string() -> Token {
        
        while peek() != "\"" && isAtEnd {
            
            if peek() == "\n" {
                line += 1
            }
            
            advance()
        }
        
        if isAtEnd {
            return errorToken(message: "Unterminated string.")
        }
        
        advance()
        
        return makeToken(type: .STRING)
    }
    
    func isDigit(_ c: String) -> Bool {
        c >= "0" && c <= "9"
    }
    
    mutating func number() -> Token {
        
        while isDigit(String(peek())) {
            advance()
        }
        
        if peek() == "." && isDigit(String(peekNext())) {
            advance()
            while isDigit(String(peek())) {
                advance()
            }
        }
        
        return makeToken(type: .NUMBER)
    }
    
    func isAlpha(_ c: String) -> Bool {
        
        c >= "a" && c <= "z" ||
        c >= "A" && c <= "Z" ||
        c == "_"
    }
    
    mutating func identifier() -> Token {
        
        while isAlpha(String(peek())) || isDigit(String(peek())) {
            advance()
        }
        
        return makeToken(type: identifierType())
    }
    
    func identifierType() -> TokenType {
        
        switch source[start] {
        case "a":
            return checkKeyword(start: 1, lenght: 2, rest: "nd", type: .AND)
        default:
            return .IDENTIFIER
        }
    }
    
    func checkKeyword(start: Int, lenght: Int, rest: String, type: TokenType) -> TokenType {

        let distance = source.distance(from: self.start, to: current)
        let total = start + lenght
            
        let offset = source.index(self.start, offsetBy: start)
        let end = source.index(self.start, offsetBy: start + lenght)
        let range = offset..<end
            
        let substring = String(source[range])
        
        if distance == total && substring == rest {
            return type
        }
        
        return .IDENTIFIER
    }
}
