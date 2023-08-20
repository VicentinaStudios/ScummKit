//
//  OClessOrEqual.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 20/08/2023.
//

extension OpcodesV5 {
    
    var lessOrEqual: Opcode {
        
        let variableId = vm.bytecode!.wordLE(updatedOffset)
        offset += 2
        
        let variable = readVariable(for: variableId)
        
        let value = vm.bytecode!.wordLE(updatedOffset)
        offset += 2
        
        relativeJump(condition: variable! <= value)
        
        let isEqual = Variables(rawValue: variableId)?.stringValue ?? "Var[\(variableId)]"
        
        let command = "unless (\(isEqual) >= \(value)) goto \(UInt16(min(branchToAddress, 0xffff)).hex.uppercased())"
        
        return Opcode(
            offset: UInt16(vm.instructionPointer),
            opcode: vm.bytecode![vm.instructionPointer],
            instruction: "lessOrEqual",
            command: command,
            process: nil
        )
    }
}
