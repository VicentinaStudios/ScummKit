//
//  OCincrement.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 20/08/2023.
//

import Foundation

extension OpcodesV5 {
    
    var increment: Opcode {
        
        let result = resultVariableNumber()
        
        if vm.variables[result] != nil {
            vm.variables[result]! += 1
        } else {
            vm.variables[result] = 1
        }
        
        let variable = Variables(rawValue: result)?.stringValue ?? "Var[\(result)]"
        
        let command = "\(variable)++"
        
        return Opcode(
            offset: UInt16(vm.instructionPointer),
            opcode: vm.bytecode![vm.instructionPointer],
            instruction: "increment",
            command: command,
            process: nil
        )
    }
}
