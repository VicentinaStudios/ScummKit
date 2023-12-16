//
//  File.swift
//  
//
//  Created by Michael Borgmann on 15/12/2023.
//

import Foundation

struct Decompilation {
    let offset: Int
    let opcode: Opcode
}

class Decompiler {
    
    private var chunk: Chunk?
    private var offset: Array.Index?
    private var decompilation: [Decompilation]?
    
    private func reset(with chunk: Chunk) {
        self.chunk = chunk
        offset = 0
        decompilation?.removeAll()
        decompilation = nil
    }
        
    func decompile(_ chunk: Chunk) throws -> [Decompilation]? {
        
        reset(with: chunk)
        
        while let current = offset, current < chunk.size {
            
            let instruction = try decompileInstruction(at: current)
            decompilation = (decompilation ?? []) + [instruction]
        }
        
        return decompilation
    }
    
    func prettyPrint() {
        
        decompilation?.forEach { instruction in
            
            let offset = String(format: "%04d", instruction.offset)
            print(offset, instruction.opcode.name)
        }
    }
    
    private func decompileInstruction(at offset: Int) throws -> Decompilation {
        
        guard let instruction = try chunk?.read(at: offset) else {
            throw CompilerError.cantFetchInstruction(offset)
        }
        
        guard let opcode = Opcode(rawValue: instruction) else {
            throw CompilerError.unknownOpcode(instruction)
        }
        
        switch opcode {
        case .breakHere:
            return try simpleInstruction(opcode: .breakHere)
        }
    }
    
    private func simpleInstruction(opcode: Opcode) throws -> Decompilation {
        
        guard var offset = offset else {
            throw CompilerError.unknownOffset
        }
        
        let decompilation = Decompilation(offset: offset, opcode: opcode)
        
        self.offset = offset + 1
        
        return decompilation
    }
}
