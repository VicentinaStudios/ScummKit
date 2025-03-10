//
//  ScummStoreDevData.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 13.10.21.
//

import Foundation

extension ScummStore {
    
    static func block(name: BlockType = BlockType.CLUT, with size: UInt32 = 776, at offset: UInt32 = 0x3b5) -> Block {
        Block(for: name.rawValue, with: size, at: offset)
    }
    
    static func buffer(at url: URL, for block: Block = ScummStore.block(), xor: UInt8 = 0x69) -> [UInt8] {
        try! block.read(from: url).byteBuffer.xor(with: xor)
    }

    static var gameURL: URL {
        URL(fileURLWithPath: gamePath!, isDirectory: true)
    }

    static var indexFileURL: URL {
        let path = "\(gamePath!)/\(indexFile!)"
        return URL(fileURLWithPath: path, isDirectory: true)
    }
    
    static var dataFileURL: URL {
        let path = "\(gamePath!)/\(dataFile!)"
        return URL(fileURLWithPath: path, isDirectory: true)
    }
    
    static var gamePath: String? {
        Bundle.main.infoDictionary?["SCUMM Game Path"] as? String
    }
    
    static var indexFile: String? {
        Bundle.main.infoDictionary?["Index File"] as? String
    }
    
    static var dataFile: String? {
        Bundle.main.infoDictionary?["Data File"] as? String
    }
  
    func createDevData() throws  {
        
        guard let path = ScummStore.gamePath else {
            return
        }
        
        let url = URL(fileURLWithPath: path, isDirectory: true)
        
        do {
            try readDirectory(at: url)
            
            let urls = scummFiles.map { $0.value.fileURL }
//            scummVersion = ScummVersion.dectect(files: urls)
            
        } catch {
            throw error
        }
        
    }
}
