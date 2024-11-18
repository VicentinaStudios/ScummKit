//
//  Interpreter.swift
//
//
//  Created by Michael Borgmann on 03/01/2024.
//

import Foundation

/// A class responsible for interpreting expressions in the abstract syntax tree (AST).
///
/// The `Interpreter` class evaluates AST expressions, performing arithmetic operations and handling errors as needed.
///
/// - Note: This class serves as the core interpreter for expressions and provides methods for interpretation and value conversion.
///
/// Example Usage:
/// ```swift
/// let scanner = Scanner(source: source)
/// let tokens = try scanner.scanAllTokens()
/// let parser = DecentParser(tokens: tokens)
/// let expression = try parse.parse()
/// let interpreter = Interpreter()
/// let result = try interpreter.interpret(ast: expression)
/// print(interpreter.stringify(result))
/// ```
///
/// - SeeAlso: `Expression`, `ExpressionVisitor`, `InterpreterError` for related components.
class Interpreter {
    
    // MARK: Actions
    
    /// Interprets the given AST expression.
    ///
    /// - Parameters:
    ///   - ast: The AST expression to be interpreted.
    /// - Returns: The result of the interpretation, which can be of any type.
    /// - Throws: An error if the interpretation encounters issues.
    func interpret(ast: Expression) throws -> Any? {
        try evaluate(ast)
    }
    
    /// Converts a value to its string representation.
    ///
    /// - Parameters:
    ///   - value: The value to be converted.
    /// - Returns: A string representation of the value.
    func stringify(_ value: Any?) -> String {
        
        guard let value = value else {
            return "nil"
        }
        
        switch value {
        case let double as Double where double.truncatingRemainder(dividingBy: 1) == 0:
            return String(format: "%.0f", double)
        default:
            return String(describing: value)
        }
    }
    
    // MARK: Helper
    
    /// Evaluates an expression within the AST.
    ///
    /// - Parameters:
    ///   - expression: The expression to be evaluated.
    /// - Returns: The result of the evaluation, which can be of any type.
    /// - Throws: An error if the evaluation encounters issues.
    private func evaluate(_ expression: Expression) throws -> Any? {
        try expression.accept(visitor: self)
    }
}

extension Interpreter: ExpressionVisitor {
    
    /// Visits a literal expression node in the AST.
    ///
    /// - Parameters:
    ///   - expression: The `Literal` expression to be visited.
    /// - Returns: The value of the literal expression.
    func visitLiteralExpr(_ expression: LiteralExpression) -> Any? {
        expression.value
    }
    
    /// Visits a grouping expression node in the AST.
    ///
    /// - Parameters:
    ///   - expression: The `Grouping` expression to be visited.
    /// - Returns: The result of the grouped expression.
    /// - Throws: An error if the evaluation of the grouped expression encounters issues.
    func visitGroupingExpr(_ expression: GroupingExpession) throws -> Any? {
        try evaluate(expression.expression)
    }
    
    /// Visits a unary expression node in the AST.
    ///
    /// - Parameters:
    ///   - expression: The `Unary` expression to be visited.
    /// - Returns: The result of the unary operation.
    /// - Throws: An error if the evaluation of the unary expression encounters issues.
    func visitUnaryExpr(_ expression: UnaryExpression) throws -> Any? {

        guard
            let right = try evaluate(expression.right) as? Int
        else {
            throw InterpreterError.missingOperand(type: "unary", line: expression.operatorToken.line)
        }
        
        switch expression.operatorToken.type {
        
        case .minus:
            return -right
            
        default:
            throw InterpreterError.unsupportedOperator(type: "unary", line: expression.operatorToken.line)
        }
    }
    
    /// Visits a binary expression node in the AST.
    ///
    /// - Parameters:
    ///   - expression: The `Binary` expression to be visited.
    /// - Returns: The result of the binary operation.
    /// - Throws: An error if the evaluation of the binary expression encounters issues.
    func visitBinaryExpr(_ expression: BinaryExpression) throws -> Any? {
        
        guard
            let left = try evaluate(expression.left) as? Int,
            let right = try evaluate(expression.right) as? Int
        else {
            throw InterpreterError.missingOperand(type: "binary", line: expression.operatorToken.line)
        }
        
        switch expression.operatorToken.type {
            
        case .minus:
            return left - right
            
        case .slash:
            
            guard right != 0 else {
                throw InterpreterError.divisionByZero(line: expression.operatorToken.line)
            }
            
            return left / right
            
        case .star:
            return left * right
            
        case .plus:
            return left + right
            
        default:
            throw InterpreterError.unsupportedOperator(type: "binary", line: expression.operatorToken.line)
        }
    }
    
    func visitVariableExpr(_ expression: VariableExpression) throws -> Any? {
        fatalError("Method should be overridden by subclasses")
    }
    
    func visitAssignExpr(_ expression: AssignExpression) throws -> Any? {
        fatalError("Method should be overridden by subclasses")
    }
}
