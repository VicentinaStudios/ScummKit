//
//  OCstopObjectCode.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 20/08/2023.
//

import Foundation

extension OpcodesV5 {
    
    var stopObjectCode: Opcode {
        return Opcode(
            offset: UInt16(vm.instructionPointer),
            opcode: vm.bytecode![vm.instructionPointer],
            instruction: "stopObjectCode",
            command: "stopObjectCode()",
            process: nil
        )
    }
}
