//
//  SOUN.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 22/08/2023.
//

import Foundation

struct SOUN {
    
    struct Music {
        var blockName: UInt32
        var blockSize: UInt32
        var midi: [UInt8]
    }
    
    let blockName: UInt32
    let blockSize: UInt32
    var blockName2: UInt32
    var blockSize2: UInt32
    var music: [Music]
    
    static func create(from buffer: [UInt8]) -> SOUN {
        
        var offset: UInt32 = 16
        
        var musicBlocks: [Music] = []
        
        let blockSize = buffer.dwordBE(4)
        
        while offset < blockSize {
            
            let musicBlockSize = buffer.dwordBE(Int(offset) + 4)
            
            guard musicBlockSize < blockSize - offset + 8 else {
                break
            }
            
            let midi = buffer.slice(Int(offset) + 8, size: Int(musicBlockSize))
            
            let music = Music(
                blockName: buffer.dwordBE(Int(offset)),
                blockSize: musicBlockSize,
                midi: midi
            )
            
            musicBlocks.append(music)
            
            offset += musicBlockSize + 8
        }
        
        return SOUN(
            blockName: buffer.dwordLE(0),
            blockSize: buffer.dwordBE(4),
            blockName2: buffer.dwordBE(8),
            blockSize2: buffer.dwordBE(12),
            music: musicBlocks)
    }
    
    static var empty: SOUN {
        SOUN(blockName: 0, blockSize: 0, blockName2: 0, blockSize2: 0, music: [])
    }
}
