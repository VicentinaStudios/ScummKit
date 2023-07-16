//
//  CDHD.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 10/07/2023.
//

/*
 obj id    : 16le
 x         : 8
 y         : 8
 width     : 8
 height    : 8
 flags     : 8
 parent    : 8
 walk_x    : 16le signed
 walk_y    : 16le signed
 actor dir : 8 (direction the actor will look at when standing in front
                of the object)
 */

import Foundation

struct CDHD: Equatable {
    
    let blockName: UInt32
    let blockSize: UInt32
    var objectID: UInt16
    var x: UInt8
    var y: UInt8
    var width: UInt8
    var height: UInt8
    var flags: UInt8
    var parent: UInt8
    var walkX: UInt16
    var walkY: UInt16
    var actorDirection: UInt8
}

extension CDHD {
    
    static func create(from buffer: [UInt8]) -> CDHD {
        CDHD(
            blockName: buffer.dwordLE(0),
            blockSize: buffer.dwordBE(4),
            objectID: buffer.wordLE(8),
            x: buffer.byte(10),
            y: buffer.byte(11),
            width: buffer.byte(12),
            height: buffer.byte(13),
            flags: buffer.byte(14),
            parent: buffer.byte(15),
            walkX: buffer.wordLE(16),
            walkY: buffer.wordLE(18),
            actorDirection: buffer.byte(20))
    }
    
    static var empty: CDHD {
        CDHD(blockName: 0, blockSize: 0, objectID: 0, x: 0, y: 0, width: 0, height: 0, flags: 0, parent: 0, walkX: 0, walkY: 0, actorDirection: 0)
    }
    
    var isEmpty: Bool {
        self == CDHD.empty
    }
}
