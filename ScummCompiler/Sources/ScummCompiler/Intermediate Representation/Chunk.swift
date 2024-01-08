//
//  File.swift
//  
//
//  Created by Michael Borgmann on 14/12/2023.
//

import Foundation

/// Represents a numeric value used in the bytecode.
public typealias Value = Int

/// A representation of a chunk of bytecode in the compiler.
///
/// Bytecode chunks are used to store sequences of bytes that represent
/// instructions or data in the compiler's intermediate representation.
///
/// - Note: This class provides basic functionality for adding and retrieving bytes
///   within the chunk.
///
/// Example Usage:
/// ```swift
/// let bytecodeChunk = Chunk()
/// bytecodeChunk.write(byte: 0x01, line: 42)
/// let firstByte = try? bytecodeChunk.read(at: 0)
/// ```
///
/// - SeeAlso: `ChunkError` for potential errors
public class Chunk {
    
    // MARK: Properties
    
    /// The array of bytecode.
    private var code: [UInt8] = []
    
    /// The array storing line information for each bytecode.
    private(set) var lines: [Int] = []
    
    /// The array storing constants used in the bytecode.
    private var constants: [Int] = []
    
    // MARK: Computed Properties
    
    /// The total size of the bytecode chunk.
    public var size: Int { code.count }
    
    /// The starting index of the bytecode array.
    public var codeStart: Array.Index { code.startIndex }
    
    // MARK: Lifecycle
    
    /// Initializes a new instance of `Chunk`.
    public init() { }
}

// MARK: - Read/Write Code

extension Chunk {
    
    /// Writes a byte to the bytecode chunk.
    ///
    /// - Parameters:
    ///   - byte: The byte to be written.
    ///   - line: The line number associated with the byte. This is useful for debugging and tracking source code locations.
    ///
    /// - Throws: `ChunkError.invalidLineNumber` if the line number is negative.
    public func write(byte: UInt8, line: Int) throws {
        
        guard line >= 0 else {
            throw ChunkError.invalidLineNumber(line)
        }
        
        code.append(byte)
        lines.append(line)
    }
    
    /// Reads a byte at a specified offset in the bytecode chunk.
    ///
    /// - Parameters:
    ///    - offset: The offset at which to read the byte.
    ///
    /// - Throws: `ChunkError.outOfBounds` if the offset is invalid.
    ///
    /// - Returns: The byte at the specified offset.
    public func read(at offset: Int) throws -> UInt8 {
        
        guard offset >= 0, offset < code.count else {
            throw ChunkError.outOfBounds("byte", offset, size)
        }
        
        return code[offset]
    }
    
    /// Reads a 16-bit word at a specified offset in the bytecode chunk.
    ///
    /// - Parameters:
    ///    - offset: The offset at which to read the word.
    ///
    /// - Throws:
    ///    - `ChunkError.outOfBounds` if the offset is invalid.
    ///    - `ChunkError.insufficientBytes` if there are not enough bytes to form a word.
    ///
    /// - Returns: The 16-bit word at the specified offset.
    public func readWord(at offset: Int) throws -> Int16 {
        
        guard offset >= 0, offset <= code.count - 1 else {
            throw ChunkError.outOfBounds("word", offset, size)
        }
        
        if offset == code.count - 1 {
            throw ChunkError.insufficientBytes("word", offset, size)
        }
        
        return (Int16(code[offset]) | Int16(code[offset + 1]) << 8)
    }
}

// MARK: - Read/Write Data

extension Chunk {
    
    /// Adds a constant value to the constants array and returns its index.
    ///
    /// - Parameters:
    ///    - value: The constant value to be added.
    ///
    /// - Returns: The index of the added constant.
    public func addConstant(value: Value) -> Int {
        constants.append(value)
        return constants.count - 1
    }
    
    /// Reads a constant value at a specified index in the constants array.
    ///
    /// - Parameters:
    ///    - index: The index at which to read the constant.
    ///
    /// - Throws: `ChunkError.invalidConstantIndex` if the index is invalid.
    ///
    /// - Returns: The constant value at the specified index.
    public func readConstant(at index: Int) throws -> Value {
        
        guard index >= 0, index < constants.count else {
            throw ChunkError.invalidConstantIndex(index, constants.count)
        }
        
        return constants[index]
    }
}
