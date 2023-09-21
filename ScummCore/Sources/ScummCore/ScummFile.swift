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
    
    /// The encryption key for XOR decryption.
    var encryptionKey: (any BinaryInteger)?
    
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
    init(fileURL: URL, encryptionKey: (any BinaryInteger)? = nil) throws {
        
        self.fileURL = fileURL
        self.fileData = try Data(contentsOf: fileURL)
        self.encryptionKey = encryptionKey
    }
    
    /// A Boolean indicating whether the current file position is at or beyond the end of the data file.
    ///
    /// - Returns: `true` if the file position is at or beyond the end of the data file; otherwise, `false`.
    var isEndOfFile: Bool {
        currentPosition >= fileData.count
    }
    
    /// Reads an unsigned 32-bit integer from the current position within the data buffer.
    ///
    /// - Returns: The read 32-bit integer.
    /// - Throws: An error of type `ScumeCoreError` if there is insufficient data available for reading.
    ///
    /// This property ensures thread safety when accessed by multiple tasks concurrently
    /// in a cooperative multitasking environment. It combines the action of reading an
    /// unsigned 32-bit integer and advancing the position.
    ///
    var readUInt32: UInt32 {
        
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
                    var uint32 = scratch.load(as: UInt32.self)
                    
                    if let encryptionKey = encryptionKey {
                        uint32 = uint32.xorDecrypt(key: encryptionKey)
                    }
                    
                    return uint32
                }
            }
            
            return uint32
        }
    }
    
    /// Reads an unsigned 16-bit integer  from the current position within the data buffer..
    ///
    /// - Returns: The read 16-bit integer.
    /// - Throws: An error of type `ScumeCoreError` if there is insufficient data available for reading.
    ///
    /// This property ensures thread safety when accessed by multiple tasks concurrently
    /// in a cooperative multitasking environment. It combines the action of reading an
    /// unsigned 16-bit integer and advancing the position.
    ///
    var readUInt16: UInt16 {
        
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
                
                var uint16 = pointer.pointee
                
                if let encryptionKey = encryptionKey {
                    uint16 = uint16.xorDecrypt(key: encryptionKey)
                }
                
                return uint16
            }
            
            return uint16
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
            
            var uint8 = fileData[currentPosition]
            
            if let encryptionKey = encryptionKey {
                uint8 = uint8.xorDecrypt(key: encryptionKey)
            }
            
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
    var consumeUInt32: UInt32 {
        
        get throws {
            
            guard currentPosition + 4 <= fileData.count else {
                throw ScummCoreError.insufficientData
            }
            
            let uint32 = try readUInt32
            currentPosition += 4
            
            return uint32
        }
    }
    
    /// Reads an unsigned 16-bit integer from the current position within the data buffer,
    /// advances the position by two bytes, and returns the read value.
    ///
    /// - Returns: The read unsigned 16-bit integer value.
    /// - Throws: An error of type `ScumeCoreError` if there is insufficient data available for reading.
    ///
    /// Thread safety is guaranteed by the `readUInt16BE` property.
    ///
    var consumeUInt16: UInt16 {
        
        get throws {
            
            guard currentPosition + 2 <= fileData.count else {
                throw ScummCoreError.insufficientData
            }
            
            let uint16 = try readUInt16
            currentPosition += 2
            
            return uint16
        }
    }
    
    /// Reads a specified number of bytes from the current position within the data buffer.
    ///
    /// - Parameter count: The number of bytes to read.
    /// - Returns: An array of bytes read from the data buffer.
    /// - Throws: An error of type `ScumeCoreError` if there is insufficient data available for reading.
    ///
    /// After reading, the `currentPosition` is advanced by the number of bytes read.
    func read(bytes count: Int) throws -> [UInt8] {
        
        currentPositionLock.lock()
        defer { currentPositionLock.unlock() }
        
        guard currentPosition + count <= fileData.count else {
            throw ScummCoreError.insufficientData
        }
        
        let data = fileData[currentPosition..<(currentPosition + count)]
            .map {
                
                if let encryptionKey = encryptionKey {
                    return $0.xorDecrypt(key: encryptionKey)
                }
                
                return $0
            }
        
        currentPosition += count
        
        return Array(data)
    }
}
