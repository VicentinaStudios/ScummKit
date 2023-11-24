//
//  IndexFileV4.swift
//  
//
//  Created by Michael Borgmann on 17/09/2023.
//

import Foundation

/// Represents an IndexFileV4, responsible for reading SCUMM index files.
class IndexFileV4: IndexFile {
    
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
            let matchedURL = directoryContent.filter({ $0.lastPathComponent == "000.LFL" }).first
        else {
            throw ScummCoreError.noIndexFileFound(gameDirectoryURL.path)
        }
        
        indexFileURL = matchedURL
        scummFile = try ScummFile(fileURL: indexFileURL)
        
        try readIndexFile(indexFileURL)
    }
    
    internal func readIndexFile(_ fileURL: URL) throws {
        
        var resourceData: [BlockType: [Resources.DirectoryEntry]] = [:]
        
        try scummFile.move(to: 0)
        
        while !scummFile.isEndOfFile {
            
            let itemSize = try scummFile.consumeUInt32
            let blockType = try scummFile.consumeUInt16.bigEndian
            
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
    
    private func readIndexBlock(blockType: BlockType, itemSize: Int) throws -> [Resources.DirectoryEntry]? {
        
        
        switch blockType {
            
        case .roomNames:
            try readRoomNames()
            
//        case .maximumValues:
//            try readMaximumValues()
            
        case .directoryOfObjects:
            return try readGlobalObjects()
            
        default:
            return try readDirectory()
        }
        
        return nil
    }
    
    // NOTE: Same algorithm as v5
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
    
    private func readDirectory() throws -> [Resources.DirectoryEntry] {
        
        let numberOfItems = try scummFile.consumeUInt16
            
        return try (0..<numberOfItems).map { _ in
            
            let roomNumber = try scummFile.consumeUInt8
            let offset = try scummFile.consumeUInt32
            
            return Resources.DirectoryEntry(
                roomNumber: Int(roomNumber),
                offset: Int(offset)
            )
        }
    }
    
    private func readGlobalObjects() throws -> [Resources.DirectoryEntry] {
        
        let numberOfItems = try scummFile.consumeUInt16
            
        return try (0..<numberOfItems).map { _ in
            
            let classData = try scummFile.consumeUInt8
            let bytes = try self.scummFile.read(bytes: 3)
            
            let ownerAndState = UInt32(bytes[0]) << 16 | UInt32(bytes[1]) << 8 | UInt32(bytes[2])
            
            return Resources.DirectoryEntry(
                roomNumber: Int(classData),
                offset: Int(ownerAndState)
            )
        }
    }
}

// NOTE: Same as v5
extension IndexFileV4 {

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
//            .directoryOfCharacterSets,
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
            characters: [],
            objects: resourceData[.directoryOfObjects]!
        )
    }
}
