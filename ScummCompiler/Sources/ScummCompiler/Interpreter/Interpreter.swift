//
//  Interpreter.swift
//
//
//  Created by Michael Borgmann on 03/01/2024.
//

import Foundation

class Interpreter {
    
    // MARK: Actions
    
    func interpret(ast: Expression) throws {
        
        let value = try evaluate(ast)
        print(stringify(value))
    }
    
    // MARK: Helper
    
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
}

extension Interpreter: ExpressionVisitor {
    
    func visitLiteralExpr(_ expression: Literal) -> Any? {
        expression.value
    }
    
    func visitGroupingExpr(_ expression: Grouping) throws -> Any? {
        try evaluate(expression.expression)
    }
    
    func visitUnaryExpr(_ expression: Unary) throws -> Any? {
        
        guard
            let right = try evaluate(expression.right) as? Int
        else {
            throw CompilerError.compileError
        }
        
        switch expression.operatorToken.type {
        
        case .minus:
            
            return -right
            
        default:
            return nil
        }
    }
    
    func visitBinaryExpr(_ expression: Binary) throws -> Any? {
        
        guard
            let left = try evaluate(expression.left) as? Int,
            let right = try evaluate(expression.right) as? Int
        else {
            throw CompilerError.compileError
        }
        
        switch expression.operatorToken.type {
            
        case .minus:
            return left - right
            
        case .slash:
            return left / right
            
        case .star:
            return left * right
            
        case .plus:
            return left + right
            
        default:
            return nil
        }
    }
}
