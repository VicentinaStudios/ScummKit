//
//  ChunkError.swift
//  
//
//  Created by Michael Borgmann on 04/01/2024.
//

import Foundation

/// An enumeration representing errors that can occur in the `Chunk` class.
enum ChunkError: LocalizedError, Equatable {
    
    /// - `outOfBounds`: Error indicating an attempt to access data beyond the valid range.
    ///
    ///   - Parameters:
    ///     - type: The type of data being accessed.
    ///     - offset: The offset at which the access was attempted.
    ///     - size: The total size of the data in the chunk.
    case outOfBounds(_ type: String, _ offset: Int, _ size: Int)
    
    /// - `insufficientBytes`: Error indicating there are not enough bytes available for a complete operation.
    ///
    ///   - Parameters:
    ///     - type: The type of data being accessed.
    ///     - offset: The offset at which the access was attempted.
    ///     - size: The total size of the data in the chunk.
    case insufficientBytes(_ type: String, _ offset: Int, _ size: Int)
    
    /// - `invalidLineNumber`: Error indicating an invalid line number.
    ///
    ///   - Parameters:
    ///     - line: The invalid line number.
    case invalidLineNumber(_ line: Int)
    
    /// - `invalidConstantIndex`: Error indicating an invalid constant index.
    ///
    ///   - Parameters:
    ///     - index: The invalid constant index.
    ///     - count: The total number of constants in the chunk.
    case invalidConstantIndex(_ index: Int, _ count: Int)
    
    /// A human-readable description of the error.
    var errorDescription: String? {
        
        switch self {
            
        case .outOfBounds:
            return "Out of Bounds"
            
        case .insufficientBytes:
            return "Insufficient Bytes"
            
        case .invalidLineNumber:
            return "Invalid Line Number"
            
        case .invalidConstantIndex:
            return "Invalid Constant Index"
        }
    }
    
    /// A localized message describing what caused the failure.
    var failureReason: String? {
        
        switch self {
            
        case .outOfBounds(let type, let offset, let size):
            return "Reading '\(type)' from chunk at offset @\(offset) failed. Total chunk size: \(size)"
            
        case .insufficientBytes(let type, let offset, let size):
            return "Reading '\(type)' from chunk at offset @\(offset) failed. Insufficient bytes for a complete \(type). Total chunk size: \(size)"
        
        case .invalidLineNumber(let line):
            return "Line number must be non-negative, but is '\(line)'."
            
        case .invalidConstantIndex(let index, let count):
            return "Constant index @\(index) is out of bounds. Total constants count: \(count)."
        }
    }
    
    /// A localized recovery suggestion to resolve the error.
    var recoverySuggestion: String? {
        
        switch self {
            
        case .outOfBounds(_, _, let size):
            return "Ensure the offset is within the valid range (0 to \(size - 1))."
            
        case .insufficientBytes(let type, _, let size):
            return "Ensure the offset is within the valid range (0 to \(size - 2)) for reading \(type)s. Verify there are enough bytes available for the operation."
            
        case .invalidLineNumber(_):
            return "Please provide a valid non-negative line number when writing to the chunk."
            
        case .invalidConstantIndex(_, let count):
            return "Please ensure the constant index is within the valid range (0 to \(count - 1))."
        }
    }
}
