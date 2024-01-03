//
//  Expression.swift
//
//
//  Created by Michael Borgmann on 02/01/2024.
//

import Foundation

protocol ExpressionVisitor {
    
    associatedtype ExpressionReturnType
    
    func visitBinaryExpr(_ expression: Binary) throws -> ExpressionReturnType
    func visitGroupingExpr(_ expression: Grouping) throws -> ExpressionReturnType
    func visitLiteralExpr(_ expression: Literal) throws -> ExpressionReturnType
    func visitUnaryExpr(_ expression: Unary) throws -> ExpressionReturnType
}

protocol Expression {
    func accept<V: ExpressionVisitor, R>(visitor: V) throws -> R where R == V.ExpressionReturnType
}

struct Binary: Expression {
    
    let left: Expression
    let operatorToken: Token
    let right: Expression
    
    func accept<V, R>(visitor: V) throws -> R where V : ExpressionVisitor, R == V.ExpressionReturnType {
        try visitor.visitBinaryExpr(self)
    }
}

struct Grouping: Expression {
    
    let expression: Expression
    
    func accept<V, R>(visitor: V) throws -> R where V : ExpressionVisitor, R == V.ExpressionReturnType {
        try visitor.visitGroupingExpr(self)
    }
}

struct Literal: Expression {
    
    let value: Any?
    
    func accept<V, R>(visitor: V) throws -> R where V : ExpressionVisitor, R == V.ExpressionReturnType {
        try visitor.visitLiteralExpr(self)
    }
}

struct Unary: Expression {
    
    let operatorToken: Token
    let right: Expression
    
    func accept<V, R>(visitor: V) throws -> R where V : ExpressionVisitor, R == V.ExpressionReturnType {
        try visitor.visitUnaryExpr(self)
    }
}
