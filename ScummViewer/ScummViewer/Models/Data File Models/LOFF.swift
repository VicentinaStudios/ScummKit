//
//  LOFF.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 21.10.21.
//

import Foundation

struct LOFF {
    
    struct Room: Hashable    {
        let roomId: UInt8
        let offset: UInt32
    }
    
    let blockName: UInt32
    let blockSize: UInt32
    let numberOfRooms: UInt8
    let rooms: [Room]
}

extension LOFF {
    
    static func create(from buffer: [UInt8]) -> LOFF {
        
        let numberOfRooms = buffer.byte(8)
        var rooms: [Room] = []
        
        var offset = 9
        
        for _ in 0..<numberOfRooms {
            
            let roomId = buffer.byte(offset)
            let offs = buffer.dwordLE(offset + 1)
            
            let room = Room(roomId: roomId, offset: offs)
            rooms.append(room)
            
            offset += 5
        }
        
        return LOFF(
            blockName: buffer.dwordLE(0),
            blockSize: buffer.dwordBE(4),
            numberOfRooms: numberOfRooms,
            rooms: rooms
        )
    }
    
    static var empty: LOFF {
        LOFF(blockName: 0, blockSize: 0, numberOfRooms: 0, rooms: [])
    }
}
