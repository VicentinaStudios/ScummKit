//
//  File.swift
//  
//
//  Created by Michael Borgmann on 18/09/2023.
//

import Foundation

import Foundation


/// A concrete implementation of the `IndexFile` protocol for SCUMM game version 2.
///
/// This class reads and processes the index file for SCUMM games of version 2.
/// It extracts information about the number of global objects, rooms, costumes, scripts, and sounds
/// from the index file.
///
/// - Parameters:
///     - gameDirectoryURL: The URL of the game directory containing the index file.
///
/// - Throws:
///     - `ScummCoreError.emptyDirectory`: If the game directory is empty.
///     - `ScummCoreError.noIndexFileFound`: If the index file is not found in the game directory.
///     - Errors from reading and processing the index file.
///
/// - SeeAlso: `IndexFile`
class IndexFileV2: IndexFile {
    
    /// The URL of the index file.
    var indexFileURL: URL
    
    /// Initializes the `IndexFileV2` instance by reading and processing the index file.
    ///
    /// - Parameters:
    ///     - gameDirectoryURL: The URL of the game directory containing the index file.
    ///
    ///  - Throws:
    ///     - `ScummCoreError.emptyDirectory`: If the game directory is empty.
    ///     - `ScummCoreError.noIndexFileFound`: If the index file is not found in the game directory.
    ///     - Errors from reading and processing the index file.
    required init(at gameDirectoryURL: URL) throws {
        
        guard let directoryContent = FileUtils.directoryContent(in: gameDirectoryURL)
        else {
            throw ScummCoreError.emptyDirectory(gameDirectoryURL.path)
        }
        
        guard let matchedURL = directoryContent.filter({ $0.lastPathComponent == "00.LFL" }).first
        else {
            throw ScummCoreError.noIndexFileFound(gameDirectoryURL.path)
        }
        
        indexFileURL = matchedURL
        
        try readIndexFile(indexFileURL)
    }
    
    /// Reads and processes the index file to extract resource information.
    ///
    /// This function reads and decrypts the index file to determine the number of global
    /// objects, rooms, costumes, scripts, and sounds used in the SCUMM game.
    ///
    /// - Throws:
    ///     - Errors from reading and processing the index file.
    internal func readIndexFile(_ fileURL: URL) throws {
        
        let scummFile = try ScummFile(fileURL: fileURL, encryptionKey: 0xff)
        
        _ = try scummFile.consumeUInt16             // the `magic` number
        
        let readAndMove = { () -> Int in
            
            let itemCount: Int
            let itemSize: Int
            
            switch scummFile.currentPosition {
            
            case 2:
                itemCount = Int(try scummFile.consumeUInt16)
                itemSize = 1        // NOTE: V3 itemSize = 4
                
            default:
                itemCount = Int(try scummFile.consumeUInt8)
                itemSize = 3
            }
            
            let nextBlock = itemCount * itemSize + scummFile.currentPosition
            try scummFile.move(to: nextBlock)
            
            return itemCount
        }
        
        GlobalResource.numberOfGlobalObject = try readAndMove()
        GlobalResource.numberOfRooms = try readAndMove()
        GlobalResource.numberOfCostumes = try readAndMove()
        GlobalResource.numberOfScripts = try readAndMove()
        GlobalResource.numberOfSounds = try readAndMove()
    }
}
