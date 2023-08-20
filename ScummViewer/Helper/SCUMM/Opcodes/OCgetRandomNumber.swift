//
//  OCgetRandomNumber.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 20/08/2023.
//

import Foundation

extension OpcodesV5 {
    
    var getRandomNumber: Opcode {
        
        let result = resultVariableNumber()
        
        let seed = vm.bytecode![updatedOffset]
        offset += 1
        
        vm.variables[result] = UInt16(seed)
        
        let variable = Variables(rawValue: result)?.stringValue ?? "Local[\(result)]"
        
        let command = "\(variable) = getRandomNr(\(seed))"
        
        return Opcode(
            offset: UInt16(vm.instructionPointer),
            opcode: vm.bytecode![vm.instructionPointer],
            instruction: "getRandomNumber",
            command: command,
            process: nil
        )
    }
}
