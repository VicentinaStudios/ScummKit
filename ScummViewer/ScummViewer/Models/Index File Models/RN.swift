//
//  RN.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 23/08/2023.
//

import Foundation

struct RN {
    
    struct Room: Hashable    {
        let number: UInt8
        let name: [UInt8]
    }
    
    let blockSize: UInt32
    let blockName: UInt16
    var rooms: [Room]
    let blank: UInt8
}

extension RN {
    
    static func create(from buffer: [UInt8]) -> RN {
        
        var offset = 6
        
        var rooms: [Room] = []
        
        while offset < buffer.count - 1 {
        
            let roomNumber = buffer.byte(offset)
            let roomName = buffer.slice(offset + 1, size: 9).map { $0.xor(with: 0xff) }
            
            let room = Room(number: roomNumber, name: roomName)
            rooms.append(room)
                        
            offset += 10
        }
                
        return RN(
            blockSize: buffer.dwordBE(0),
            blockName: buffer.wordLE(4),
            rooms: rooms,
            blank: buffer.byte(offset)
        )
    }
    
    static var empty: RN {
        RN(blockSize: 0, blockName: 0, rooms: [], blank: 0)
    }
}
