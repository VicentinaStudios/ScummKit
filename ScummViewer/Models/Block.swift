//
//  Block.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 18.10.21.
//

struct Block: Hashable {
    
    var name: String
    var size: UInt32
    var offset: UInt32
    
    init(for name: String, with size: UInt32, at offset: UInt32) {
        self.name = name
        self.size = size
        self.offset = offset
    }
}
