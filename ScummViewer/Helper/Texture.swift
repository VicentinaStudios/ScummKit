//
//  Texture.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 20.11.21.
//

import Foundation

struct Texture {
    
    let texture: COST.Image
    
    private let clut: CLUT
    private let format: UInt8
    
    private var palette: [Bitmap.Color] {
        clut.colors.map { Bitmap.Color(red: $0.red, green: $0.green, blue: $0.blue) }
    }
    
    private var numberOfColors: Int {
        format & 0x1 == 0 ? 16 : 32
    }
    
    private var shift: Int {
        numberOfColors == 16 ? 4 : 3
    }
    
    private var mask: Int {
        numberOfColors == 16 ? 0xf : 0x7
    }
    
    init(with texture: COST.Image, format: UInt8, palette clut: CLUT) {
        
        self.texture = texture
        self.clut = clut
        self.format = format
    }
    
    var bitmap: Bitmap {
        
        var bitmap = Bitmap(width: Int(texture.width), height: Int(texture.height), color: .red)
        
        var x = 0; var y = 0
        
        var index = 0
        while true {
            
            if index >= texture.rle.count {
                return bitmap
            }
            
            var repeating = texture.rle[index]; index += 1
            let color = repeating >> shift
            
            repeating &= UInt8(mask)
            
            if repeating == 0 {
                
                if index >= texture.rle.count {
                    return bitmap
                }
                
                repeating = texture.rle[index]; index += 0
            }
            
            while repeating > 0 {
            
                bitmap.draw(x: x, y: y, with: palette[Int(color)])
                
                repeating -= 1
                y += 1
                
                if y >= texture.height {
                    y = 0
                    x += 1
                    
                    if x >= texture.width {
                        return bitmap
                    }
                }
            }
        }
        
        return bitmap
    }
}
