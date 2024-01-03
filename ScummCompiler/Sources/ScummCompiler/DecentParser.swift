//
//  DecentParser.swift
//
//
//  Created by Michael Borgmann on 03/01/2024.
//

import Foundation

class DecentParser {
    
    // MARK: Properties
    
    private let tokens: [Token]
    private var current: Array.Index
    
    // MARK: Computed Properties
    
    private var peek: Token {
        tokens[current]
    }
    
    private var previous: Token {
        tokens[tokens.index(before: current)]
    }
    
    private var isEndOfFile: Bool {
        peek.type == .eof
    }
    
    // MARK: Lifecycle
    
    init(tokens: [Token]) {
        
        self.tokens = tokens
        self.current = tokens.startIndex
    }
    
    // MARK: Actions
    
    func parse() throws -> Expression {
        try expression()
    }
}

// MARK: - Parser

extension DecentParser {
    
    private func advance() -> Token {
        
        if !isEndOfFile {
            current = tokens.index(after: current)
        }
        
        return previous
    }
    
    private func expression() throws -> Expression {
        try equality()
    }
    
    private func consume(type: TokenType, message: String) throws {
        
        guard tokens[current].type == type else {
            throw CompilerError.compileError    // message
        }
        
        advance()
    }
}

// MARK: - Expressions

extension DecentParser {
    
    private func equality() throws -> Expression {
        
        var expression = try comparison()
        
        while match(types: .bangEqual, .equalEqual) {
            
            let operatorToken = previous
            let right = try comparison()
            
            expression = Binary(
                left: expression,
                operatorToken: operatorToken,
                right: right
            )
        }
        
        return expression
    }
    
    private func comparison() throws -> Expression {
        
        var expression = try term()
        
        while match(types: .greater, .greaterEqual, .less, .lessEqual) {
            
            let operatorToken = previous
            let right = try term()
            
            expression = Binary(
                left: expression,
                operatorToken: operatorToken,
                right: right
            )
        }
            
        return expression
    }
    
    private func term() throws -> Expression {
        
        var expression = try factor()
        
        while match(types: .minus, .plus) {
            
            let operatorToken = previous
            let right = try factor()
            
            expression = Binary(
                left: expression,
                operatorToken: operatorToken,
                right: right
            )
        }
        
        return expression
    }
    
    private func factor() throws -> Expression {
        
        var expression = try unary()
        
        while match(types: .slash, .star) {
            
            let operatorToken = previous
            let right = try unary()
            
            expression = Binary(
                left: expression,
                operatorToken: operatorToken,
                right: right
            )
        }
        
        return expression
    }
    
    private func unary() throws -> Expression {
        
        if match(types: .bang, .minus) {
            
            let operatorToken = previous
            let right = try unary()
            
            return Unary(
                operatorToken: operatorToken,
                right: right
            )
        }
        
        return try primary()
    }
    
    private func primary() throws -> Expression {
        
        if match(types: .number) {
            return Literal(value: previous.literal)
        }
        
        if match(types: .lparen) {
            
            let expression = try expression()
            _ = try consume(type: .rparen, message: "Expect ')' after expression.")
            
            return Grouping(expression: expression)
        }
        
        //throw ParserError.expressionExpected(atLine: peek.line)
        throw CompilerError.compileError
    }
}

// MARK: - Helper

extension DecentParser {
    
    private func match(types: TokenType...) -> Bool {
        for type in types {
            if check(type: type) {
                current = tokens.index(after: current)
                return true
            }
        }
        
        return false
    }
    
    private func check(type: TokenType) -> Bool {
        isEndOfFile ? false : peek.type == type
    }
}

// MARK: - Error Handling

extension DecentParser {
    
    private func synchronize() {
        
        current = tokens.index(after: current)
        
        while !isEndOfFile {
            
            /*
            if previous.type == .SEMICOLON {
                return
            }
            
            switch peek.type {
            case .CLASS, .FUNC, .VAR, .FOR, .IF, . WHILE, .PRINT, .RETURN:
                return
            default:
                break
            }
            */
        }
        
        current = tokens.index(after: current)
    }
}
