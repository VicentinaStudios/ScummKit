//
//  OCjumpRelative.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 20/08/2023.
//

import Foundation

extension OpcodesV5 {
    
    var jumpRelative: Opcode {
        
        let target = vm.bytecode?.wordLE(updatedOffset)
        offset += 2
        
        let address = Int(target ?? 0) + vm.instructionPointer
        
        let command = "goto \(address)"
        
        return Opcode(
            offset: UInt16(vm.instructionPointer),
            opcode: vm.bytecode![vm.instructionPointer],
            instruction: "jumpRelative",
            command: command,
            process: nil
        )
    }
}
