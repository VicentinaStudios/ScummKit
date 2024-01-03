//
//  PrattParser.swift
//
//
//  Created by Michael Borgmann on 22/12/2023.
//

import Foundation

public class PrattParser {
    
    private let tokens: [Token]
    private var current: Array.Index
    private var previous: Array.Index
    
    init(tokens: [Token]) {
        
        self.tokens = tokens
        self.current = tokens.startIndex
        self.previous = tokens.startIndex
    }
    
    func parse() {
        expression()
    }
    
    private func advance() {
        
        previous = current
        current = tokens.index(after: current)
    }
    
    private func consume(type: TokenType, message: String) throws {
        
        guard tokens[current].type == type else {
            throw CompilerError.compileError    // message
        }
        
        advance()
    }
    
    private func expression() {
        precedence(.assignement)
    }
}

// MARK: Parser Rules

extension PrattParser {
    
    func number() {
        let value = tokens[previous]
        print(value.literal as? Int)
    }
    
    func grouping() {
        expression()
        try? consume(type: TokenType.rparen, message: "Expect ')' after expression.")
        print("grouping")
    }
    
    func unary() {
        
        let operatorType = tokens[previous].type
        expression()
        
//        precedence(.unary)
        
        switch operatorType {
        case .minus:
            print("negate")
        default:
            break
        }
    }
    
    func binary() {
        
        let operatorType = tokens[previous].type
        let token = tokens[previous].type
        
        if let rule = rules[token.rawValue],
           let next = Precedence(rawValue: rule.precedence.rawValue + 1)
        {
            precedence(next)
        }
        
        switch operatorType {
        case .plus:
            print("add")
        case .minus:
            print("minus")
        case .star:
            print("multiply")
        case .slash:
            print("divide")
        default:
            return
        }
    }
    
    enum Precedence: Int {
        case none
        case assignement
        case equality
        case comparison
        case term
        case factor
        case unary
        case primary
    }
    
    typealias ParseFn = () -> Void
    
    struct ParseRule {
        var prefix: ParseFn?
        var infix: ParseFn?
        var precedence: Precedence
    }
        
    private func precedence(_ precedence: Precedence) {
        
        advance()
        
        let token = tokens[previous].type
        
        if let prefixRule = rules[token.rawValue]?.prefix {
            prefixRule()
        }
        
        while
            let rule = rules[tokens[current].type.rawValue],
            precedence.rawValue <= rule.precedence.rawValue
        {
            advance()
            
            let token = tokens[previous].type
            
            if let infixRule = rules[token.rawValue]?.infix {
                infixRule()
            }
        }
    }
    
    private var rules: [String: ParseRule] {
        
        var rules: [String: ParseRule] = [:]
        
        rules[TokenType.lparen.rawValue] = ParseRule(prefix: grouping, precedence: .none)
        rules[TokenType.rparen.rawValue] = ParseRule(precedence: .none)
        rules[TokenType.lbrace.rawValue] = ParseRule(precedence: .none)
        rules[TokenType.rbrace.rawValue] = ParseRule(precedence: .none)
        rules[TokenType.lbracket.rawValue] = ParseRule(precedence: .none)
        rules[TokenType.rbracket.rawValue] = ParseRule(precedence: .none)
        
        rules[TokenType.comma.rawValue] = ParseRule(precedence: .none)
        rules[TokenType.colon.rawValue] = ParseRule(precedence: .none)
        rules[TokenType.semicolon.rawValue] = ParseRule(precedence: .none)
        rules[TokenType.bang.rawValue] = ParseRule(precedence: .none)
        
        rules[TokenType.plus.rawValue] = ParseRule(infix: binary, precedence: .term)
        rules[TokenType.minus.rawValue] = ParseRule(prefix: unary, infix: binary, precedence: .term)
        rules[TokenType.slash.rawValue] = ParseRule(infix: binary, precedence: .factor)
        rules[TokenType.star.rawValue] = ParseRule(infix: binary, precedence: .factor)
        
        rules[TokenType.hash.rawValue] = ParseRule(precedence: .none)
        rules[TokenType.backslash.rawValue] = ParseRule(precedence: .none)
        rules[TokenType.caret.rawValue] = ParseRule(precedence: .none)
        rules[TokenType.apostrophe.rawValue] = ParseRule(precedence: .none)
        rules[TokenType.backtick.rawValue] = ParseRule(precedence: .none)
        rules[TokenType.at.rawValue] = ParseRule(precedence: .none)
        
        rules[TokenType.equal.rawValue] = ParseRule(precedence: .none)
        rules[TokenType.equalEqual.rawValue] = ParseRule(precedence: .none)
        rules[TokenType.bangEqual.rawValue] = ParseRule(precedence: .none)
        
        rules[TokenType.less.rawValue] = ParseRule(precedence: .none)
        rules[TokenType.lessEqual.rawValue] = ParseRule(precedence: .none)
        rules[TokenType.greater.rawValue] = ParseRule(precedence: .none)
        rules[TokenType.greaterEqual.rawValue] = ParseRule(precedence: .none)
        
        rules[TokenType.plusEqual.rawValue] = ParseRule(precedence: .none)
        rules[TokenType.minusEqual.rawValue] = ParseRule(precedence: .none)
        
        rules[TokenType.plusPlus.rawValue] = ParseRule(precedence: .none)
        rules[TokenType.minusMinus.rawValue] = ParseRule(precedence: .none)
        
        rules[TokenType.identifier.rawValue] = ParseRule(precedence: .none)
        rules[TokenType.string.rawValue] = ParseRule(precedence: .none)
        rules[TokenType.number.rawValue] = ParseRule(prefix: number, precedence: .none)
        
        rules[TokenType.label.rawValue] = ParseRule(precedence: .none)
        
        rules[TokenType.include.rawValue] = ParseRule(precedence: .none)
        
        rules[TokenType.if.rawValue] = ParseRule(precedence: .none)
        rules[TokenType.else.rawValue] = ParseRule(precedence: .none)
        rules[TokenType.is.rawValue] = ParseRule(precedence: .none)
        
        rules[TokenType.eof.rawValue] = ParseRule(precedence: .none)
        
        return rules
    }
}
