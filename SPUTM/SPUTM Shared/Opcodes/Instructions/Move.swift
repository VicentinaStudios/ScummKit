//
//  Move.swift
//  SPUTM
//
//  Created by Michael Borgmann on 24/11/2023.
//

import Foundation
import ScummCore

struct Move: InstructionProtocol {
    
    var version: ScummVersion
    var opcode: UInt8
    let instruction = "move"
    
    func execute() {
        debugPrint("Move", version, opcode)
    }
    
    func decompile(at instructionPointer: Int) -> String {
        "variable = value"
    }
}
