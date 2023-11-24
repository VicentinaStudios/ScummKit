//
//  PrettyPrint.swift
//  scumm
//
//  Created by Michael Borgmann on 26/07/2023.
//

import Foundation

class ASTPrint {
    
    func print(expression: Expression) -> String? {
        do {
            return try expression.accept(visitor: self)
        } catch {
            return error.localizedDescription
        }
    }
    
    private func parenthesize(name: String, expressions: Expression...) throws -> String {
        
        let result = try expressions
            .map { try $0.accept(visitor: self) }
            .joined(separator: " ")
        
        return "(\(name) \(result))"
    }
}

extension ASTPrint: ExpressionVisitor {
    
    func visitBinaryExpr(_ expression: Binary) throws -> String {
        try parenthesize(name: expression.operatorToken.lexeme, expressions: expression.left, expression.right)
    }
    
    func visitGroupingExpr(_ expression: Grouping) throws -> String {
        try parenthesize(name: "group", expressions: expression.expression)
    }
    
    func visitLiteralExpr(_ expression: Literal) -> String {
        
        guard let value = expression.value else {
            return "nil"
        }
        
        return "\(value)"
    }
    
    func visitUnaryExpr(_ expression: Unary) throws -> String {
        try parenthesize(name: expression.operatorToken.lexeme, expressions: expression.right)
    }
    
    func visitVariableExpr(_ expression: VariableExpression) throws -> String {
        expression.name.lexeme
    }
    
    func visitAssignExpr(_ expression: Assign) throws -> String {
        try parenthesize(name: "=", expressions: expression)
    }
    
    func visitLogicalExpr(_ expr: Logical) throws -> String {
        try parenthesize(name: expr.operatorToken.lexeme, expressions: expr.left, expr.right)
    }
}
