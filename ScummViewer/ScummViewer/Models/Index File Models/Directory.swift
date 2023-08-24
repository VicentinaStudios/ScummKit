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
        
        let numberOfItems = buffer.wordLE(8)
        var itemNumbers: [UInt8] = []
        
        var offset = 10
        
        for _ in 0..<numberOfItems {
            
            let itemNumber = buffer.byte(offset)
            itemNumbers.append(itemNumber)
            
            offset += 1
        }
        
        var offsets: [UInt32] = []
        
        for _ in 0..<numberOfItems {
            
            let offs = buffer.dwordLE(offset)
            offsets.append(offs)
            
            offset += 4
        }
        
        return Directory(
            blockName: buffer.dwordLE(0),
            blockSize: buffer.dwordBE(4),
            numberOfItems: numberOfItems,
            itemNumbers: itemNumbers,
            offsets: offsets
        )
    }
    
    static func createInOneLoop(from buffer: [UInt8]) -> Directory {
        
        let numberOfItems = buffer.wordLE(6)
        
        var itemNumbers: [UInt8] = []
        var offsets: [UInt32] = []
        
        var offset = 8
        
        for _ in 0..<numberOfItems {
            
            let itemNumber = buffer.byte(offset)
            itemNumbers.append(itemNumber)
            
            offset += 1
            
            let offs = buffer.dwordLE(offset)
            offsets.append(offs)
            
            offset += 4
        }
        
        let blockName = buffer.wordLE(4)
        
        return Directory(
            blockName: UInt32(blockName),
            blockSize: buffer.dwordBE(4),
            numberOfItems: numberOfItems,
            itemNumbers: itemNumbers,
            offsets: offsets
        )
    }
    
    static var empty: Directory {
        Directory(blockName: 0, blockSize: 0, numberOfItems: 0, itemNumbers: [], offsets: [])
    }
}
