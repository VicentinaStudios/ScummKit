//
//  OCdelay.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 20/08/2023.
//

import Foundation

extension OpcodesV5 {
    
    var delay: Opcode {
        
        let delayUnits = vm.bytecode!.dwordLE(updatedOffset)     // 1/60th
        offset += 3
        
        let command = "delay(\(delayUnits & 0xffffff))"
        
        return Opcode(
            offset: UInt16(vm.instructionPointer),
            opcode: vm.bytecode![vm.instructionPointer],
            instruction: "delay",
            command: command,
            process: nil
        )
    }
}
