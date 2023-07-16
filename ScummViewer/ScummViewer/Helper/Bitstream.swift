//
//  Bitstream.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 23.10.21.
//

import Foundation

class Bitstream {
    
    private let buffer: [UInt8]
    
    private (set) var offset = 0
    private(set) var currentByte: UInt8
    
    private var bitIndex = 0
    
    private var byte: UInt8? {
        //!endOfStream ? buffer[offset] : nil
        buffer[offset]
    }
    
    private var next: UInt8? {
        !isLast ? buffer[offset + 1] : nil
    }
    
    var bitPosition = 0 {
        didSet {
            
            bitIndex += 1
            
            if bitPosition == UInt8.bitWidth {
                bitPosition = 0
                offset += 1
            }
            
            updateCurrentByte(8)
        }
    }
    
    private var isLast: Bool {
        offset == buffer.count - 1
    }
    
    var endOfStream: Bool {
        !(offset < buffer.count)
    }
    
    var bitsLeft: Bool {
        bitIndex < buffer.count * 8
    }
    
    var readBit: UInt8 {
        
        let bit = currentByte & 0b00000001
        bitPosition += 1
        
        return bit
    }
    
    init(with buffer: [UInt8], start offset: Int = 0) {
        self.buffer = buffer
        self.offset = offset
        self.currentByte = buffer[offset]
        self.bitIndex = offset * 8
    }
    
    func readBits(_ amount: Int) -> UInt8? {
        
        guard !endOfStream else {
            return nil
        }
        
        //let mask: UInt8 = 1 << amount - 1
        let mask: UInt8 = 255 >> (8 - amount)
        let bits = currentByte & mask
        
        for _ in 0..<amount {
            _ = readBit
        }
        
        //let bits = byte! >> bitPosition | (next ?? 0 ) << (amount - bitPosition)
        
        //offset += 1
        //updateCurrentByte(amount)
        
        return bits
    }
    
    private func updateCurrentByte(_ amount: Int) {
        
        guard !endOfStream else {
            return
        }

        currentByte = (byte ?? 0) >> bitPosition | (next ?? 0) << (amount - bitPosition)
    }
}
