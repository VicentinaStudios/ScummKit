//
//  ASTPrinter.swift
//
//
//  Created by Michael Borgmann on 03/01/2024.
//

import Foundation

class ASTPrinter {
    
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

extension ASTPrinter: ExpressionVisitor {
    
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
}
