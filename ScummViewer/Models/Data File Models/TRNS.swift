//
//  TRNS.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 05.11.21.
//

import Foundation

struct TRNS: Equatable {
    
    let blockName: UInt32
    let blockSize: UInt32
    var paletteIndex: UInt8
    var blank: UInt8
}

extension TRNS {
    
    static func create(from buffer: [UInt8]) -> TRNS {
        TRNS(
            blockName: buffer.dwordLE(0),
            blockSize: buffer.dwordBE(4),
            paletteIndex: buffer.byte(8),
            blank: buffer.byte(0)
        )
    }
    
    static var empty: TRNS {
        TRNS(blockName: 0, blockSize: 0, paletteIndex: 0, blank: 0)
    }
    
    var isEmpty: Bool {
        self == TRNS.empty
    }
}
