//
//  Block.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 18.10.21.
//

import Foundation

struct Block: Hashable {
    
    var name: String
    var size: UInt32
    var offset: UInt32
    
    init(for name: BlockType, with size: UInt32, at offset: UInt32) {
        self.init(for: name.rawValue, with: size, at: offset)
    }
    
    init(for name: String, with size: UInt32, at offset: UInt32) {
        self.name = name
        self.size = size
        self.offset = offset
    }
}

extension Block {
        
    func read(from url: URL) throws -> Data {
        
        do {
            
            return try readData(
                from: url,
                at: UInt64(offset),
                with: Int(size)
            )
            
        } catch {
            throw FileError.loadFailure
        }
    }
    
    private func readData(from file: URL, at offset: UInt64, with length: Int) throws -> Data {
        
        do {
            
            debugPrint("buffer:", file, offset, length)
            
            let fileHandle = try FileHandle(forReadingFrom: file)
            
            debugPrint(fileHandle)
            
            
            fileHandle.seek(toFileOffset: offset)
            let data = fileHandle.readData(ofLength: length)
            
            fileHandle.closeFile()
            
            return data
            
        } catch {
            debugPrint(error)
            throw FileError.loadFailure
        }
    }
}
