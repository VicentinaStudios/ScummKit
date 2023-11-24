//
//  Statement.swift
//  scumm
//
//  Created by Michael Borgmann on 07/08/2023.
//

import Foundation

protocol StatementVisitor {
    
    associatedtype StatementReturnType
    
    func visitPrintStmt(_ stmt: Print) throws -> StatementReturnType
    func visitExpressionStmt(_ stmt: ExpressionStmt) throws -> StatementReturnType
    func visitVarStmt(_ stmt: VariableStatement) throws -> StatementReturnType
    func visitBlockStmt(_ stmt: Block) throws -> StatementReturnType
    func visitIfStmt(_ stmt: If) throws -> StatementReturnType
    func visitWhileStmt(_ stmt: While) throws -> StatementReturnType
}

protocol Statement {
    func accept<V: StatementVisitor, R>(visitor: V) throws -> R where R == V.StatementReturnType
}

struct Print: Statement {
    
    let expression: Expression
    
    func accept<V, R>(visitor: V) throws -> R where V : StatementVisitor, R == V.StatementReturnType {
        try visitor.visitPrintStmt(self)
    }
 }

struct ExpressionStmt: Statement {
    
    let expression: Expression
    
    func accept<V, R>(visitor: V) throws -> R where V : StatementVisitor, R == V.StatementReturnType {
        try visitor.visitExpressionStmt(self)
    }
}

struct VariableStatement: Statement {
    
    let name: Token
    let initializer: Expression?
    
    func accept<V, R>(visitor: V) throws -> R where V : StatementVisitor, R == V.StatementReturnType {
        try visitor.visitVarStmt(self)
    }
}

struct Block: Statement {
    
    let statements: [Statement]
    
    func accept<V, R>(visitor: V) throws -> R where V : StatementVisitor, R == V.StatementReturnType {
        try visitor.visitBlockStmt(self)
    }
}

struct If: Statement {
    
    let condition: Expression
    let thenBranch: Statement
    let elseBranch: Statement?
    
    func accept<V, R>(visitor: V) throws -> R where V : StatementVisitor, R == V.StatementReturnType {
        try visitor.visitIfStmt(self)
    }
}

struct While: Statement {
    
    let condition: Expression
    let body: Statement
    
    func accept<V, R>(visitor: V) throws -> R where V : StatementVisitor, R == V.StatementReturnType {
        try visitor.visitWhileStmt(self)
    }
}
