//
//  main.swift
//  ScummCompiler
//
//  Created by Michael Borgmann on 24/11/2023.
//

import Foundation

var chunk = Chunk()

let constant = chunk.addConstant(value: 1.2)
chunk.write(byte: Opcode.constant.rawValue, line: 123)
chunk.write(byte: UInt8(constant), line: 123)

chunk.write(byte: Opcode.return.rawValue, line: 123)

disassembleChunk(chunk: chunk, name: "test chunk")
