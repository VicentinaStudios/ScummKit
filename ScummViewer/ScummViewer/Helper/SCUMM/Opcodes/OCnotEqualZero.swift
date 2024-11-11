//
//  OCnotEqualZero.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 20/08/2023.
//

import Foundation

import Foundation

extension OpcodesV5 {
    
    var notEqualZero: Opcode {
        
        let variableId = vm.bytecode!.wordLE(updatedOffset)
        offset += 2
        
        let value = vm.variables[variableId]
        
        relativeJump(condition: value != 0)
        
        let notZero = Variables(rawValue: variableId)?.stringValue ?? "\0x8Var[\(variableId)] != 0"
        
        let command: String
        
        // NOTE: Hack to prevent crash
        if updatedOffset > 0xffff {
            command = "unless (\(notZero)) goto [unknown])"
        } else {
            command = "unless (\(notZero)) goto \(UInt16(branchToAddress).hex.uppercased()))"
        }
        
        
        
        return Opcode(
            offset: UInt16(vm.instructionPointer),
            opcode: vm.bytecode![vm.instructionPointer],
            instruction: "notEqualZero",
            command: command,
            process: nil
        )
    }
}
