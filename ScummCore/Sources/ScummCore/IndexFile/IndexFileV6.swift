//
//  File.swift
//  
//
//  Created by Michael Borgmann on 18/09/2023.
//

import Foundation

class IndexFileV6: IndexFile {
    
    var indexFileURL: URL
    
    required init(at gameDirectoryURL: URL) throws {
        
        guard let directoryContent = FileUtils.directoryContent(in: gameDirectoryURL)
        else {
            throw ScummCoreError.emptyDirectory(gameDirectoryURL.path)
        }
        
        guard let matchedURL = directoryContent.filter({ $0.pathExtension == "000" || $0.pathExtension == "SM0" }).first
        else {
            throw ScummCoreError.noIndexFileFound(gameDirectoryURL.path)
        }
        
        indexFileURL = matchedURL
        
        try readIndexFile(indexFileURL)
    }

    
    internal func readIndexFile(_ fileURL: URL) throws {
        /*
        let scummFile = try ScummFile(fileURL: fileURL)
        
        while !scummFile.isEndOfFile {
            
            let blockType = try scummFile.consumeUInt32BE.xorDecrypt(key: 0x69)
            let itemSize = try scummFile.consumeUInt32BE.xorDecrypt(key: 0x69)
            
            switch BlockType(rawValue: blockType.string) {
            
            case .directoryOfRooms:
                GlobalResourceTable.numberOfRooms = Int(try scummFile.readUInt16LE.xorDecrypt(key: 0x69))
                
            case .directoryOfScripts:
                GlobalResourceTable.numberOfScripts = Int(try scummFile.readUInt16LE.xorDecrypt(key: 0x69))
                
            case .directoryOfSounds:
                GlobalResourceTable.numberOfSounds = Int(try scummFile.readUInt16LE.xorDecrypt(key: 0x69))
                
            case .directoryOfCostumes:
                GlobalResourceTable.numberOfCostumes = Int(try scummFile.readUInt16LE.xorDecrypt(key: 0x69))
                
            case .directoryOfObjects:
                GlobalResourceTable.numberOfGlobalObject = Int(try scummFile.readUInt16LE.xorDecrypt(key: 0x69))
                
            case .unknown:
                break
            }
            
            try scummFile.move(to: Int(itemSize) + scummFile.currentPosition - 8)
        }
        */
    }
}
