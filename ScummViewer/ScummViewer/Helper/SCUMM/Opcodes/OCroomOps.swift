//
//  OCroomOps.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 13/07/2023.
//

import Foundation

extension OpcodesV5 {
    
    var roomOps: Opcode {
        
        let subOpcode = vm.bytecode![updatedOffset]
        offset += 1
        
        let command: String?
        
        switch subOpcode {
        case 0x1:
            
            let minX = vm.bytecode!.wordLE(updatedOffset)
            offset += 2
            
            let maxX = vm.bytecode!.wordLE(updatedOffset)
            offset += 2
            
            command = "RoomScroll(\(minX), \(maxX))"
            
        case 0x3:
            
            let b = vm.bytecode!.wordLE(updatedOffset)
            offset += 2
            
            let h = vm.bytecode!.wordLE(updatedOffset)
            offset += 2
            
            command = "SetScreen(\(b), \(h))"
            
        case 0x5:
            
            command = "ShakeOn()"
            
        case 0x6:
            
            command = "ShakeOff()"
            
        case 0x0a:
            
            let effect = vm.bytecode!.wordLE(updatedOffset)
            offset += 2
            
            let effectType: String
            
            switch effect {
            case 0:
                effectType = "[fade in]"
            case 1:
                effectType = "[iris ]"
            case 2:
                effectType = "[box wipe (UL->BR)]"
            case 3:
                effectType = "[box wipe (UR->BL)]"
            case 4:
                effectType = "[inverse box wipe]"
            default:
                effectType = "[unkown]"
            }
            
            command = "screenEffect(\(Int(effect))) \(effectType)"
            
        default:
            command = nil
        }
        
        return Opcode(
            offset: UInt16(vm.instructionPointer),
            opcode: vm.bytecode![vm.instructionPointer],
            instruction: "roomOps",
            command: command,
            process: nil)
    }
}
