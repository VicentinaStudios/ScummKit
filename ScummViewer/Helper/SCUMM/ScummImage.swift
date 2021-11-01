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
    
    var bitmap: Bitmap?
    
    var palette: [Bitmap.Color] {
        clut.colors.map { Bitmap.Color(red: $0.red, green: $0.green, blue: $0.blue) }
    }
    
    init(from smap: SMAP, info rmhd: RMHD, palette clut: CLUT) {
        
        self.smap = smap
        self.rmhd = rmhd
        self.clut = clut
        
        self.bitmap = createBitmap(with: palette)
    }
    
    private func createBitmap(with palette: [Bitmap.Color]) -> Bitmap {
        
        var bitmap = Bitmap(width: Int(rmhd.width), height: Int(rmhd.height), color: .blue)
        
        smap.stripes.enumerated().forEach { index, stripe in
            
            guard let compressionMethod = compressionMethod(stripe: stripe) else {
                return
            }
            
            let column = index * 8
            var decompressed: Bitmap = Bitmap(width: 8, height: Int(rmhd.height), color: .red)
            
            switch compressionMethod {
            case .uncompressed:
                break
            case .method1:
                
                if let method1 = decompressMethod1(for: stripe, direction: renderingDirection(stripe: stripe)!) {
                    decompressed = method1
                }
            
            case .method2:
                if let method2 = decompressMethod2(for: stripe) {
                    decompressed = method2
                }
            }
            
            decompressed.pixels.enumerated().forEach { index, pixel in
                bitmap.draw(x: index % 8 + column, y: index / 8, with: pixel)
            }
        }
        
        return bitmap
    }
}

// MARK: - Decompression Methods

extension ScummImage {
    
    enum Method1Command: UInt8 {
        
        case substractSubstractionValue = 0b110
        case negateSubtractionValue = 0b111
    }
    
    enum Method2Command: UInt8 {
        case increasePaletteIndexBy4 = 0b000
        case increasePaletteIndexBy3 = 0b001
        case increasePaletteIndexBy2 = 0b010
        case increasePaletteIndexBy1 = 0b011
        case rleDraw = 0b100
        case decreasePaletteIndexBy1 = 0b101
        case decreasePaletteIndexBy2 = 0b110
        case decreasePaletteIndexBy3 = 0b111
        
        var changePaletteIndex: Int? {
            
            switch self {
                
            case .increasePaletteIndexBy4:
                return -4
            case .increasePaletteIndexBy3:
                return -3
            case .increasePaletteIndexBy2:
                return -2
            case .increasePaletteIndexBy1:
                return -1
            case .rleDraw:
                return nil
            case .decreasePaletteIndexBy1:
                return 1
            case .decreasePaletteIndexBy2:
                return 2
            case .decreasePaletteIndexBy3:
                return 3
            }
        }
    }
    
    func decompressMethod1(for stripe: SMAP.Stripe, direction: ReneringDirection) -> Bitmap? {
        
        var paletteIndex = stripe.data[0]
        var bitmap = Bitmap(width: 8, height: Int(rmhd.height), color: .green)
        let bitstream = Bitstream(with: stripe.data, start: 1)
        var buffer: [UInt8] = []
        
        var substractionVariable = 1
        
        if direction == .horizontal {
            bitmap.draw(with: palette[Int(paletteIndex)])
        } else {
            bitmap.drawVertical(with: palette[Int(paletteIndex)])
        }
        
        buffer.append(paletteIndex)
        
        while buffer.count < 8 * rmhd.height {
            
            if bitstream.readBit == 1 {
                
                if bitstream.readBit == 0 {
                    
                    if
                        let numberOfBits = numberOfBitsForPaletteIndex(for: stripe),
                        let bits = bitstream.readBits(Int(numberOfBits))
                    {
                        paletteIndex = bits
                        substractionVariable = 1
                    }
                    
                } else {
                    
                    if bitstream.readBit == 0 {
                        let updatedPaletteIndex = Int(paletteIndex) - substractionVariable
                        paletteIndex = UInt8(updatedPaletteIndex)
                    } else {
                        substractionVariable = -substractionVariable
                        let updatedPaletteIndex = Int(paletteIndex) - substractionVariable
                        paletteIndex = UInt8(updatedPaletteIndex)
                    }
                }
            }
            
            if direction == .horizontal {
                bitmap.draw(with: palette[Int(paletteIndex)])
            } else {
                bitmap.drawVertical(with: palette[Int(paletteIndex)])
            }
            
            buffer.append(paletteIndex)
        }
        
        return bitmap
    }
    
    func decompressMethod2(for stripe: SMAP.Stripe) -> Bitmap? {
        
        var paletteIndex = stripe.data[0]
        var bitmap = Bitmap(width: 8, height: Int(rmhd.height), color: .green)
        let bitstream = Bitstream(with: stripe.data, start: 1)
        
        var buffer: [UInt8] = []
        
        while buffer.count < 8 * rmhd.height {
            
            bitmap.draw(with: palette[Int(paletteIndex)])
            buffer.append(paletteIndex)
            
            if bitstream.readBit == 1 {
                
                if bitstream.readBit == 0 {
                    
                    if
                        let numberOfBits = numberOfBitsForPaletteIndex(for: stripe),
                        let bits = bitstream.readBits(Int(numberOfBits))
                    {
                        paletteIndex = bits
                    }
                    
                } else {
                    
                    if
                        let bits = bitstream.readBits(3),
                        let action = Method2Command(rawValue: bits),
                        let paletteIndexChange = action.changePaletteIndex
                    {
                        let updatedPaletteIndex = Int(paletteIndex) + paletteIndexChange
                        paletteIndex = UInt8(updatedPaletteIndex)
                        
                    } else if
                        let numberOfBits = numberOfBitsForPaletteIndex(for: stripe),
                        let lenght = bitstream.readBits(Int(numberOfBits))
                    {
                        for _ in 0..<lenght {
                            bitmap.draw(with: palette[Int(paletteIndex)])
                        }
                    }
                }
            }
        }
        
        return bitmap
    }
}

// MARK: - Compression Methods

/*
 IDs            Method          Rendering Direction     Transparent     Param Subtraction   Remarks
 0x01           Uncompressed    Horizontal              No              -                   -
 0x0E .. 0x12   1st method      Vertical                No              0x0A                -
 0x18 .. 0x1C   1st method      Horizontal              No              0x14                -
 0x22 .. 0x26   1st method      Vertical                Yes             0x1E                -
 0x2C .. 0x30   1st method      Horizontal              Yes             0x28                -
 0x40 .. 0x44   2nd method      Horizontal              No              0x3C                -
 0x54 .. 0x58   2nd method      Horizontal              Yes             0x51                -
 0x68 .. 0x6C   2nd method      Horizontal              Yes             0x64                Same as 0x54 .. 0x58
 0x7C .. 0x80   2nd method      Horizontal              No              0x78                Same as 0x40 .. 0x44
 */

extension ScummImage {
    
    func compressionMethod(stripe: SMAP.Stripe) -> CompressionMethod? {
        
        switch Int(stripe.codec) {
        case 0x1:
            return .uncompressed
        case 0x0e...0x12:
            return .method1
        case 0x18...0x1c:
            return .method1
        case 0x22...0x26:
            return .method1
        case 0x2c...0x30:
            return .method1
        case 0x40...0x44:
            return .method2
        case 0x54...0x58:
            return .method2
        case 0x68...0x6c:
            return .method2
        case 0x70...0x80:
            return .method2
        default:
            return nil
        }
    }
    
    func renderingDirection(stripe: SMAP.Stripe) -> ReneringDirection? {
        
        switch Int(stripe.codec) {
        case 0x1:
            return .horizontal
        case 0x0e...0x12:
            return .vertical
        case 0x18...0x1c:
            return .horizontal
        case 0x22...0x26:
            return .vertical
        case 0x2c...0x30:
            return .horizontal
        case 0x40...0x44:
            return .horizontal
        case 0x54...0x58:
            return .horizontal
        case 0x68...0x6c:
            return .horizontal
        case 0x70...0x80:
            return .horizontal
        default:
            return nil
        }
    }
    
    func transparent(stripe: SMAP.Stripe) -> Bool? {
        
        switch Int(stripe.codec) {
        case 0x1:
            return false
        case 0x0e...0x12:
            return false
        case 0x18...0x1c:
            return false
        case 0x22...0x26:
            return true
        case 0x2c...0x30:
            return true
        case 0x40...0x44:
            return false
        case 0x54...0x58:
            return true
        case 0x68...0x6c:
            return true
        case 0x70...0x80:
            return false
        default:
            return nil
        }
    }
    
    func paramSubtraction(stripe: SMAP.Stripe) -> UInt8? {
        
        switch Int(stripe.codec) {
        case 0x1:
            return nil
        case 0x0e...0x12:
            return 0x0a
        case 0x18...0x1c:
            return 0x14
        case 0x22...0x26:
            return 0x1e
        case 0x2c...0x30:
            return 0x28
        case 0x40...0x44:
            return 0x3c
        case 0x54...0x58:
            return 0x51
        case 0x68...0x6c:
            return 0x64
        case 0x70...0x80:
            return 0x78
        default:
            return nil
        }
    }
    
    func numberOfBitsForPaletteIndex(for stripe: SMAP.Stripe) -> UInt8? {
        
        guard let paramSubtraction = paramSubtraction(stripe: stripe) else {
            return nil
        }
        
        return stripe.codec - paramSubtraction
    }
}

extension ScummImage {
    
    enum CompressionMethod {
        case uncompressed
        case method1
        case method2
    }
    
    enum ReneringDirection {
        case horizontal
        case vertical
    }
}
