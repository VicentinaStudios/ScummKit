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
class Chunk {
    
    /// The internal storage for the bytecode.
    private var code: [UInt8] = []
    
    /// The current size of the bytecode chunk.
    var size: Int {
        code.count
    }
    
    
    /// Adds a byte to the bytecode chunk.
    ///
    /// - Parameter byte: The byte to be added.
    func write(byte: UInt8) {
        code.append(byte)
    }
    
    /// Reads a byte from the bytecode chunk at the specified offset.
    ///
    /// - Parameters:
    ///   - offset: The offset of the byte to read.
    /// - Returns: The byte at the specified offset.
    /// - Throws: `CompilerError.outOfBounds` if the offset is out of bounds.
    func read(at offset: Int) throws -> UInt8 {
        
        guard offset >= 0, offset < code.count else {
            throw CompilerError.outOfBounds("Chunk", offset, size)
        }
        
        return code[offset]
    }
}
