//
//  CLUT.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 23.10.21.
//

import Foundation

struct CLUT: Equatable {
    
    struct Color: Hashable {
        
        let red: UInt8
        let green: UInt8
        let blue: UInt8
    }
    
    let blockName: UInt32
    let blockSize: UInt32
    let colors: [Color]
    
}

extension CLUT {
    
    static func create(from buffer: [UInt8]) -> CLUT {
    
        var colors: [Color] = []
        
        var offset = 8
        
        while offset < buffer.count {
            
            let color = Color(
                red: buffer.byte(offset),
                green: buffer.byte(offset + 1),
                blue: buffer.byte(offset + 2)
            )
            
            colors.append(color)
            
            offset += 3
        }
        
        return CLUT(
            blockName: buffer.dwordLE(0),
            blockSize: buffer.dwordBE(4),
            colors: colors
        )
    }
    
    static var empty: CLUT {
        CLUT(blockName: 0, blockSize: 0, colors: [])
    }
    
    var isEmpty: Bool {
        self == CLUT.empty
    }
}
