//
//  V5_Opcodes_move.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 13/07/2023.
//

import Foundation

extension OpcodesV5 {
    
    var move: Opcode {
        
        let result = resultVariableNumber()
        let value = variableValue()
        
        vm.variables[result] = value
        
        let variable = Variables(rawValue: result)?.stringValue ?? "Var[\(result)]"
        
        return Opcode(
            offset: UInt16(vm.instructionPointer),
            opcode: vm.bytecode![vm.instructionPointer],
            instruction: "move",
            command: "\(variable) = \(value)",
            process: nil
        )
    }
}
