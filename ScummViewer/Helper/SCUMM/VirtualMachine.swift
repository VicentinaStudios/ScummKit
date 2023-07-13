//
//  VirtualMachine.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 12/07/2023.
//

import Foundation

struct Opcode {
    let offset: UInt16
    let opcode: UInt8
    let instruction: String?
    let command: String?
    let process: UInt8?
}

class VirtualMachine: ObservableObject {
    
    private var bytecode: [UInt8]? = nil
    @Published var opcodes: [Opcode]? = nil
    
    func loadBytecode(with bytecode: [UInt8]) {
        self.bytecode = bytecode
    }
    
    func decompile() {
        
        guard
            let bytecode = bytecode,
            !bytecode.isEmpty
        else {
            debugPrint("No bytecode")
            return
        }
        
        var offset: Int = 0
        opcodes = []
        let engine = OpcodesV5(for: bytecode)
        
        while offset < bytecode.count {
            
            let opcode = engine.interpret(offset: offset)
            opcodes?.append(opcode)
            
            offset = engine.updatedOffset
        }
    }
}
