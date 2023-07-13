//
//  SCRP.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 10/07/2023.
//

import Foundation

struct SCRP: Equatable {
    
    let blockName: UInt32
    let blockSize: UInt32
    let code: [UInt8]
}

extension SCRP {
    
    static func create(from buffer: [UInt8]) -> SCRP {
        
        let code = buffer.slice(8, size: buffer.count - 8)
        
        return  SCRP(
            blockName: buffer.dwordLE(0),
            blockSize: buffer.dwordBE(4),
            code: code)
    }
    
    static var empty: SCRP {
        SCRP(blockName: 0, blockSize: 0, code: [])
    }
}
