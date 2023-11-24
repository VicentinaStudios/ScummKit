//
//  Parser.swift
//  scumm
//
//  Created by Michael Borgmann on 22/07/2023.
//

import Foundation

/// The SCUMM Parser class
class Parser {
    
    private let tokens: [Token]
    private var current: Int
    
    /// Initialize SCUMM parser with tokens
    /// - Parameters:
    ///   - tokens: Tokens to parse
    init(tokens: [Token]) {
        self.tokens = tokens
        self.current = tokens.startIndex
    }
    
    /// Parse tokens  to detect expressions
    /// - Returns: Detected expression from tokens
    func parse() -> [Statement] {
        
        var statements: [Statement] = []
        
        while !isEndOfFile {
            if let statement = declaration() {
                statements.append(statement)
            }
        }
        
        return statements
    }
    
    private func declaration() -> Statement? {
        
        do {
            
            if match(types: .VAR) {
                return try variableDeclaration()
            } else {
                return try statement()
            }
            
        } catch {
            synchronize()
            return nil
        }
    }
    
    private func variableDeclaration() throws -> Statement {
        
        let name = try consume(type: .IDENTIFIER, onError: ParserError.expectVariableName(atLine: peek.line))
        let initializer = match(types: .EQUAL) ? try expression() : nil
        
        _ = try consume(type: .SEMICOLON, onError: ParserError.missingSemicolon(atLine: peek.line))
        
        return VariableStatement(name: name, initializer: initializer)
    }
    
    private func statement() throws -> Statement {
        
        if match(types: .FOR) {
            return try forStatement()
        } else if match(types: .IF) {
            return try ifStatement()
        } else if match(types: .PRINT) {
            return try printStatement()
        } else if match(types: .WHILE) {
            return try whileStatement()
        } else if match(types: .LEFT_BRACE) {
            return Block(statements: try block())
        } else {
            return try expressionStatement()
        }
    }
    
    private func forStatement() throws -> Statement {
    
        _ = try consume(type: .LEFT_PAREN, onError: ParserError.missingOpeningParenthesisForForLoop(atLine: peek.line))
        
        let initializer: Statement?
        
        if match(types: .SEMICOLON) {
            initializer = nil
        } else if match(types: .VAR) {
            initializer = try variableDeclaration()
        } else {
            initializer = try expressionStatement()
        }
        
        let condition = !check(type: .SEMICOLON) ? try expression() : Literal(value: true)
        
        _ = try consume(type: .SEMICOLON, onError: ParserError.missingSemicolonAfterLoopCondition(atLine: peek.line))
        
        let increment = !check(type: .RIGHT_PAREN) ? try expression() : nil
        
        _ = try consume(type: .RIGHT_PAREN, onError: ParserError.missingClosingParenthesisAfterFor(atLine: peek.line))
        
        var body = try statement()
        
        if let increment = increment {
            body = Block(statements: [body, ExpressionStmt(expression: increment)])
        }
        
        body = While(condition: condition, body: body)
        
        if let initializer = initializer {
            body = Block(statements: [initializer, body])
        }
        
        return body
    }
    
    private func ifStatement() throws -> Statement {
        
        _ = try consume(type: .LEFT_PAREN, onError: ParserError.missingOpeningParenthesisForIf(atLine: peek.line))
        let condition = try expression()
        _ = try consume(type: .RIGHT_PAREN, onError: ParserError.missingClosingParenthesisForCondition(atLine: peek.line))
        
        let thenBranch = try statement()
        
        let elseBranch = match(types: .ELSE) ? try statement() : nil
        
        return If(condition: condition, thenBranch: thenBranch, elseBranch: elseBranch)
    }
    
    private func whileStatement() throws -> Statement {
        
        _ = try consume(type: .LEFT_PAREN, onError: ParserError.missingOpeningParenthesisForWhile(atLine: peek.line))
        let condition = try expression()
        _ = try consume(type: .RIGHT_PAREN, onError: ParserError.missingClosingParenthesisForCondition(atLine: peek.line))
        
        let body = try statement()
        
        return While(condition: condition, body: body)
    }
    
    private func printStatement() throws -> Statement {
        
        let value = try expression()
        _ = try consume(type: .SEMICOLON)
        
        return Print(expression: value)
    }
    
    private func expressionStatement() throws -> Statement {
        
        let expression = try expression()
        _ = try consume(type: .SEMICOLON)
        
        return ExpressionStmt(expression: expression)
    }
    
    private func block() throws -> [Statement] {
        
        var statements: [Statement] = []
        
        while !check(type: .RIGHT_BRACE) && !isEndOfFile {
            if let statement = declaration() {
                statements.append(statement)
            }
        }
        
        _ = try consume(
            type: .RIGHT_BRACE,
            onError: ParserError.missingClosingBraces(atLine: peek.line)
        )
        
        return statements
    }
    
    private func assignment() throws -> Expression {
        
        let expression = try or()
        
        if match(types: .EQUAL) {
            
            let equals = previous
            let value = try assignment()
            
            if let expression = expression as? VariableExpression {
                return Assign(name: expression.name, value: value)
            }
            
            throw ParserError.invalidAssignment(atLine: equals.line)
        }
        
        return expression
    }
    
    private func or() throws -> Expression {
        
        var expression = try and()
        
        while match(types: .OR) {
            
            let operatorToken = previous
            let right = try and()
            expression = Logical(left: expression, operatorToken: operatorToken, right: right)
        }
        
        return expression
    }
    
    private func and() throws -> Expression {
        
        var expression = try equality()
        
        while match(types: .AND) {
            
            let operatorToken = previous
            let right = try equality()
            expression = Logical(left: expression, operatorToken: operatorToken, right: right)
        }
        
        return expression
    }
    
    private func expression() throws -> Expression {
        try assignment()
    }
    
    private func equality() throws -> Expression {
        
        var expression = try comparison()
        
        while match(types: .BANG_EQUAL, .EQUAL_EQUAL) {
            
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
        
        while match(types: .GREATER, .GREATER_EQUAL, .LESS, .LESS_EQUAL) {
            
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
        
        while match(types: .MINUS, .PLUS) {
            
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
        
        while match(types: .SLASH, .STAR) {
            
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
        
        if match(types: .BANG, .MINUS) {
            
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
        
        if match(types: .FALSE) {
            return Literal(value: false)
        }
        
        if match(types: .TRUE) {
            return Literal(value: true)
        }
        
        if match(types: .NIL) {
            return Literal(value: nil)
        }
        
        if match(types: .NUMBER, .STRING) {
            return Literal(value: previous.literal)
        }
        
        if match(types: .IDENTIFIER) {
            return VariableExpression(name: previous)
        }
        
        if match(types: .LEFT_PAREN) {
            
            let expression = try expression()
            _ = try consume(type: .RIGHT_PAREN)
            
            return Grouping(expression: expression)
        }
        
        throw ParserError.expressionExpected(atLine: peek.line)
    }
    
    private func consume(type: TokenType, onError error: Error? = nil) throws -> Token {
        
        guard check(type: type) else {
            
            if let error = error {
                throw error
            } else {
                throw ParserError.missingClosingParenthesis(atLine: peek.line)
            }
        }
        
        //current = tokens.index(after: current)
        return advance
    }
    
    // MARk: Helper
    
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
    
    private var advance: Token {
        if !isEndOfFile {
            current = tokens.index(after: current)
        }
        return previous
    }
    
    private var peek: Token {
        tokens[current]
    }
    
    private var previous: Token {
        tokens[tokens.index(before: current)]
    }
    
    private var isEndOfFile: Bool {
        peek.type == .EOF
    }
    
    private func synchronize() {
        
        current = tokens.index(after: current)
        
        while !isEndOfFile {
            
            if previous.type == .SEMICOLON {
                return
            }
            
            switch peek.type {
            case .CLASS, .FUNC, .VAR, .FOR, .IF, . WHILE, .PRINT, .RETURN:
                return
            default:
                break
            }
        }
        
        current = tokens.index(after: current)
    }
}
