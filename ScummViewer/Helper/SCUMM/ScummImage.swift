//
//  ScummImage.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 24.10.21.
//

import Foundation

struct ScummImage {
    
    let smap: SMAP
    let clut: CLUT
    let width: UInt16
    let height: UInt16
    
    private var palette: [Bitmap.Color] {
        clut.colors.map { Bitmap.Color(red: $0.red, green: $0.green, blue: $0.blue) }
    }
    
    init(from smap: SMAP, palette clut: CLUT, width: UInt16, height: UInt16) {
        
        self.smap = smap
        self.clut = clut
        self.width = width
        self.height = height
    }
    
    var bitmap: Bitmap {
            
        var bitmap = Bitmap(width: Int(width), height: Int(height), color: .clear)

        smap.stripes.enumerated().forEach { index, stripe in
            
            let column = index * 8
            
            let decoded = decodeStripe(index).enumerated()
                .filter { index, _ in index < 8 * height }
                .map { $0.element }
            
            let stripe = Bitmap(from: decoded)
            
            stripe.pixels.enumerated()
                .filter { index, _ in index < 8 * height }
                .forEach { index, pixel in
                    bitmap.draw(x: index % 8 + column, y: index / 8, with: pixel)
            }
        }
        
        return bitmap
    }
    
    private func decodeStripe(_ index: Int) -> [Bitmap.Color] {
        
        smap.stripes[index].decoded.enumerated().map { index, pixel in
            
            Bitmap.Color(
                red: clut.colors[Int(pixel)].red,
                green: clut.colors[Int(pixel)].green,
                blue: clut.colors[Int(pixel)].blue
            )
        }
    }
}
