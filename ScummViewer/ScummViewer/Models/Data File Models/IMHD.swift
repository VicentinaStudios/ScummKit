//
//  IMHD.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 07.11.21.
//

import Foundation

struct IMHD: Equatable {
    
    let blockName: UInt32
    let blockSize: UInt32
    var objectID: UInt16
    var numberOfIMNN: UInt16
    var numberOfZPNN: UInt16
    var flags: UInt8
    var unknown: UInt8
    var x: UInt16
    var y: UInt16
    var width: UInt16
    var height: UInt16
}

extension IMHD {
    
    static func create(from buffer: [UInt8]) -> IMHD {
        IMHD(
            blockName: buffer.dwordLE(0),
            blockSize: buffer.dwordBE(4),
            objectID: buffer.wordLE(8),
            numberOfIMNN: buffer.wordLE(10),
            numberOfZPNN: buffer.wordLE(12),
            flags: buffer.byte(14),
            unknown: buffer.byte(15),
            x: buffer.wordLE(16),
            y: buffer.wordLE(18),
            width: buffer.wordLE(20),
            height: buffer.wordLE(22)
        )
    }
    
    static var empty: IMHD {
        IMHD(blockName: 0, blockSize: 0, objectID: 0, numberOfIMNN: 0, numberOfZPNN: 0, flags: 0, unknown: 0, x: 0, y: 0, width: 0, height: 0)
    }
    
    var isEmpty: Bool {
        self == IMHD.empty
    }
}
