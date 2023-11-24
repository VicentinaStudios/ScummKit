//
//  IndexFileV5.swift
//
//
//  Created by Michael Borgmann on 17/09/2023.
//

import Foundation

/// Represents an IndexFileV5, responsible for reading SCUMM index files.
class IndexFileV5: IndexFile {
    
    /// The SCUMM file being read.
    private let scummFile: ScummFile
    
    /// The URL of the index file.
    var indexFileURL: URL
    
    /// List of the room names in a SCUMM game.
    var roomNames: [RoomName]?
    
    /// List of available resources in a SCUMM game, including rooms, scripts, sounds, costumes, characters, and objects.
    var resources: Resources?
    
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
        
        setupMaximumValues()
    }
    
    /// Reads and processes an index file to create a Resources object.
    ///
    /// This method reads an index file located at the specified `fileURL` and processes its contents to create a `Resources` object containing various resource types.
    ///
    /// - Parameters:
    ///   - fileURL: The URL of the index file to be processed.
    ///
    /// - Throws:
    ///   - `ScummCoreError.unknownBlock` if an unknown block type is encountered in the index file.
    ///   - `ScummCoreError.missingResource` if one or more required resource types are missing in the index file.
    ///
    /// - SeeAlso: `createResources(from:)`
    internal func readIndexFile(_ fileURL: URL) throws {
        
        var resourceData: [BlockType: [Resources.DirectoryEntry]] = [:]
        
        while !scummFile.isEndOfFile {
            
            let blockType = try scummFile.consumeUInt32.bigEndian
            let itemSize = try scummFile.consumeUInt32.bigEndian
            
            let type = BlockType(rawValue: blockType.string)
            
            guard type != .unknown else {
                throw ScummCoreError.unknownBlock(blockType.string)
            }
            
            if let resourceEntries = try readIndexBlock(
                blockType: type,
                itemSize: Int(itemSize)
            ) {
                resourceData[type] = resourceEntries
            }
        }
        
        resources = try createResources(from: resourceData)
    }
    
    /// Reads room numbers and offsets from the SCUMM index file.
    ///
    /// - Throws: Throws an error if there is an issue while reading the room numbers and offsets.
    private func readIndexBlock(blockType: BlockType, itemSize: Int) throws -> [Resources.DirectoryEntry]? {
        
        switch blockType {
            
        case .roomNames:
            try readRoomNames()
            
        case .maximumValues:
            try readMaximumValues()
            
        default:
            return try readDirectory()
        }
        
        return nil
    }
    
    /// Reads room names and associated room numbers from the SCUMM index file.
    ///
    /// - Throws: Throws an error if there is an issue while reading room names.
    private func readRoomNames() throws {
        
        while let roomIndex = try? scummFile.consumeUInt8 {
            
            guard roomIndex != 0 else {
                break
            }
            
            let bytes = try scummFile.read(bytes: 9)
                .map { $0.xorDecrypt(key: 0xff) }
            
            let roomNumber = Int(roomIndex)
            
            guard
                let roomName = String(bytes: bytes, encoding: .utf8)?
                    .trimmingCharacters(in: CharacterSet(charactersIn: "\0"))
            else {
                throw ScummCoreError.decodeFailure("room name", bytes.map { String($0) }.joined())
            }
            
            let room = RoomName(number: roomNumber, name: roomName)
            if roomNames?.append(room) == nil {
                roomNames = [room]
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
    private func readDirectory() throws -> [Resources.DirectoryEntry] {
        
        let numberOfItems = try scummFile.consumeUInt16
        
        let roomNumbers = try readValues(count: Int(numberOfItems), readBlock: {
            Int(try scummFile.consumeUInt8)
        })
        
        let offsets = try readValues(count: Int(numberOfItems), readBlock: {
            Int(try scummFile.consumeUInt32)
        })
        
        return Resources.DirectoryEntry.convert(roomNumbers: roomNumbers, offsets: offsets)
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

extension IndexFileV5 {

    /// Creates a `Resources` object from a dictionary of resource entries.
    ///
    /// This method takes a dictionary containing resource entries for various resource types and creates a `Resources` object from them.
    ///
    /// - Parameters:
    ///   - resourceData: A dictionary containing resource entries categorized by `BlockType`.
    ///
    /// - Returns: A `Resources` object containing various resource types.
    ///
    /// - Throws:
    ///   - `ScummCoreError.missingResource` if any of the required resource types are missing in the `resourceData` dictionary.
    private func createResources(from resourceData: [BlockType: [Resources.DirectoryEntry]]) throws -> Resources {
        
        let resourceTypes = [
            BlockType.directoryOfRooms,
            .directoryOfScripts,
            .directoryOfSounds,
            .directoryOfCostumes,
            .directoryOfCharacterSets,
            .directoryOfObjects
        ]
        
        try resourceTypes.forEach { type in
            guard resourceData[type] != nil else {
                throw ScummCoreError.missingResource(type.rawValueV5, "index file")
            }
        }
        
        return Resources(
            rooms: resourceData[.directoryOfRooms]!,
            scripts: resourceData[.directoryOfScripts]!,
            sounds: resourceData[.directoryOfSounds]!,
            costumes: resourceData[.directoryOfCostumes]!,
            characters: resourceData[.directoryOfCharacterSets]!,
            objects: resourceData[.directoryOfObjects]!
        )
    }
}

extension IndexFileV5 {
    
    private func setupMaximumValues() {
        
        // Set the number of variables to 800
        GlobalResource.numberOfVariables = 800
        
        // Set the number of bit variables to 4096
        GlobalResource.numberOfBitVariable = 4096   // 2048
        
        // Set the number of local objects to 200
        GlobalResource.numberOfLocalObjects = 200
        
        // Set the number of arrays to 50
        GlobalResource.numberOfArrays = 50
        
        // Set the number of verbs to 100
        GlobalResource.numberOfVerbs = 100
        
        // Set the number of new names to 150
        GlobalResource.numberOfNewNames = 150
        
        // Set the number of character sets to 9
        GlobalResource.numberOfCharacterSets = 9
        
        // Set the number of inventory objects to 80
        GlobalResource.numberOfInventoryObjects = 80
        
        // Set the number of global scripts to 200
        GlobalResource.numberOfGlobalScripts = 200
        
        // Set the number of global scripts to 200
        GlobalResource.numberOfFLObjects = 50
        
        // Set the number of shadow palette size to 200
        GlobalResource.shadowPaletteSize = 256
    }
}
