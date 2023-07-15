//
//  OCstartScript.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 13/07/2023.
//

import Foundation

extension OpcodesV5 {
    
    var startScript: Opcode {
        
        let scriptId = vm.bytecode![updatedOffset]
        offset += 1
        
        var command = "startScript"
        var args: [UInt16] = []
        
        while vm.bytecode![updatedOffset] != 0xff {
            
            // NOTE: This is just a hack to prevent a crash be endless looping
            if args.count > 25 {
                offset = 0
                command += " [invalid]"
                break
            }
            
            let arg = vm.bytecode!.wordLE(updatedOffset)
            offset += 2
            args.append(arg)
        }
        
        offset += 1
        
        command += "(\(scriptId), [\(args.map { String($0) }.joined(separator: ","))])"
        
        return Opcode(
            offset: UInt16(vm.instructionPointer),
            opcode: vm.bytecode![vm.instructionPointer],
            instruction: "startScript",
            command: command,
            process: nil
        )
    }
}
