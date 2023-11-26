//
//  main.swift
//  ScummCompiler
//
//  Created by Michael Borgmann on 24/11/2023.
//

import Foundation

let DEBUG_TRACE_EXECUTION = true

var virtualMachine = VirtualMachine()

var chunk = Chunk()

var constant = chunk.addConstant(value: 1.2)
chunk.write(byte: Opcode.constant.rawValue, line: 123)
chunk.write(byte: UInt8(constant), line: 123)

constant = chunk.addConstant(value: 3.4)
chunk.write(byte: Opcode.constant.rawValue, line: 123)
chunk.write(byte: UInt8(constant), line: 123)

chunk.write(byte: Opcode.add.rawValue, line: 123)

constant = chunk.addConstant(value: 5.6)
chunk.write(byte: Opcode.constant.rawValue, line: 123)
chunk.write(byte: UInt8(constant), line: 123)

chunk.write(byte: Opcode.divide.rawValue, line: 123)

chunk.write(byte: Opcode.negate.rawValue, line: 123)

chunk.write(byte: Opcode.return.rawValue, line: 123)

disassembleChunk(chunk: chunk, name: "test chunk")

virtualMachine.interpret(chunk: chunk)
