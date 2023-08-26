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
    
    static func create_v4(from buffer: [UInt8]) -> SOUN {
        
        var offset: UInt32 = 0
        
        var musicBlocks: [Music] = []
        
        let blockSize: UInt32 = buffer.dwordLE(0) == 33301 ? 33045 : buffer.dwordLE(0)
        
        while offset < blockSize {
            
            let dataSize = buffer.dwordLE(Int(offset)) == 33301 ? 33045 : buffer.dwordLE(Int(offset))
            
            guard dataSize <= blockSize else {
                break
            }
            
            let data: [UInt8]
            data = buffer.slice(Int(offset), size: Int(dataSize))
            
            let music = Music(
                blockName: buffer.dwordLE(4) & 0xffff,
                blockSize: buffer.dwordLE(0),
                midi: data
            )
            
            musicBlocks.append(music)
            
            offset += dataSize
        }
        
        let soun = SOUN(
            blockName: buffer.dwordLE(4) & 0xffff,
            blockSize: blockSize,
            blockName2: buffer.dwordLE(4) & 0xffff,
            blockSize2: blockSize,
            music: musicBlocks)
        
        return soun
    }
    
    static var empty: SOUN {
        SOUN(blockName: 0, blockSize: 0, blockName2: 0, blockSize2: 0, music: [])
    }
}
