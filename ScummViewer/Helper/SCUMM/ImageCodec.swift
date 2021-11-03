//
//  ImageCodec.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 01.11.21.
//

import Foundation

enum CodecError: Error {
    case unknownCodec
    case paletteIFailure
    case urlFailure
}

class ImageCodec {
    
    private let stripe: Stripe
    private let bitstream: Bitstream
    
    private var paletteIndex: UInt8 = 0
    private var buffer: [UInt8] = []
    private var substractionVariable = 1
    
    init(stripe: Stripe) {
        
        self.stripe = stripe
        self.bitstream = Bitstream(with: stripe.data, start: 1)
    }
        
    var decode: [UInt8] {
        
        get throws {
            
            do {
                
                switch try stripe.compressionMethod {
                    
                case .uncompressed:
                    return stripe.data
                    
                case .method1:
                    decompressMethod1()
                    
                    if try stripe.renderingDirection == .vertical {
                        buffer = verticalBuffer
                    }
                    
                    return buffer
                    
                case .method2:
                    decompressMethod2()
                    return buffer
                }
                
            } catch {
                throw error
            }
        }
    }
    
    private var verticalBuffer: [UInt8] {
        
        var verticalBuffer = Array<UInt8>(repeating: 0, count: buffer.count)
        var offset = 0
        var x = 0
        
        buffer.enumerated().forEach { index, pixel in
            
            verticalBuffer[offset] = pixel
            
            offset += 8
            
            if offset >= buffer.count / 8 * 8 {
                x += 1
                offset = x
            }
        }
        
        return verticalBuffer
    }
}

// MARK: - Decompression

extension ImageCodec {
    
    private func decompressMethod1() {
        
        paletteIndex = stripe.data[0]
        
        buffer.append(paletteIndex)
        
        while bitstream.bitsLeft {
            
            if bitstream.readBit == 1 {
                
                if bitstream.readBit == 0 {
                    
                    try! nextPaletteIndex()
                    substractionVariable = 1
                    
                } else {
                    
                    commandsMethod1()
                }
            }
            
            buffer.append(paletteIndex)
        }
    }
    
    private func decompressMethod2() {
        
        paletteIndex = stripe.data[0]
        
        while bitstream.bitsLeft {
            
            buffer.append(paletteIndex)
            
            if bitstream.readBit == 1 {
                
                if bitstream.readBit == 0 {
                    
                    try! nextPaletteIndex()
                    
                } else {
                    
                    commandsMethod2()
                }
            }
        }
    }
    
    private func nextPaletteIndex() throws {
        
        guard
            let amount = stripe.numberOfBitsForPaletteIndex,
            let bits = bitstream.readBits(Int(amount))
        else {
            throw CodecError.paletteIFailure
        }
        
        paletteIndex = bits
    }
    
    private func commandsMethod1() {
        
        if bitstream.readBit == 1 {
            substractionVariable = -substractionVariable
        }
        
        let updatedPaletteIndex = Int(paletteIndex) - substractionVariable
        paletteIndex = UInt8(updatedPaletteIndex)
    }
    

    
    private func commandsMethod2() {
        
        if
            let bits = bitstream.readBits(3),
            let action = Method2Command(rawValue: bits),
            let paletteIndexChange = action.changePaletteIndex
        {
            let updatedPaletteIndex = Int(paletteIndex) + paletteIndexChange
            paletteIndex = UInt8(updatedPaletteIndex)
            
        } else if
            let numberOfBits = stripe.numberOfBitsForPaletteIndex,
            let lenght = bitstream.readBits(Int(numberOfBits))
                
        {
            for _ in 0..<lenght {
                buffer.append(paletteIndex)
            }
        }
    }
    
    enum Method2Command: UInt8 {
        case decreasePaletteIndexBy4 = 0b000
        case decreasePaletteIndexBy3 = 0b001
        case decreasePaletteIndexBy2 = 0b010
        case decreasePaletteIndexBy1 = 0b011
        case rleDraw = 0b100
        case increasePaletteIndexBy1 = 0b101
        case increasePaletteIndexBy2 = 0b110
        case increasePaletteIndexBy3 = 0b111
        
        var changePaletteIndex: Int? {
            
            switch self {
                
            case .decreasePaletteIndexBy4:
                return -4
            case .decreasePaletteIndexBy3:
                return -3
            case .decreasePaletteIndexBy2:
                return -2
            case .decreasePaletteIndexBy1:
                return -1
            case .rleDraw:
                return nil
            case .increasePaletteIndexBy1:
                return 1
            case .increasePaletteIndexBy2:
                return 2
            case .increasePaletteIndexBy3:
                return 3
            }
        }
    }
}
