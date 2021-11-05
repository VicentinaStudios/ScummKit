//
//  ScummImage.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 24.10.21.
//

import Foundation

struct ScummImage {
    
    let smap: SMAP
    let rmhd: RMHD
    let clut: CLUT
    
    private var palette: [Bitmap.Color] {
        clut.colors.map { Bitmap.Color(red: $0.red, green: $0.green, blue: $0.blue) }
    }
    
    init(from smap: SMAP, info rmhd: RMHD, palette clut: CLUT) {
        
        self.smap = smap
        self.rmhd = rmhd
        self.clut = clut
    }
    
    var bitmap: Bitmap {
            
        var bitmap = Bitmap(width: Int(rmhd.width), height: Int(rmhd.height), color: .clear)

        smap.stripes.enumerated().forEach { index, stripe in
            
            let column = index * 8
            
            let decoded = decodeStripe(index).enumerated()
                .filter { index, _ in index < 8 * rmhd.height }
                .map { $0.element }
            
            let stripe = Bitmap(from: decoded)
            
            stripe.pixels.enumerated()
                .filter { index, _ in index < 8 * rmhd.height }
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
