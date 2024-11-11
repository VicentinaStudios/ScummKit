//
//  V5_Opcodes_resourceRoutines.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 13/07/2023.
//

import Foundation

extension OpcodesV5 {
    
    var resourceRoutines: Opcode {
        
        let subOpcode = vm.bytecode![updatedOffset]
        offset += 1
        
        let resourceId = (0x00...0x10).contains(subOpcode) || [0x12, 0x13].contains(subOpcode)
        ? vm.bytecode![updatedOffset] : nil
        if let _ = resourceId { offset += 1 }
        
        let room = subOpcode == 0x14 ? vm.bytecode![updatedOffset] : nil
        if let _ = room { offset += 1 }
        let object = subOpcode == 0x14 ? vm.bytecode!.wordLE(updatedOffset) : nil
        if let _ = object { offset += 2 }
        
        let command: String?
        
        switch subOpcode {
        case 0x01:
            command = "Resource.loadScript(\(resourceId!))"
        case 0x02:
            command = "Resource.loadSound(\(resourceId!))"
        case 0x03:
            command = "Resource.loadCostume(\(resourceId!))"
        case 0x04:
            command = "Resource.loadRoom(\(resourceId!))"
        case 0x05:
            command = "Resource.nukeScript(\(resourceId!))"
        case 0x06:
            command = "Resource.nukeSound(\(resourceId!))"
        case 0x07:
            command = "Resource.nukeCostume(\(resourceId!))"
        case 0x08:
            command = "Resource.nukeRoom(\(resourceId!))"
        case 0x09:
            command = "Resource.lockScript(\(resourceId!))"
        case 0x0a:
            command = "Resource.lockSound(\(resourceId!))"
        case 0x0b:
            command = "Resource.lockCostume(\(resourceId!))"
        case 0x0c:
            command = "Resource.lockRoom(\(resourceId!))"
        case 0x0d:
            command = "Resource.unlockScript(\(resourceId!))"
        case 0x0e:
            command = "Resource.unlockSound(\(resourceId!))"
        case 0x0f:
            command = "Resource.unlockCostume(\(resourceId!))"
        case 0x10:
            command = "Resource.unlockRoom(\(resourceId!))"
        case 0x11:
            command = "Resource.clearHeap"
        case 0x12:
            command = "Resource.loadCharset(\(resourceId!))"
        case 0x13:
            command = "Resource.nukeCharset(\(resourceId!))"
        case 0x14:
            command = "Resource.loadFlObject(\(room!),\(object!))"
        case 0x20:
            command = "unknown"
        case 0x21:
            command = "unknown"
        case 0x23:
            command = "Resource.setCDVolume(\(resourceId!)) [unknown]"
        case 0x24:
            command = "Resource.setSoundLoudness(\(resourceId!)) [unknown]"
        case 0x25:
            command = "Resource.setSoundPitch(\(resourceId!)) [unknown]"
        default:
            command = nil
        }
        
        return Opcode(
            offset: UInt16(vm.instructionPointer),
            opcode: vm.bytecode![vm.instructionPointer],
            instruction: "resourceRoutines",
            command: command,
            process: nil
        )
    }
}
