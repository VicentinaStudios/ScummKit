//
//  Interpreter.swift
//  scumm
//
//  Created by Michael Borgmann on 27/07/2023.
//

import Foundation

class Interpreter {
    
    private var environment = Environment()
    
    /// Interpret parsed statements of the source code
    /// - Parameters:
    ///   - statements: Array of statements to be interpreted
    func interpret(statements: [Statement]) {
        
        do {
            
            for statement in statements {
                try execute(statement)
            }
            
        } catch let error as RuntimeError {
            ErrorHandler.handle(error)
        } catch {
            ErrorHandler.handle(RuntimeError.unexpectedError)
        }
    }
    
    // MARK: Helper
    
    private func execute(_ statement: Statement) throws {
        try statement.accept(visitor: self)
    }
    
    private func executeBlock(statements: [Statement], environment: Environment) throws {
        
        let previous = self.environment
        self.environment = environment
        
        defer {
            self.environment = previous
        }
        
        for statement in statements {
            try execute(statement)
        }
    }
    
    private func evaluate(_ expression: Expression) throws -> Any? {
        try expression.accept(visitor: self)
    }
    
    private func stringify(_ value: Any?) -> String {
        
        guard let value = value else {
            return "nil"
        }
        
        if let double = value as? Double {
            
            let doubleString = String(double)
            
            if doubleString.hasSuffix(".0") {
                return String(doubleString.dropLast(2))
            } else {
                return doubleString
            }
        }
        
        return String(describing: value)
    }
    
    private func isTruthy(_ value: Any?) -> Bool {
        value as? Bool ?? false
    }
    
    private func isEqual(_ left: Any?, _ right: Any?) -> Bool {
        
        if left == nil && right == nil {
            return true
        } else if left == nil {
            return false
        }
        
        guard
            let left = left as? any Equatable,
            let right = right as? any Equatable
        else {
            return false
        }
        
        return left.isEqual(right)
    }
}

// MARK: - Expression Vistor Protocol

extension Interpreter: ExpressionVisitor {
    
    func visitLiteralExpr(_ expression: Literal) -> Any? {
        expression.value
    }
    
    func visitGroupingExpr(_ expression: Grouping) throws -> Any? {
        try evaluate(expression.expression)
    }
    
    func visitUnaryExpr(_ expression: Unary) throws -> Any? {
        
        let right = try evaluate(expression.right)
        
        switch expression.operatorToken.type {
        
        case .MINUS:
            
            guard let right = right as? Double else {
                throw RuntimeError.typeMisatch(atLine: expression.operatorToken.line)
            }
            
            return -right
        
        case .BANG:
            return !isTruthy(right)
            
        default:
            return nil
        }
    }
    
    func visitBinaryExpr(_ expression: Binary) throws -> Any? {
        
        let left = try evaluate(expression.left)
        let right = try evaluate(expression.right)
        
        switch expression.operatorToken.type {
            
        case .MINUS:
            
            guard
                let left = left as? Double,
                let right = right as? Double
            else {
                throw RuntimeError.typeMisatch(atLine: expression.operatorToken.line)
            }
            
            return left - right
        
        case .SLASH:
            
            guard
                let left = left as? Double,
                let right = right as? Double
            else {
                throw RuntimeError.typeMisatch(atLine: expression.operatorToken.line)
            }
            
            return left / right
            
        case .STAR:
            
            guard
                let left = left as? Double,
                let right = right as? Double
            else {
                throw RuntimeError.typeMisatch(atLine: expression.operatorToken.line)
            }
            
            return left * right
            
        case .PLUS:
            
            if let left = left as? Double,
               let right = right as? Double
            {
                return left + right
            }
            
            if let left = left as? String,
               let right = right as? String
            {
                return left + right
            }
            
            throw RuntimeError.typeMisatch(atLine: expression.operatorToken.line)
            
        case .GREATER:
            
            guard
                let left = left as? Double,
                let right = right as? Double
            else {
                throw RuntimeError.typeMisatch(atLine: expression.operatorToken.line)
            }
            
            return left > right
            
        case .GREATER_EQUAL:
            
            guard
                let left = left as? Double,
                let right = right as? Double
            else {
                throw RuntimeError.typeMisatch(atLine: expression.operatorToken.line)
            }
            
            return left >= right
            
        case .LESS:
            
            guard
                let left = left as? Double,
                let right = right as? Double
            else {
                throw RuntimeError.typeMisatch(atLine: expression.operatorToken.line)
            }
            
            return left < right
            
        case .LESS_EQUAL:
            
            guard
                let left = left as? Double,
                let right = right as? Double
            else {
                throw RuntimeError.typeMisatch(atLine: expression.operatorToken.line)
            }
            
            return left <= right
            
        case .EQUAL_EQUAL:
            return isEqual(left, right)
            
        case .BANG_EQUAL:
            return !isEqual(left, right)
            
        default:
            return nil
        }
    }
    
    func visitVariableExpr(_ expression: VariableExpression) throws -> Any? {
        try environment.get(name: expression.name)
    }
    
    func visitAssignExpr(_ expression: Assign) throws -> Any? {
        let value = try evaluate(expression.value!)
        try environment.assign(name: expression.name, value: value)
        return value
    }
    
    func visitLogicalExpr(_ expr: Logical) throws -> Any? {
        
        let left = try evaluate(expr.left)
        
        let isOR = expr.operatorToken.type == .OR
        let isLeftTruthy = isTruthy(left)
    
        if (isOR && isLeftTruthy) || (!isOR && !isLeftTruthy) {
            return left
        }
        
        return try evaluate(expr.right)
    }
}

// MARK: - Statement Visitor Protocol

extension Interpreter: StatementVisitor {
    
    func visitPrintStmt(_ stmt: Print) throws -> Void {
        
        let value = try evaluate(stmt.expression)
        let string = stringify(value)
        CLI.writeMessage(string)
    }
    
    func visitExpressionStmt(_ stmt: ExpressionStmt) throws -> Void {
       _ = try evaluate(stmt.expression)
    }
    
    func visitVarStmt(_ stmt: VariableStatement) throws -> Void {
        
        var value: Any? = nil
        
        if let expression = stmt.initializer {
            value = try evaluate(expression)
        }
        
        environment.define(name: stmt.name.lexeme, value: value)
    }
    
    func visitBlockStmt(_ stmt: Block) throws -> Void {
        try executeBlock(
            statements: stmt.statements,
            environment: Environment(enclosing: environment)
        )
    }
    
    func visitIfStmt(_ stmt: If) throws -> Void {
        
        if isTruthy(try evaluate(stmt.condition)) {
            try execute(stmt.thenBranch)
        } else if let elseBranch = stmt.elseBranch {
            try execute(elseBranch)
        }
    }
    
    func visitWhileStmt(_ stmt: While) throws -> Void {
        
        while isTruthy(try evaluate(stmt.condition)) {
            try execute(stmt.body)
        }
    }
}
