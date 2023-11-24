//
//  Chunk.swift
//  ScummCompiler
//
//  Created by Michael Borgmann on 24/11/2023.
//

import Foundation

enum Opcode: UInt8 {
    case `return`
    case constant
}

struct Chunk {
    
    var code: [UInt8] = []
    var lines: [Int] = []
    var constants = ValueArray()
    
    mutating func write(byte: UInt8, line: Int) {
        code.append(byte)
        lines.append(line)
    }
    
    mutating func addConstant(value: Value) -> Int{
        constants.write(value: value)
        return constants.values.count
    }
}


