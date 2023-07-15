//
//  OCsetVarRange.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 13/07/2023.
//

import Foundation

extension OpcodesV5 {
    
    var setVarRange: Opcode {
        
        let result = resultVariableNumber()
        
        let length = vm.bytecode![updatedOffset]
        offset += 1
        
        let array = (0..<Int(length)).map {
            vm.bytecode![updatedOffset + $0]         // NOTE: This can also be a word
        }
        offset += array.count
        
        let arrayString = array.map { "\($0)" }.joined(separator: ",")
        
        return Opcode(
            offset: UInt16(vm.instructionPointer),
            opcode: vm.bytecode![vm.instructionPointer],
            instruction: "setVarRange",
            command: "setVarRange(Var[\(result)], \(length), [\(arrayString)])",
            process: nil
        )
    }
}
