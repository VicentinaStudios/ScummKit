//
//  UInt16+Ext.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 17.10.21.
//

extension UInt16 {
    
    var hex: String {
        String(format: "%04x", self)
    }
    
    func xor(with gate: UInt16) -> UInt16 {
        self ^ gate
    }
    
    var unicode: [UnicodeScalar] {
        let bytes = withUnsafeBytes(of: self) { Array($0) }
        return bytes.map { UnicodeScalar($0) }
    }
    
    var char: [String] {
        unicode.map { String($0) }
    }
}
