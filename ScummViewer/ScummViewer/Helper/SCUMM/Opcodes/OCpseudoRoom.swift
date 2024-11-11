//
//  pseudoRoom.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 15/07/2023.
//

import Foundation

extension OpcodesV5 {
    
    var pseudoRoom: Opcode {
        
        guard let bytecode = vm.bytecode else {
            fatalError()
        }
        
        let baseRoom = bytecode[updatedOffset]
        offset += 1
        
        var pseudoRooms: [UInt8]?
        
        while
            let room = vm.bytecode?[updatedOffset],
            room != 0
        {
            offset += 1
            
            if pseudoRooms?.append(room & 0x7F) == nil {
                pseudoRooms = [room & 0x7F]
            }
        }
        
        offset += 1
        
        let command: String
        if let rooms = pseudoRooms {
            
            let pseudoRooms = rooms.compactMap { String($0) }.joined(separator: ",")
            
            command = "PseudoRoom(\(baseRoom), \(pseudoRooms))"
            
        } else {
            command = "PseudoRoom(\(baseRoom))"
        }
        
        return Opcode(
            offset: UInt16(vm.instructionPointer),
            opcode: vm.bytecode![vm.instructionPointer],
            instruction: "pseudoRoom",
            command: command,
            process: nil
        )
    }
}
