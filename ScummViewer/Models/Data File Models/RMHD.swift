//
//  RMHD.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 21.10.21.
//

import Foundation

struct RMHD: Equatable {
    
    let blockName: UInt32
    let blockSize: UInt32
    var width: UInt16
    var height: UInt16
    var numberOfObjects: UInt16
}

extension RMHD {
    
    static func create(from buffer: [UInt8]) -> RMHD {
        RMHD(
            blockName: buffer.dwordLE(0),
            blockSize: buffer.dwordBE(4),
            width: buffer.wordLE(8),
            height: buffer.wordLE(10),
            numberOfObjects: buffer.wordLE(12)
        )
    }
    
    static var empty: RMHD {
        RMHD(blockName: 0, blockSize: 0, width: 0, height: 0, numberOfObjects: 0)
    }
    
    var isEmpty: Bool {
        self == RMHD.empty
    }
}
