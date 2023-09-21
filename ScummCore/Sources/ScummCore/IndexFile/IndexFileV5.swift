//
//  IndexFileV5.swift
//
//
//  Created by Michael Borgmann on 17/09/2023.
//

import Foundation

/// Represents an IndexFileV5, responsible for reading SCUMM index files.
class IndexFileV5: IndexFile {
    
    /// The URL of the index file.
    var indexFileURL: URL
    
    /// The SCUMM file being read.
    private let scummFile: ScummFile
    
    /// Initializes an IndexFileV5 instance with the specified game directory URL.
    ///
    /// - Parameters:
    ///   - gameDirectoryURL: The URL of the game directory.
    /// - Throws: Throws an error if the index file or game directory is not found or if there is an issue during initialization.
    required init(at gameDirectoryURL: URL) throws {
        
        guard
            let directoryContent = FileUtils.directoryContent(in: gameDirectoryURL)
        else {
            throw ScummCoreError.emptyDirectory(gameDirectoryURL.path)
        }
        
        guard
            let matchedURL = directoryContent.filter({ $0.pathExtension == "000" }).first
        else {
            throw ScummCoreError.noIndexFileFound(gameDirectoryURL.path)
        }
        
        indexFileURL = matchedURL
        scummFile = try ScummFile(fileURL: indexFileURL, encryptionKey: 0x69)
        
        try readIndexFile(indexFileURL)
    }
    
    /// Reads the SCUMM index file located at the specified URL.
    ///
    /// - Parameter fileURL: The URL of the index file.
    /// - Throws: Throws an error if there is an issue while reading the index file.
    internal func readIndexFile(_ fileURL: URL) throws {
        
        while !scummFile.isEndOfFile {
            
            let blockType = try scummFile.consumeUInt32.bigEndian
            let itemSize = try scummFile.consumeUInt32.bigEndian
            
            guard
                BlockType(rawValue: blockType.string) != .unknown
            else {
                throw ScummCoreError.unknownBlock(blockType.string)
            }
            
            try readIndexBlock(
                blockType: BlockType(rawValue: blockType.string),
                itemSize: Int(itemSize)
            )
        }
    }
    
    /// Reads room numbers and offsets from the SCUMM index file.
    ///
    /// - Throws: Throws an error if there is an issue while reading the room numbers and offsets.
    private func readIndexBlock(blockType: BlockType, itemSize: Int) throws {
        
        switch blockType {
            
        case .roomNames:
            try readRoomNames()
            
        case .maximumValues:
            try readMaximumValues()
            
        case .directoryOfRooms:
            try readDirectory()
            
        case .directoryOfScripts:
            try readDirectory()
            
        case .directoryOfSounds:
            try readDirectory()
            
        case .directoryOfCostumes:
            try readDirectory()
            
        case .directoryOfCharacterSets:
            try readDirectory()
            
        case .directoryOfObjects:
            try readDirectory()
            
        default:
            break
        }
    }
    
    /// Reads room names and associated room numbers from the SCUMM index file.
    ///
    /// - Throws: Throws an error if there is an issue while reading room names.
    private func readRoomNames() throws {
        
        while let room = try? scummFile.consumeUInt8 {
            
            guard room != 0 else {
                break
            }
            
            let bytes = try scummFile.read(bytes: 9)
                .map { $0.xorDecrypt(key: 0xff) }
            
            let roomNumber = Int(room)
            
            guard
                let roomName = String(bytes: bytes, encoding: .utf8)?
                    .trimmingCharacters(in: .whitespacesAndNewlines)
            else {
                throw ScummCoreError.decodeFailure("room name", bytes.map { String($0) }.joined())
            }
                
        }
    }
    
    /// Reads maximum values and updates global resource values from the SCUMM index file.
    ///
    /// - Throws: Throws an error if there is an issue while reading maximum values.
    private func readMaximumValues() throws {
        
        let readMaximumValue = { () -> Int in
            Int(try self.scummFile.consumeUInt16)
        }
        
        // Read and set the number of variables to 800
        GlobalResource.numberOfVariables = try readMaximumValue()
        
        // Unknown value (16)
        _ = try readMaximumValue()
        
        // Read and set the number of bit variables to 2048
        GlobalResource.numberOfBitVariable = try readMaximumValue()
        
        // Read and set the number of local objects to 200
        GlobalResource.numberOfLocalObjects = try readMaximumValue()
        
        // Unknown value (50, new names?)
        _ = try readMaximumValue()
        
        // Read and set the number of character sets
        GlobalResource.numberOfCharacterSets = try readMaximumValue()
        
        // Unknown value (100, verbs)
        _ = try readMaximumValue()
        
        // Unknown value (50, array)
        _ = try readMaximumValue()
        
        // Read and set the number of inventory objects to 80
        GlobalResource.numberOfInventoryObjects = try readMaximumValue()  // 80
        
        // Set other global resource values
        GlobalResource.numberOfArrays = 50
        GlobalResource.numberOfVerbs = 100
        GlobalResource.numberOfNewNames = 150
        GlobalResource.numberOfGlobalScripts = 200
        GlobalResource.shadowPaletteSize = 256
    }
    
    /// Reads a list of room numbers and offsets from the SCUMM index file.
    ///
    /// - Throws: Throws an error if there is an issue while reading room numbers and offsets.
    private func readDirectory() throws {
        
        let numberOfItems = try scummFile.consumeUInt16
        
        let roomNumbers = try readValues(count: Int(numberOfItems), readBlock: {
            Int(try scummFile.consumeUInt8)
        })
        
        let offsets = try readValues(count: Int(numberOfItems), readBlock: {
            Int(try scummFile.consumeUInt32)
        })
    }
}

/// An extension of `IndexFileV5` to provide utility methods.
extension IndexFileV5 {
    
    /// Reads a list of values of type `T` from the SCUMM index file.
    ///
    /// - Parameters:
    ///   - count: The number of values to read.
    ///   - readBlock: A closure that reads a single value of type `T`.
    /// - Throws: Throws an error if there is an issue while reading the values.
    /// - Returns: An array of values of type `T`.
    private func readValues<T>(count: Int, readBlock: () throws -> T) throws -> [T] {
        
        var values: [T] = []
        
        for _ in 0..<count {
            let value = try readBlock()
            values.append(value)
        }
        
        return values
    }
}
