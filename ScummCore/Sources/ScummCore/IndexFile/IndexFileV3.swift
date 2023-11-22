//
//  IndexFileV3.swift
//  
//
//  Created by Michael Borgmann on 18/09/2023.
//

import Foundation

class IndexFileV3: IndexFile {
    
    var indexFileURL: URL
    
    var roomNames: [RoomName]?
    
    var resources: Resources?
    
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
    
    internal func readIndexFile(_ fileURL: URL) throws {
        
        let scummFile = try ScummFile(fileURL: fileURL, encryptionKey: 0xff)
        
        let _ = try scummFile.consumeUInt16     // NOTE: value 'magic' isn't used in v3
        
        let readAndMove = { () -> Int in
            
            let itemCount: Int
            let itemSize: Int
            
            switch scummFile.currentPosition {
            
            case 2:
                itemCount = Int(try scummFile.consumeUInt16)
                itemSize = 4        // NOTE: V2 itemSize = 1
                
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
