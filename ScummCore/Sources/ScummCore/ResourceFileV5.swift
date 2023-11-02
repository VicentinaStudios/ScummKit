//
//  File.swift
//  
//
//  Created by Michael Borgmann on 22/09/2023.
//

import Foundation

//"Index file:" "/Users/michael/Desktop/ScummViewer/Monkey1/MONKEY.000"
//"Start script:" 1
//" - Room number:" 10
//" - Offset:" 56344

class ResourceFileV5 {
    
    /// The SCUMM file being read.
    private let scummFile: ScummFile
    
    /// The URL of the index file.
    var resourceFileURL: URL
    
    required init(at gameDirectoryURL: URL) throws {
        
        guard
            let directoryContent = FileUtils.directoryContent(in: gameDirectoryURL)
        else {
            throw ScummCoreError.emptyDirectory(gameDirectoryURL.path)
        }
        
        guard
            let matchedURL = directoryContent.filter({ $0.pathExtension == "001" }).first
        else {
            throw ScummCoreError.noIndexFileFound(gameDirectoryURL.path)
        }
        
        resourceFileURL = matchedURL
        scummFile = try ScummFile(fileURL: resourceFileURL, encryptionKey: 0x69)
    }
    
    func readResource(at resourceOffset: Int, room: Int) throws {
        
        // Seek to LOFF room offset block
        try scummFile.move(to: 17 + (room - 1) * 5)
        
        let roomId = try scummFile.consumeUInt8
        let roomOffset = try scummFile.consumeUInt32
        
        debugPrint(roomId, roomOffset)
        
        try scummFile.move(to: Int(roomOffset) + resourceOffset)
        
        let blockType2 = try scummFile.consumeUInt32.bigEndian
        let itemSize2 = try scummFile.consumeUInt32.bigEndian
        
        debugPrint(blockType2.string, itemSize2)
    }
}
