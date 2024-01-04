//
//  File.swift
//  
//
//  Created by Michael Borgmann on 04/01/2024.
//

import Foundation

class CodeGeneratorSCUMM {
    
    // MARK: Properties
    
    private var chunk: Chunk
    
    // MARK: Lifecycle
    
    init(with chunk: Chunk) {
        self.chunk = chunk
    }
    
    // MARK: Actions
    
    func generateByteCode(expression: Expression) throws -> Chunk {
        
        emitBytes(Opcode.expression.rawValue, 0x02, 0x40)
        
        _ = try evaluate(expression)
        
        emitBytes(0xff)
        
        return chunk
    }
    
    // MARK: Helper
    
    private func emitBytes(_ bytes: UInt8...) {
        bytes.forEach { chunk.write(byte: $0, line: 2) }
    }
    
    private func emitConstant(_ value: Value) {
        emitBytes(Opcode.constant.rawValue, UInt8(makeConstant(value)))
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

extension CodeGeneratorSCUMM: ExpressionVisitor {
    
    func visitLiteralExpr(_ expression: Literal) -> Any? {
        
        return expression.value
    }
    
    func visitGroupingExpr(_ expression: Grouping) throws -> Any? {
        try evaluate(expression.expression)
    }
    
    func visitUnaryExpr(_ expression: Unary) throws -> Any? {
        
        guard
            let right = try evaluate(expression.right) as? Int
        else {
            throw CompilerError.compileError
        }
        
        switch expression.operatorToken.type {
        
        case .minus:
            return -right
            
        default:
            return nil
        }
    }
    
    func visitBinaryExpr(_ expression: Binary) throws -> Any? {
        
        if let left = try evaluate(expression.left) as? Int {
            emitBytes(0x01, integerToBytes(left)[0], integerToBytes(left)[1])
        }
        
        if let right = try evaluate(expression.right) as? Int {
            emitBytes(0x01, integerToBytes(right)[0], integerToBytes(right)[1])
        }
        
        switch expression.operatorToken.type {
            
        case .plus:
            emitBytes(0x02)
            
        case .minus:
            emitBytes(0x03)
            
        case .star:
            emitBytes(0x04)
            
        case .slash:
            emitBytes(0x05)
            
        default:
            return nil
        }
        
        return nil
    }
    
    func integerToBytes(_ value: Int) -> [UInt8] {
        
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
