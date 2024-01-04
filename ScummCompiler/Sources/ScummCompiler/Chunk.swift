//
//  File.swift
//  
//
//  Created by Michael Borgmann on 14/12/2023.
//

import Foundation

/// A representation of a chunk of bytecode in the compiler.
///
/// Bytecode chunks are used to store sequences of bytes that represent
/// instructions or data in the compiler's intermediate representation.
///
/// - Note: This class provides basic functionality for adding and retrieving bytes
///   within the chunk.
///
/// Example Usage:
/// ```
/// let bytecodeChunk = Chunk()
/// bytecodeChunk.write(byte: 0x01)
/// let firstByte = try? bytecodeChunk.read(at: 0)
/// ```
///
/// - SeeAlso: `CompilerError.outOfBounds` for potential errors when reading from the chunk.
public class Chunk {
    
    /// The internal storage for the bytecode.
    private var code: [UInt8]
    
    private(set) var lines: [Int]
    
    private var constants: ValueArray
    
    /// The current size of the bytecode chunk.
    public var size: Int {
        code.count
    }
    
    /// The index representing the start of the bytecode in the chunk.
    public var codeStart: Array.Index {
        code.startIndex
    }
    
    /// Initializes an empty chunk
    public init() {
        code = []
        lines = []
        constants = ValueArray()
    }
    
    /// Adds a byte to the bytecode chunk.
    ///
    /// - Parameter byte: The byte to be added.
    public func write(byte: UInt8, line: Int) {
        code.append(byte)
        lines.append(line)
    }
    
    /// Reads a byte from the bytecode chunk at the specified offset.
    ///
    /// - Parameters:
    ///   - offset: The offset of the byte to read.
    /// - Returns: The byte at the specified offset.
    /// - Throws: `CompilerError.outOfBounds` if the offset is out of bounds.
    public func read(at offset: Int) throws -> UInt8 {
        
        guard offset >= 0, offset < code.count else {
            throw CompilerError.outOfBounds("Chunk", offset, size)
        }
        
        return code[offset]
    }
    
    public func readWord(at offset: Int) throws -> UInt16 {
        
        guard offset >= 0, offset+1 < code.count else {
            throw CompilerError.outOfBounds("Chunk", offset, size)
        }
        
        let word = try code[offset..<offset + 1].withUnsafeBytes { buffer in
            
            guard let pointer = buffer.baseAddress?.assumingMemoryBound(to: UInt16.self) else {
                throw CompilerError.outOfBounds("Chunk", offset, size)
            }
            
            var uint16 = pointer.pointee
            
            return uint16
        }
        
        return word
    }
}

// MARK: Data Segment

extension Chunk {
    
    public func addConstant(value: Value) -> Int {
        constants.write(value: value)
        return constants.count
    }
    
    public func readConstant(byte: Int) -> Value {
        constants.values[byte]
    }
}
