//
//  OCbreakHere.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 15/07/2023.
//

import Foundation

extension OpcodesV5 {
    
    var breakHere: Opcode {
        
        return Opcode(
            offset: UInt16(vm.instructionPointer),
            opcode: vm.bytecode![vm.instructionPointer],
            instruction: "breakHere",
            command: "breakHere()",
            process: nil
        )
    }
}
