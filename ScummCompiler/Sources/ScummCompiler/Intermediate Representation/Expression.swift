//
//  Expression.swift
//
//
//  Created by Michael Borgmann on 02/01/2024.
//

import Foundation

/// Protocol for expression visitors.
///
/// The `ExpressionVisitor` protocol defines methods to be implemented by types that wish to operate on different expression types in the AST.
///
/// Associated types:
///   - `ExpressionReturnType`: The type representing the return value of visitor methods.
///   
/// This protocol is a key component in building interpreters, AST printers, and other tools that analyze and process expressions within a programming language.
///
/// - SeeAlso: `Expression`
protocol ExpressionVisitor {
    
    /// The associated type representing the return type of visitor methods.
    associatedtype ExpressionReturnType
    
    /// Visits a binary expression node in the abstract syntax tree.
    ///
    /// - Parameters:
    ///   - expression: The `Binary` expression to be visited.
    /// - Returns: The result of the visitor's operation.
    func visitBinaryExpr(_ expression: Binary) throws -> ExpressionReturnType
    
    /// Visits a grouping expression node in the abstract syntax tree.
    ///
    /// - Parameters:
    ///   - expression: The `Grouping` expression to be visited.
    /// - Returns: The result of the visitor's operation.
    func visitGroupingExpr(_ expression: Grouping) throws -> ExpressionReturnType
    
    /// Visits a literal expression node in the abstract syntax tree.
    ///
    /// - Parameters:
    ///   - expression: The `Literal` expression to be visited.
    /// - Returns: The result of the visitor's operation.
    func visitLiteralExpr(_ expression: Literal) throws -> ExpressionReturnType
    
    /// Visits a unary expression node in the abstract syntax tree.
    ///
    /// - Parameters:
    ///   - expression: The `Unary` expression to be visited.
    /// - Returns: The result of the visitor's operation.
    func visitUnaryExpr(_ expression: Unary) throws -> ExpressionReturnType
}

/// Protocol for expressions in the abstract syntax tree.
///
/// The `Expression` protocol represents nodes in the AST and provides a way for visitors to traverse and operate on different expression types.
///
/// To implement the Visitor pattern, conforming types (e.g., `Binary`, `Grouping`, `Literal`, `Unary`) must define the `accept` method, allowing a visitor to perform operations based on the specific expression type.
///
/// This protocol is essential for building interpreters, AST printers, and other tools that need to process and analyze expressions within a programming language.
///
/// - SeeAlso: `ExpressionVisitor`
protocol Expression {
    
    /// Accepts a visitor to perform operations on the expression.
    ///
    /// - Parameters:
    ///   - visitor: The visitor implementing the `ExpressionVisitor` protocol.
    /// - Returns: The result of the visitor's operation.
    func accept<V: ExpressionVisitor, R>(visitor: V) throws -> R where R == V.ExpressionReturnType
}

/// Represents a binary expression in the abstract syntax tree.
///
/// - Properties:
///   - left: The left operand of the binary operation.
///   - operatorToken: The token representing the binary operator.
///   - right: The right operand of the binary operation.
struct Binary: Expression {
    
    /// The left operand of the binary operation.
    let left: Expression
    
    /// The token representing the binary operator.
    let operatorToken: Token
    
    /// The right operand of the binary operation.
    let right: Expression
    
    
    /// Accepts a visitor to perform operations on the binary expression.
    ///
    /// - Parameters:
    ///   - visitor: The visitor implementing the `ExpressionVisitor` protocol.
    /// - Returns: The result of the visitor's operation.
    func accept<V, R>(visitor: V) throws -> R where V : ExpressionVisitor, R == V.ExpressionReturnType {
        try visitor.visitBinaryExpr(self)
    }
}

/// Represents a grouping expression in the abstract syntax tree.
///
/// - Properties:
///   - expression: The grouped expression.
struct Grouping: Expression {
    
    /// The grouped expression.
    let expression: Expression
    
    /// Accepts a visitor to perform operations on the grouping expression.
    ///
    /// - Parameters:
    ///   - visitor: The visitor implementing the `ExpressionVisitor` protocol.
    /// - Returns: The result of the visitor's operation.
    func accept<V, R>(visitor: V) throws -> R where V : ExpressionVisitor, R == V.ExpressionReturnType {
        try visitor.visitGroupingExpr(self)
    }
}

/// Represents a literal expression in the abstract syntax tree.
///
/// - Properties:
///   - `value`: The value of the literal expression, which can be of any type (e.g., `Int`, `Bool`, `nil`).
///   - `token`: The token associated with the literal, which may be `nil`. The token contains metadata
///     such as the line and column where the literal was found in the source code. This is primarily
///     used for debugging and error reporting.
///
/// - Initializer:
///   - `value`: The value of the literal.
///   - `token`: An optional token representing the position of the literal in the source code (defaults to `nil`).
///
struct Literal: Expression {
    
    /// The value of the literal expression, which can be of any type.
    let value: Any?
    
    /// The associated token for the literal, containing line number information for error reporting.
    ///
    /// - Note: The token is primarily used for the line number in error handling and VM code generation.
    let token: Token?
    
    /// Initializes a new literal expression.
    ///
    /// - Parameters:
    ///   - value: The actual value of the literal expression. This can be of any type (e.g., `String`, `Int`, `Bool`).
    ///   - token: An optional `Token` associated with this literal expression, which may contain line number
    ///     information for error handling or code generation.
    ///     - If not provided, the token will default to `nil`, meaning there is no token associated with the literal.
    init(value: Any?, token: Token? = nil) {
        self.value = value
        self.token = token
    }
    
    /// Accepts a visitor to perform operations on the literal expression.
    ///
    /// - Parameters:
    ///   - visitor: The visitor implementing the `ExpressionVisitor` protocol.
    /// - Returns: The result of the visitor's operation.
    func accept<V, R>(visitor: V) throws -> R where V : ExpressionVisitor, R == V.ExpressionReturnType {
        try visitor.visitLiteralExpr(self)
    }
}

/// Represents a unary expression in the abstract syntax tree.
///
/// - Properties:
///   - operatorToken: The token representing the unary operator.
///   - right: The operand of the unary operation.
struct Unary: Expression {
    
    /// The token representing the unary operator.
    let operatorToken: Token
    
    /// The operand of the unary operation.
    let right: Expression
    
    /// Accepts a visitor to perform operations on the unary expression.
    ///
    /// - Parameters:
    ///   - visitor: The visitor implementing the `ExpressionVisitor` protocol.
    /// - Returns: The result of the visitor's operation.
    func accept<V, R>(visitor: V) throws -> R where V : ExpressionVisitor, R == V.ExpressionReturnType {
        try visitor.visitUnaryExpr(self)
    }
}
