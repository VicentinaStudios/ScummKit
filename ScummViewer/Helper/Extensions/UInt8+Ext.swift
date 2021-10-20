//
//  UInt8+Ext.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 17.10.21.
//

import Foundation

extension UInt8 {
    
    var hex: String {
        String(format: "%02hhx", self)
    }
    
    var binary: String {
        String(self, radix: 2)
    }
    
    func xor(with gate: UInt8) -> UInt8 {
        self ^ gate
    }
    
    var unicode: UnicodeScalar {
        UnicodeScalar(self)
    }
    
    var char: String {
        String(unicode)
    }
    
    var printable: String {
        
        let ascii = [
            "␀", "␁", "␂", "␃", "␄", "␅", "␆", "␇", "␈", "␉", "␤", "␋", "␌", "␍", "␎", "␏",
            "␐", "␑", "␒", "␓", "␔", "␕", "␖", "␗", "␘", "␙", "␚", "␛", "␜", "␝", "␞", "␟",
            "␠"
        ]
        
        switch self {
        case 0...32:
            //return ascii[Int(self)]
            return "."
        case 127:
            //return "␡"
            return "."
        default:
            return String(unicode.isASCII ? unicode : ".")
        }
    }
    
    func debug(xor gate: UInt8?) -> String {
        
        let hex = "0x\(hex)"
        let xored = gate != nil ? "0x\(xor(with: gate!).hex)" : nil
        let character = gate != nil ? xor(with: gate!).char : char
        
        if let xored = xored {
            return "\(hex)/\(xored) [\(character)]"
        } else {
            return "\(hex) [\(character)]"
        }
    }
}

extension Array where Element == UInt8 {
    
    func slice(_ index: Int, size: Int) -> [UInt8]{
        (index..<index+size).map { self[$0] }
    }
    
    func byte(_ index: Int) -> UInt8 {
        self[index]
    }
    
    func wordBE(_ index: Int) -> UInt16 {
        (index..<index+2).map { self[$0] }.wordBE
    }
    
    func wordLE(_ index: Int) -> UInt16 {
        (index..<index+2).map { self[$0] }.wordLE
    }
    
    func dwordBE(_ index: Int) -> UInt32 {
        (index..<index+4).map { self[$0] }.dwordBE
    }
    
    func dwordLE(_ index: Int) -> UInt32 {
        (index..<index+4).map { self[$0] }.dwordLE
    }
    
    var wordLE: UInt16 {
        
        let u16 = self.reversed().reduce(0) { soFar, byte in
            soFar << 8 | UInt16(byte)
        }
        
        return u16
    }
    
    var wordBE: UInt16 {
        
        let u16 = self.reduce(0) { soFar, byte in
            soFar << 8 | UInt16(byte)
        }
        
        return u16
    }

    var dwordLE: UInt32 {
        
        let u16 = self.reversed().reduce(0) { soFar, byte in
            soFar << 8 | UInt32(byte)
        }
        
        return u16
    }

    var dwordBE: UInt32 {
        
        let u16 = self.reduce(0) { soFar, byte in
            soFar << 8 | UInt32(byte)
        }
        
        return u16
    }
}
