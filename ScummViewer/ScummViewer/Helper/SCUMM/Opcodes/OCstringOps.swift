//
//  OCstringOps.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 13/07/2023.
//

import Foundation

extension OpcodesV5 {
    
    var stringOps: Opcode {
        
        let subOpcode = vm.bytecode![updatedOffset]
        offset += 1
        
        let command: String?
        
        switch subOpcode {
        case 0x1:
            
            let stringId = vm.bytecode![updatedOffset]
            offset += 1
            
            let string = vm.bytecode![updatedOffset...].prefix(while: { $0 != 0 }).map { String($0.char) }.joined()
            
            offset += string.count + 1
            
            command = "PutCodeInString(\(stringId), \"\(string)\")"
            
        case 0x2:
            command = "CopyString"
        case 0x3:
            
            let stringId = vm.bytecode![updatedOffset]
            offset += 1
            
            let index = vm.bytecode![updatedOffset]
            offset += 1
            
            let character = vm.bytecode![updatedOffset]
            offset += 1
            
            command = "SetStringChar(\(stringId), \(index), \(character))"
        case 0x4:
            command = "GetStringChar"
        case 0x5:
            
            let stringId = vm.bytecode![updatedOffset]
            offset += 1
            
            let size = vm.bytecode![updatedOffset]
            offset += 1
            
            command = "CreateString(\(stringId), \(size))"
        default:
            command = nil
        }
        
        return Opcode(
            offset: UInt16(vm.instructionPointer),
            opcode: vm.bytecode![vm.instructionPointer],
            instruction: "stringOps",
            command: command,
            process: nil
        )
    }
}
