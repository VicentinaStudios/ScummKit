//
//  UInt32+Ext.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 17.10.21.
//

import Foundation

extension UInt32 {
    
    var hex: String {
        String(format: "%08x", self)
    }
    
    func xor(with gate: UInt32) -> UInt32 {
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
