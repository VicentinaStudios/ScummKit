//
//  OCisEqual.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 15/07/2023.
//

import Foundation

extension OpcodesV5 {
    
    var isEqual: Opcode {
        
        let variableId = vm.bytecode!.wordLE(updatedOffset)
        offset += 2
        
//        let variable = vm.variables[variableId] ?? 0
        let variable = readVariable(for: variableId)
        
        let value = vm.bytecode!.wordLE(updatedOffset)
        offset += 2
        
        relativeJump(condition: variable == value)
        
        let isEqual = Variables(rawValue: variableId)?.stringValue ?? "Var[\(variableId)]"
        
        let command = "unless (\(isEqual) == \(value) goto \(UInt16(updatedOffset).hex.uppercased())"
        
        return Opcode(
            offset: UInt16(vm.instructionPointer),
            opcode: vm.bytecode![vm.instructionPointer],
            instruction: "isEqual",
            command: command,
            process: nil
        )
    }
}
