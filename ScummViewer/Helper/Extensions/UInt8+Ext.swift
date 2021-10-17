//
//  UInt8+Ext.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 17.10.21.
//

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
