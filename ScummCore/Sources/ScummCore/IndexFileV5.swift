//
//  IndexFileV5.swift
//
//
//  Created by Michael Borgmann on 17/09/2023.
//

import Foundation

class IndexFileV5: IndexFile {
    
    var isIndexFile: (URL) -> Bool = { url in
        url.pathExtension == "000"
    }
    
    var indexFileURL: URL? = nil
    
    required init(at gameDirectoryURL: URL) throws {
        
        guard let matches = FileManager.default
            .enumerator(at: gameDirectoryURL, includingPropertiesForKeys: nil)?
            .allObjects
            .compactMap({ $0 as? URL })
            .filter({ $0.pathExtension == "000" }),
              let fileURL = matches.first
        else {
            throw ScummCoreError.noIndexFileFound(gameDirectoryURL.path)
        }
        
        try readIndexFile(fileURL)
    }
    
    internal func readIndexFile(_ fileURL: URL) throws {
        
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
    }
}
