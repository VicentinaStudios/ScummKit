//
//  OCcursorCommand.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 13/07/2023.
//

import Foundation

extension OpcodesV5 {
    
    var cursorCommand: Opcode {
        
        let subOpcode = vm.bytecode![updatedOffset]
        offset += 1
        
        let command: String?
        
        switch subOpcode {
        case 0x01:
            command = "CursorShow()"
        case 0x02:
            command = "CursorHide()"
        case 0x03:
            command = "UserputOn()"
        case 0x04:
            command = "UserputOff()"
        case 0x05:
            command = "CursorSoftOn()"
        case 0x06:
            command = "CursorSoftOff()"
        case 0x07:
            command = "UserputSoftOn()"
        case 0x08:
            command = "UserputSoftOff()"
        case 0x0a:
            
            let cursorNumber = vm.bytecode![updatedOffset]
            offset += 1
            
            let characterLetter = vm.bytecode![updatedOffset]
            offset += 1
            
            command = "SetCursorImg(\(cursorNumber), \(characterLetter))"
        case 0x0b:
            
            let index = vm.bytecode![updatedOffset]
            offset += 1
            
            let x = vm.bytecode![updatedOffset]
            offset += 1
            
            let y = vm.bytecode![updatedOffset]
            offset += 1
            
            command = "SetCursorHotspot(\(index), \(x), \(y))"
        case 0x0c:
            
            let cursor = vm.bytecode![updatedOffset]
            offset += 1
            
            command = "InitCursor(\(cursor))"
        case 0x0d:
            
            let charset = vm.bytecode![updatedOffset]
            offset += 1
            
            command = "InitCharset(\(charset))"
        case 0x0e:
            command = "CursorCommand (unknown)"
        default:
            command = nil
        }
        
        return Opcode(
            offset: UInt16(vm.instructionPointer),
            opcode: vm.bytecode![vm.instructionPointer],
            instruction: "cursorCommand",
            command: "\(command ?? "")",
            process: nil
        )
    }
}
