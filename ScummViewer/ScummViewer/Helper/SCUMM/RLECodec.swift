//
//  RLECodec.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 20.11.21.
//

import Foundation

class RLECodec {
    
    private let buffer: [UInt8]
    
    private var paletteIndex: UInt8 = 0
    
    init(with buffer: [UInt8]) {
        self.buffer = buffer
    }
}
