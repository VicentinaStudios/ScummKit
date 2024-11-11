//
//  OCloadRoom.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 19/08/2023.
//

import Foundation

extension OpcodesV5 {
    
    var loadRoom: Opcode {
        
        let room = vm.bytecode![updatedOffset]
        offset += 1
        
        let command = "loadRoom(\(room))"
        
        return Opcode(
            offset: UInt16(vm.instructionPointer),
            opcode: vm.bytecode![vm.instructionPointer],
            instruction: "loadRoom",
            command: command,
            process: nil
        )
    }
}
