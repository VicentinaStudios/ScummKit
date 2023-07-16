//
//  RNAM.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 20.10.21.
//

import Foundation

struct RNAM {
    
    struct Room: Hashable    {
        let number: UInt8
        let name: [UInt8]
    }
    
    let blockName: UInt32
    let blockSize: UInt32
    var rooms: [Room]
    let blank: UInt8
}

extension RNAM {
    
    static func create(from buffer: [UInt8]) -> RNAM {
        
        var offset = 8
        
        var rooms: [Room] = []
        
        while offset < buffer.count - 1 {
        
            let roomNumber = buffer.byte(offset)
            let roomName = buffer.slice(offset + 1, size: 9).map { $0.xor(with: 0xff) }
            
            let room = Room(number: roomNumber, name: roomName)
            rooms.append(room)
                        
            offset += 10
        }
                
        return RNAM(
            blockName: buffer.dwordLE(0),
            blockSize: buffer.dwordBE(4),
            rooms: rooms,
            blank: buffer.byte(offset)
        )
    }
    
    static var empty: RNAM {
        RNAM(blockName: 0, blockSize: 0, rooms: [], blank: 0)
    }
}
