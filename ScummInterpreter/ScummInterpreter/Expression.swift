//
//  Expr.swift
//  scumm
//
//  Created by Michael Borgmann on 26/07/2023.
//

import Foundation

protocol ExpressionVisitor {
    
    associatedtype ExpressionReturnType
    
    func visitBinaryExpr(_ expression: Binary) throws -> ExpressionReturnType
    func visitGroupingExpr(_ expression: Grouping) throws -> ExpressionReturnType
    func visitLiteralExpr(_ expression: Literal) throws -> ExpressionReturnType
    func visitUnaryExpr(_ expression: Unary) throws -> ExpressionReturnType
    func visitVariableExpr(_ expression: VariableExpression) throws -> ExpressionReturnType
    func visitAssignExpr(_ expression: Assign) throws -> ExpressionReturnType
    func visitLogicalExpr(_ expr: Logical) throws -> ExpressionReturnType
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

struct VariableExpression: Expression {
    
    let name: Token
    
    func accept<V, R>(visitor: V) throws -> R where V : ExpressionVisitor, R == V.ExpressionReturnType {
        try visitor.visitVariableExpr(self)
    }
}

struct Assign: Expression {
    
    let name: Token
    let value: Expression?
    
    func accept<V, R>(visitor: V) throws -> R where V : ExpressionVisitor, R == V.ExpressionReturnType {
        try visitor.visitAssignExpr(self)
    }
}

struct Logical: Expression {
    
    let left: Expression
    let operatorToken: Token
    let right: Expression
    
    func accept<V, R>(visitor: V) throws -> R where V : ExpressionVisitor, R == V.ExpressionReturnType {
        try visitor.visitLogicalExpr(self)
    }
}
