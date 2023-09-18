//
//  ScummFile.swift
//  
//
//  Created by Michael Borgmann on 28/08/2023.
//

import Foundation

/// A utility class for reading data from files in the Scumm game engine.
///
/// This class provides methods for reading various data types from files. It is designed to be used in a
/// cooperative multitasking environment, where tasks voluntarily yield control to other tasks. Due to the
/// cooperative nature of multitasking, the synchronization requirements for thread safety might be different
/// compared to traditional multithreaded environments. The use of synchronization mechanisms like locks should
/// be evaluated based on the concurrency level, task behavior, and performance considerations specific to
/// the cooperative multitasking environment.
///
/// To ensure thread safety, this class employs synchronization mechanisms when necessary. For example, the
/// `currentPosition` property is synchronized using a lock (`currentPositionLock`) to prevent data inconsistencies
/// and race conditions when accessed and modified by multiple tasks concurrently.
class ScummFile {
    
    /// The URL of the file being accessed by the instance.
    private let fileURL: URL
    
    /// The data of the file loaded into memory.
    private let fileData: Data
    
    /// The current byte offset within the data file.
    ///
    /// This property tracks the position of the file pointer within the data file.
    /// It is used for managing reading, advancing, and seeking operations.
    ///
    /// You can update this property using the `move(to:)` method.
    ///
    /// - Note: Initialized to zero when the `ScummFile` instance is created.
    ///
    internal var currentPosition = 0
    
    /// A lock used for synchronizing access to the `currentPosition` property.
    ///
    /// This lock is used to ensure thread safety when accessing and modifying the `currentPosition`
    /// property within the `ScummFile` class. It prevents multiple threads from concurrently accessing
    /// and modifying the property, helping to avoid data inconsistencies and race conditions.
    private let currentPositionLock = NSLock()
    
    /// Initializes a `ScummFile` instance by loading the data of a file from a given URL.
    /// - Parameter fileURL: The URL of the file to be loaded.
    /// - Throws: An error of type `ScumeCoreError` if loading the file data fails.
    init(fileURL: URL) throws {
        
        self.fileURL = fileURL
        self.fileData = try Data(contentsOf: fileURL)
    }
    
    /// A Boolean indicating whether the current file position is at or beyond the end of the data file.
    ///
    /// - Returns: `true` if the file position is at or beyond the end of the data file; otherwise, `false`.
    var isEndOfFile: Bool {
        currentPosition >= fileData.count
    }
    
    /// Reads an unsigned 32-bit integer in big-endian byte order from the current position within the data buffer.
    ///
    /// - Returns: The read 32-bit integer.
    /// - Throws: An error of type `ScumeCoreError` if there is insufficient data available for reading.
    ///
    /// This property ensures thread safety when accessed by multiple tasks concurrently
    /// in a cooperative multitasking environment. It combines the action of reading an
    /// unsigned 32-bit integer  in big-endian byte order and advancing the position.
    ///
    var readUInt32BE: UInt32 {
        
        get throws {
            
            currentPositionLock.lock()
            defer { currentPositionLock.unlock() }
            
            guard fileData.count - currentPosition >= 4 else {
                throw ScummCoreError.insufficientData
            }
            
            // NOTE: The scratch buffer provides more safety as trade of for performance due to the copy, in contrast to the direct access.
            let data = fileData[currentPosition..<(currentPosition + 4)]
            let uint32 = data.withUnsafeBytes { buffer -> UInt32 in
                
                var value = UInt32.zero
                
                return withUnsafeMutableBytes(of: &value) { scratch in
                    scratch.copyBytes(from: buffer.prefix(MemoryLayout<UInt32>.size))
                    return scratch.load(as: UInt32.self)
                }
            }
            
            return uint32.bigEndian
        }
    }
    
    /// Reads an unsigned 32-bit integer in little-endian byte order from the current position within the data buffer..
    ///
    /// - Returns: The read 32-bit integer.
    /// - Throws: An error of type `ScumeCoreError` if there is insufficient data available for reading.
    ///
    /// This property ensures thread safety when accessed by multiple tasks concurrently
    /// in a cooperative multitasking environment. It combines the action of reading an
    /// unsigned 32-bit integer  in little-endian byte order and advancing the position.
    ///
    var readUInt32LE: UInt32 {
        
        get throws {
            
            currentPositionLock.lock()
            defer { currentPositionLock.unlock() }
            
            guard fileData.count - currentPosition >= 4 else {
                throw ScummCoreError.insufficientData
            }
            
            let uint32 = fileData[currentPosition..<(currentPosition + 4)].withUnsafeBytes { pointer in
                pointer.load(as: UInt32.self)
            }
            
            return uint32.littleEndian
        }
    }
    
    /// Reads an unsigned 16-bit integer in big-endian byte order from the current position within the data buffer..
    ///
    /// - Returns: The read 16-bit integer.
    /// - Throws: An error of type `ScumeCoreError` if there is insufficient data available for reading.
    ///
    /// This property ensures thread safety when accessed by multiple tasks concurrently
    /// in a cooperative multitasking environment. It combines the action of reading an
    /// unsigned 16-bit integer  in big-endian byte order and advancing the position.
    ///
    var readUInt16BE: UInt16 {
        
        get throws {
            
            currentPositionLock.lock()
            defer { currentPositionLock.unlock() }
            
            guard fileData.count - currentPosition >= 2 else {
                throw ScummCoreError.insufficientData
            }
            
            // NOTE: The direct access is a trade off for performance over security, in contrast to the scratch buffer.
            let uint16 = try fileData[currentPosition..<(currentPosition + 2)].withUnsafeBytes { buffer in
                
                guard let pointer = buffer.baseAddress?.assumingMemoryBound(to: UInt16.self) else {
                    throw ScummCoreError.invalidPointer
                }
                
                return pointer.pointee
            }
            
            return uint16.bigEndian
        }
    }
    
    /// Reads an unsigned 16-bit integer in little-endian byte order from the current position within the data buffer..
    ///
    /// - Returns: The read 16-bit integer.
    /// - Throws: An error of type `ScumeCoreError` if there is insufficient data available for reading.
    ///
    /// This property ensures thread safety when accessed by multiple tasks concurrently
    /// in a cooperative multitasking environment. It combines the action of reading an
    /// unsigned 16-bit integer  in little-endian byte order and advancing the position.
    ///
    var readUInt16LE: UInt16 {
        
        get throws {
            
            currentPositionLock.lock()
            defer { currentPositionLock.unlock() }
            
            guard fileData.count - currentPosition >= 2 else {
                throw ScummCoreError.insufficientData
            }
            
            // NOTE: The direct access is a trade off for performance over security, in contrast to the scratch buffer.
            let uint16 = try fileData[currentPosition..<(currentPosition + 2)].withUnsafeBytes { buffer in
                
                guard let pointer = buffer.baseAddress?.assumingMemoryBound(to: UInt16.self) else {
                    throw ScummCoreError.invalidPointer
                }
                
                return pointer.pointee
            }
            
            return uint16.littleEndian
        }
    }
    
    /// Reads an unsigned 8-bit integer from the current position within the data buffer.
    ///
    /// - Returns: The read 8-bit integer.
    /// - Throws: An error of type `ScumeCoreError` if there is insufficient data available for reading.
    ///
    /// This property ensures thread safety when accessed by multiple tasks concurrently
    /// in a cooperative multitasking environment. It combines the action of reading an
    /// unsigned 8-bit integer and advancing the position.
    ///
    var readUInt8: UInt8 {
        
        get throws {
            
            currentPositionLock.lock()
            defer { currentPositionLock.unlock() }
            
            guard fileData.count - currentPosition >= 1 else {
                throw ScummCoreError.insufficientData
            }
            
            let uint8 = fileData[currentPosition]
            
            return uint8
        }
    }
    
    /// Adjusts the current position within the in-memory data buffer.
    ///
    /// Use this method to change the current position within the data buffer,
    /// which determines the byte offset for subsequent read and write operations.
    ///
    /// - Parameter newPosition: The new absolute position to move to within the data buffer.
    /// - Throws: An error of type `ScumeCoreError` if the specified new position is out of bounds.
    ///
    /// - Note: The `currentPosition` property is updated to the new position, and subsequent
    ///   read or write operations will occur starting from this updated position.
    ///
    func move(to newPosition: Int) throws {
        
        guard newPosition <= fileData.count else {
            throw ScummCoreError.insufficientData
        }
        
        currentPosition = newPosition
    }
    
    /// Reads an unsigned 8-bit integer from the current position within the data buffer,
    /// advances the position by one, and returns the read value.
    ///
    /// - Returns: The read unsigned 8-bit integer value.
    /// - Throws: An error of type `ScumeCoreError` if there is insufficient data available for reading.
    ///
    /// Thread safety is guaranteed by the `readUInt8` property.
    ///
    var consumeUInt8: UInt8 {
        
        get throws {
            
            guard currentPosition < fileData.count else {
                throw ScummCoreError.insufficientData
            }
            
            let uint8 = try readUInt8
            currentPosition += 1
            
            return uint8
        }
    }
    
    /// Reads an unsigned 8-bit integer from the current position within the data buffer,
    /// advances the position by one, and returns the read value.
    ///
    /// - Returns: The read unsigned 8-bit integer value.
    /// - Throws: An error of type `ScumeCoreError` if there is insufficient data available for reading.
    ///
    /// Thread safety is guaranteed by the `readUInt32BE` property.
    ///
    var consumeUInt32BE: UInt32 {
        
        get throws {
            
            guard currentPosition + 4 <= fileData.count else {
                throw ScummCoreError.insufficientData
            }
            
            let uint32 = try readUInt32BE
            currentPosition += 4
            
            return uint32
        }
    }
    
    /// Reads an unsigned 32-bit integer in little-endian byte order from the current position within the data buffer,
    /// advances the position by four bytes, and returns the read value.
    ///
    /// - Returns: The read unsigned 32-bit integer value.
    /// - Throws: An error of type `ScumeCoreError` if there is insufficient data available for reading.
    ///
    /// Thread safety is guaranteed by the `readUInt32LE` property.
    ///
    var consumeUInt32LE: UInt32 {
        
        get throws {
            
            guard currentPosition + 4 <= fileData.count else {
                throw ScummCoreError.insufficientData
            }
            
            let uint32 = try readUInt32LE
            currentPosition += 4
            
            return uint32
        }
    }
    
    /// Reads an unsigned 16-bit integer in big-endian byte order from the current position within the data buffer,
    /// advances the position by two bytes, and returns the read value.
    ///
    /// - Returns: The read unsigned 16-bit integer value.
    /// - Throws: An error of type `ScumeCoreError` if there is insufficient data available for reading.
    ///
    /// Thread safety is guaranteed by the `readUInt16BE` property.
    ///
    var consumeUInt16BE: UInt16 {
        
        get throws {
            
            guard currentPosition + 2 <= fileData.count else {
                throw ScummCoreError.insufficientData
            }
            
            let uint16 = try readUInt16BE
            currentPosition += 2
            
            return uint16
        }
    }
    
    /// Reads an unsigned 16-bit integer in little-endian byte order from the current position within the data buffer,
    /// advances the position by two bytes, and returns the read value.
    ///
    /// - Returns: The read unsigned 16-bit integer value.
    /// - Throws: An error of type `ScumeCoreError` if there is insufficient data available for reading.
    ///
    /// Thread safety is guaranteed by the `readUInt16LE` property.
    ///
    var consumeUInt16LE: UInt16 {
        get throws {
            
            guard currentPosition + 2 <= fileData.count else {
                throw ScummCoreError.insufficientData
            }
            
            let uint16 = try readUInt16LE
            currentPosition += 2
            
            return uint16
        }
    }
}
