//
//  Bitmap.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 23.10.21.
//

import Foundation
import CoreGraphics

struct Bitmap {
    
    struct Color {
        
        var red: UInt8
        var green: UInt8
        var blue: UInt8
        var alpha: UInt8 = 255
        
        static let clear = Color(red: 0, green: 0, blue: 0, alpha: 0)
        static let black = Color(red: 0, green: 0, blue: 0)
        static let white = Color(red: 255, green: 255, blue: 255)
        static let gray = Color(red: 192, green: 192, blue: 192)
        static let red = Color(red: 255, green: 0, blue: 0)
        static let green = Color(red: 0, green: 255, blue: 0)
        static let blue = Color(red: 0, green: 0, blue: 255)
    }
    
    let width: Int
    var height: Int { pixels.count / width }
    
    var pixels: [Color]
    
    private var offset = 0
    
    subscript(x: Int, y: Int) -> Color {
        get { pixels[y * width + x] }
        set { pixels[y * width + x] = newValue }
    }
    
    init(width: Int, height: Int, color: Color) {
        
        self.width = width
        pixels = Array(repeating: color, count: width * height)
    }
    
    init(from buffer: [Color]) {
        
        self.width = 8
        self.pixels = buffer
    }
}

extension Bitmap {
    
    var cgImage: CGImage? {
        
        let alphaInfo = CGImageAlphaInfo.premultipliedLast
        let bytesPerPixel = MemoryLayout<Color>.stride
        let bytesPerRow = width * bytesPerPixel
        
        guard let providerRef = CGDataProvider(data: Data(bytes: pixels, count: height * bytesPerRow) as CFData) else {
            return nil
        }
        
        return CGImage(
            width: width,
            height: height,
            bitsPerComponent: 8,
            bitsPerPixel: bytesPerPixel * 8,
            bytesPerRow: bytesPerRow,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGBitmapInfo(rawValue: alphaInfo.rawValue),
            provider: providerRef,
            decode: nil,
            shouldInterpolate: true,
            intent: .defaultIntent
        )
    }
    
    mutating func draw(x: Int, y: Int, with color: Color) {
        
        let position = y * width + x

        guard position < width * height else {
            return
        }
        
        pixels[position] = color
    }
    
    mutating func draw(with color: Color) {
        
        if offset >= pixels.count {
            return
        }
        
        pixels[offset] = color
        offset += 1
    }
}
