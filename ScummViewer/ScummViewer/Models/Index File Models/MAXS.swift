//
//  MAXS.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 20.10.21.
//

import Foundation

struct MAXS {
    
    let blockName: UInt32
    let blockSize: UInt32
    let variables: UInt16
    let unknown: UInt16
    let bitVariables: UInt16
    let localObjects: UInt16
    let newNames: UInt16
    let characterSets: UInt16
    let verbs: UInt16
    let array: UInt16
    let inventoryObjects: UInt16
}

extension MAXS {
    
    static func create(from buffer: [UInt8]) -> MAXS {
        MAXS(
            blockName: buffer.dwordLE(0),
            blockSize: buffer.dwordBE(4),
            variables: buffer.wordLE(8),
            unknown: buffer.wordLE(10),
            bitVariables: buffer.wordLE(12),
            localObjects: buffer.wordLE(14),
            newNames: buffer.wordLE(16),
            characterSets: buffer.wordLE(18),
            verbs: buffer.wordLE(20),
            array: buffer.wordLE(22),
            inventoryObjects: buffer.wordLE(24)
        )
    }
    
    static var empty: MAXS {
        MAXS(
            blockName: 0,
            blockSize: 0,
            variables: 0,
            unknown: 0,
            bitVariables: 0,
            localObjects: 0,
            newNames: 0,
            characterSets: 0,
            verbs: 0,
            array: 0,
            inventoryObjects: 0
        )
    }
}
