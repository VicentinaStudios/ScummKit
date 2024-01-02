//
//  CodeGenerator.swift
//
//
//  Created by Michael Borgmann on 02/01/2024.
//

import Foundation

class CodeGenerator {
    
    private var chunk: Chunk
    
    init(with chunk: Chunk) {
        self.chunk = chunk
    }
    
    func emitByte(_ byte: UInt8) {
        chunk.write(byte: byte)
    }
    
    func emitBytes(_ bytes: UInt8...) {
        for byte in bytes {
            chunk.write(byte: byte)
        }
    }
    
    func emitDummy() {
        emitByte(23)
    }
}
