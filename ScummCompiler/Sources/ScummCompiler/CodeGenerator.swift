//
//  CodeGenerator.swift
//
//
//  Created by Michael Borgmann on 02/01/2024.
//

import Foundation

class CodeGenerator {
    
    // MARK: Properties
    
    private var chunk: Chunk
    
    // MARK: Lifecycle
    
    init(with chunk: Chunk) {
        self.chunk = chunk
    }
    
    // MARK: Actions
    
    func generateByteCode(expression: Expression) throws -> Chunk {
        
        _ = try evaluate(expression)
        
        return chunk
    }
    
    // MARK: Helper
    
    private func emitBytes(_ bytes: UInt8...) {
        bytes.forEach { chunk.write(byte: $0, line: 2) }
    }
    
    private func makeConstant(_ value: Value) -> Int {
        
        let constant = chunk.addConstant(value: value)
        
        if constant > UInt8.max {
            fatalError("Too many constants in one chunk.")
        }
        
        return constant
    }
    
    private func evaluate(_ expression: Expression) throws -> Any? {
        try expression.accept(visitor: self)
    }
}

extension CodeGenerator: ExpressionVisitor {
    
    func visitLiteralExpr(_ expression: Literal) -> Any? {
        expression.value
    }
    
    func visitGroupingExpr(_ expression: Grouping) throws -> Any? {
        try evaluate(expression)
        return nil
    }
    
    func visitUnaryExpr(_ expression: Unary) throws -> Any? {
        
        guard
            let right = try evaluate(expression.right) as? Int
        else {
            throw CompilerError.compileError
        }
        
        switch expression.operatorToken.type {
        
        case .minus:
            
            emitBytes(Opcode.negate.rawValue)
            
        default:
            return nil
        }
        
        return nil
    }
    
    func visitBinaryExpr(_ expression: Binary) throws -> Any? {
        
        let left = try evaluate(expression.left)
        let right = try evaluate(expression.right)
        
        switch expression.operatorToken.type {
            
        case .minus:
            emitBytes(Opcode.subtract.rawValue)
            
        case .slash:
            emitBytes(Opcode.divide.rawValue)
            
        case .star:
            emitBytes(Opcode.multiply.rawValue)
            
        case .plus:
            emitBytes(Opcode.add.rawValue)
            
        default:
            return nil
        }
        
        
        
        return nil
    }
}
