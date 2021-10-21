//
//  Directory.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 21.10.21.
//

import Foundation

struct Directory {
    
    let blockName: UInt32
    let blockSize: UInt32
    let numberOfItems: UInt16
    let itemNumbers: [UInt8]
    let offsets: [UInt32]
}

extension Directory {
    
    static func create(from buffer: [UInt8]) -> Directory {
        
        var offset = 10
        
        var itemNumbers: [UInt8] = []
        
        while offset < buffer.count - 1 {
            
            let itemNumber = buffer.byte(offset)
            itemNumbers.append(itemNumber)
            
            offset += 1
        }
        
        var offsets: [UInt32] = []
        
        while offset < buffer.count - 1 {
            
            let offs = buffer.dwordLE(offset)
            offsets.append(offs)
            
            offset += 1
        }
        
        return Directory(
            blockName: buffer.dwordLE(0),
            blockSize: buffer.dwordBE(4),
            numberOfItems: buffer.wordLE(8),
            itemNumbers: itemNumbers,
            offsets: offsets
        )
    }
}
