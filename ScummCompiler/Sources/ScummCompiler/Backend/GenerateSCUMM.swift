//
//  GenerateSCUMM.swift
//
//
//  Created by Michael Borgmann on 04/01/2024.
//

import Foundation

/// A code generator for the SCUMM virtual machine, producing bytecode from expressions.
///
/// This class extends the `BaseCodeGenerator` class and implements the necessary bytecode generation logic
/// specific to the SCUMM virtual machine's opcode set.
class GenerateSCUMM: BaseCodeGenerator<ScummOpcode> {
    
    // MARK: Actions
    
    /// Generates bytecode for the given expression.
    ///
    /// - Parameter expression: The expression to generate bytecode for.
    /// - Returns: The `Chunk` containing the generated bytecode.
    /// - Throws: An error of type `CodeGeneratorError` if bytecode generation fails.
    override func generateByteCode(expression: Expression) throws -> Chunk {
        
        line = (expression as? Binary)?.operatorToken.line ?? (expression as? Unary)?.operatorToken.line
        
        try emitBytes(ScummOpcode.expression.rawValue, 0x02, 0x40)
        
        _ = try evaluate(expression)
        
        try emitBytes(0xff)
        
        return chunk
    }
    
    // MARK: Expression Visitor
    
    /// Visits a literal expression and returns the literal value.
    ///
    /// - Parameter expression: The literal expression to visit.
    /// - Returns: The literal value.
    override func visitLiteralExpr(_ expression: Literal) -> Any? {
        return expression.value
    }
    
    /// Visits a grouping expression and evaluates its inner expression.
    ///
    /// - Parameter expression: The grouping expression to visit.
    /// - Throws: An error of type `CodeGeneratorError.expressionEvaluationFailed` if evaluation fails.
    override func visitGroupingExpr(_ expression: Grouping) throws -> Any? {
        try evaluate(expression.expression)
    }
    
    /// Visits a unary expression, sets the current line, evaluates the right expression, and returns the result of the unary operation.
    ///
    /// - Parameter expression: The unary expression to visit.
    /// - Returns: The result of the unary operation.
    /// - Throws: An error of type `CodeGeneratorError.expressionEvaluationFailed` if evaluation fails.
    override func visitUnaryExpr(_ expression: Unary) throws -> Any? {
        
        line = expression.operatorToken.line
        
        guard
            let right = try evaluate(expression.right) as? Int
        else {
            throw CodeGeneratorError.expressionEvaluationFailed
        }
        
        switch expression.operatorToken.type {
        
        case .minus:
            try emitBytes(0x01, integerToBytes(-right)[0], integerToBytes(-right)[1])
            return nil  // -right
            
        default:
            return nil
        }
    }
    
    /// Visits a binary expression, sets the current line, evaluates the left and right expressions, emits corresponding bytecode, and returns `nil`.
    ///
    /// - Parameter expression: The binary expression to visit.
    /// - Throws: An error of type `CodeGeneratorError.expressionEvaluationFailed` if evaluation fails.
    override func visitBinaryExpr(_ expression: Binary) throws -> Any? {
        
        line = expression.operatorToken.line
        
        if let left = try evaluate(expression.left) as? Int {
            try emitBytes(0x01, integerToBytes(left)[0], integerToBytes(left)[1])
        }
            
        if let right = try evaluate(expression.right) as? Int {
            try emitBytes(0x01, integerToBytes(right)[0], integerToBytes(right)[1])
        }
        
        switch expression.operatorToken.type {
            
        case .plus:
            try emitBytes(0x02)
            
        case .minus:
            try emitBytes(0x03)
            
        case .star:
            try emitBytes(0x04)
            
        case .slash:
            try emitBytes(0x05)
            
        default:
            return nil
        }
        
        return nil
    }
    
    /// Converts an integer value to an array of bytes.
    ///
    /// - Parameter value: The integer value to convert.
    /// - Returns: An array of bytes representing the integer value.
    private func integerToBytes(_ value: Int) -> [UInt8] {
        
        var integerValue = value
        let byteCount = MemoryLayout.size(ofValue: integerValue)

        var result = [UInt8](repeating: 0, count: byteCount)

        withUnsafeBytes(of: &integerValue) { rawBuffer in
            for i in 0..<byteCount {
                result[i] = rawBuffer[i]
            }
        }

        return result
    }
}
