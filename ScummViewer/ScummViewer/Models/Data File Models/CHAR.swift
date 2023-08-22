//
//  CHAR.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 20/08/2023.
//

import Foundation

struct CHAR {
    
    struct CharacterGlyph {
        let width: UInt8
        let height: UInt8
        let offsetX: UInt8
        let offsetY: UInt8
        let bitstream: [UInt8]
    }
    
    let blockName: UInt32
    let blockSize: UInt32
    var size: UInt32
    var version: UInt16
    let colorMap: [UInt8]
    var bitsPerPixel: UInt8
    var fontHeight: UInt8
    var numberOfCharacter: UInt16
    var characterDataOffsets: [UInt32]
    var characterGlyps: [CharacterGlyph]
    
    static func create(from buffer: [UInt8]) -> CHAR {
        
        var offset = 14
        
        var colorMap: [UInt8] = []
        for index in 0..<15 {
            let color = buffer.byte(offset + index)
            colorMap.append(color)
        }
        
        let bitsPerPixel = buffer.byte(29)
        
        let numberOfCharacters = buffer.wordLE(31)
        
        offset = 33
        
        var characterDataOffsets: [UInt32] = []
        for index in 0..<numberOfCharacters {
            let data = buffer.dwordLE(offset + Int(index * 4))
            characterDataOffsets.append(data)
        }
        
        let glyps = characterDataOffsets.map { offset in
            
            guard offset != 0 else {
                return CharacterGlyph(width: 0, height: 0, offsetX: 0, offsetY: 0, bitstream: [])
            }
            
            let width = buffer.byte(Int(offset) + 29)
            let height = buffer.byte(Int(offset) + 1 + 29)
            if offset == 1078 {
                
            }
            let size = Int(width * height)
            let planeSize = size * Int(bitsPerPixel)
            
            let data = buffer.slice(Int(offset) + 4 + 29, size: planeSize / 8)
            
            return CharacterGlyph(
                width: width,
                height: height,
                offsetX: buffer.byte(Int(offset) + 2 + 29),
                offsetY: buffer.byte(Int(offset) + 3 + 29),
                bitstream: data
            )
        }
        
        return CHAR(
            blockName: buffer.dwordLE(0),
            blockSize: buffer.dwordBE(4),
            size: buffer.dwordLE(8),
            version: buffer.wordBE(12),
            colorMap: colorMap,
            bitsPerPixel: bitsPerPixel,
            fontHeight: buffer.byte(30),
            numberOfCharacter: numberOfCharacters,
            characterDataOffsets: characterDataOffsets,
            characterGlyps: glyps
        )
    }
    
    static var empty: CHAR {

        CHAR(blockName: 0, blockSize: 0, size: 0, version: 0, colorMap: [], bitsPerPixel: 0, fontHeight: 0, numberOfCharacter: 0, characterDataOffsets: [], characterGlyps: [])
    }
}
