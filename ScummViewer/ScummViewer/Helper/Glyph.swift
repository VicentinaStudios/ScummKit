//
//  Glyph.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 22/08/2023.
//

import Foundation

struct Glyph {
    
    private let data: CHAR.CharacterGlyph
    private let bitsPerPixel: UInt8
    private let colors: [CLUT.Color]
    private let colorMap: [UInt8]
    
    init(with glyph: CHAR.CharacterGlyph, bitsPerPixel: UInt8, colors: [CLUT.Color], colorMap: [UInt8]) {
        
        self.data = glyph
        self.bitsPerPixel = bitsPerPixel
        self.colors = colors
        self.colorMap = colorMap
    }
    
    var bitmap: Bitmap? {
        
        guard data.width > 0, data.height > 0 else {
            return nil
        }
        
        var bitmap = Bitmap(
            width: Int(data.width),
            height: Int(data.height),
            color: .red
        )
        
        let bitstream = Bitstream(with: data.bitstream.map { reverseBitOrder(byte: $0) }, start: 0)
        
        var x = 0
        var y = 0
        
        var count = 0
        
        while bitstream.bitsLeft {
            
            let pixel: UInt8
            
            switch bitsPerPixel {
            case 2:
                pixel = bitstream.readTwoBits
            case 4:
                pixel = bitstream.readNibble
            default:
                pixel = bitstream.readBit
            }
            
            let colorIndex = colorMap[Int(pixel)]
            let color = colors[Int(colorIndex)]
            
            bitmap.draw(x: x, y: y, with: Bitmap.Color(red: color.red, green: color.green, blue: color.blue))
            
            x = x < data.width - 1 ? x + 1 : 0
            
            if x == 0 {
                y += 1
            }
            
            count += 1
        }
        
        return bitmap
    }
    
    func reverseBitOrder(byte: UInt8) -> UInt8 {
        var reversedByte: UInt8 = 0
        
        for i in 0..<8 {
            if (byte & (1 << i)) != 0 {
                reversedByte |= (1 << (7 - i))
            }
        }
        
        return reversedByte
    }
}
