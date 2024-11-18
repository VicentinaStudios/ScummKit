//
//  ASTPrinter.swift
//
//
//  Created by Michael Borgmann on 03/01/2024.
//

import Foundation

/// A utility class for printing the Abstract Syntax Tree (AST) structure.
///
/// The `ASTPrinter` class provides methods to traverse an AST and generate a human-readable string representation
/// of its structure. It implements the `ExpressionVisitor` protocol to define behavior for different expression types.
///
/// Example Usage:
/// ```swift
/// let astPrinter = ASTPrinter()
/// if let expression = //... create or obtain an expression ... {
///     if let printedAST = astPrinter.print(expression: expression) {
///         print(printedAST)
///     }
/// }
/// ```
class ASTPrinter {
    
    /// Prints the structure of the given expression.
    ///
    /// - Parameters:
    ///   - expression: The root expression of the AST to be printed.
    /// - Returns: A string representation of the AST structure.
    func print(expression: Expression) -> String? {
        do {
            return try expression.accept(visitor: self)
        } catch {
            return error.localizedDescription
        }
    }
    
    /// Creates a parenthesized representation of an expression with a given name.
    ///
    /// - Parameters:
    ///   - name: The name associated with the expression type.
    ///   - expressions: The expressions to be parenthesized.
    /// - Returns: A parenthesized string representation of the expressions.
    /// - Throws: An error if an issue occurs during the expression traversal.
    private func parenthesize(name: String, expressions: Expression...) throws -> String {
        
        let result = try expressions
            .map { try $0.accept(visitor: self) }
            .joined(separator: " ")
        
        return "(\(name) \(result))"
    }
}

extension ASTPrinter: ExpressionVisitor {
    
    /// Prints the structure of a binary expression.
    ///
    /// - Parameters:
    ///   - expression: The binary expression to be printed.
    /// - Returns: A string representation of the binary expression structure.
    /// - Throws: An error if an issue occurs during the expression traversal.
    func visitBinaryExpr(_ expression: BinaryExpression) throws -> String {
        try parenthesize(name: expression.operatorToken.lexeme, expressions: expression.left, expression.right)
    }
    
    /// Prints the structure of a grouping expression.
    ///
    /// - Parameters:
    ///   - expression: The grouping expression to be printed.
    /// - Returns: A string representation of the grouping expression structure.
    /// - Throws: An error if an issue occurs during the expression traversal.
    func visitGroupingExpr(_ expression: GroupingExpession) throws -> String {
        try parenthesize(name: "group", expressions: expression.expression)
    }
    
    /// Prints the structure of a literal expression.
    ///
    /// - Parameters:
    ///   - expression: The literal expression to be printed.
    /// - Returns: A string representation of the literal expression structure.
    func visitLiteralExpr(_ expression: LiteralExpression) -> String {
        "\(expression.value ?? "nil")"
    }
    
    /// Prints the structure of a unary expression.
    ///
    /// - Parameters:
    ///   - expression: The unary expression to be printed.
    /// - Returns: A string representation of the unary expression structure.
    /// - Throws: An error if an issue occurs during the expression traversal.
    func visitUnaryExpr(_ expression: UnaryExpression) throws -> String {
        try parenthesize(name: expression.operatorToken.lexeme, expressions: expression.right)
    }
    
    /// Prints the structure of a variable expression.
    ///
    /// A variable expression refers to a named identifier in the program's environment.
    ///
    /// - Parameters:
    ///   - expression: The variable expression to be printed.
    /// - Returns: A string representation of the variable name.
    /// - Throws: An error if an issue occurs during the expression traversal.
    func visitVariableExpr(_ expression: VariableExpression) throws -> String {
        expression.name.lexeme
    }
    
    /// Prints the structure of an assignment expression.
    ///
    /// An assignment expression assigns a value to a variable and is represented as `name = value`.
    ///
    /// - Parameters:
    ///   - expression: The assignment expression to be printed.
    /// - Returns: A string representation of the assignment expression structure.
    /// - Throws: An error if an issue occurs during the expression traversal.
    func visitAssignExpr(_ expression: AssignExpression) throws -> String {
        try parenthesize(name: "=", expressions: expression)
    }
}
