//
//  ScriptsV5.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 12/07/2023.
//

import Foundation


class OpcodesV5 {
    
    internal let vm: VirtualMachine
    internal var offset: Int = 0
    
    var updatedOffset: Int { vm.instructionPointer + offset }
    var branchToAddress: Int = 0
    
    init(vm: VirtualMachine) {
        self.vm = vm
    }
    
    func interpret() -> Opcode {
        
        guard let bytecode = vm.bytecode else {
            fatalError()
        }
        
        let opcode = bytecode[vm.instructionPointer]
        offset = 1
        
        switch opcode {
        
        case 0x04:
            return isGreaterEqual
        case 0x08:
            return isNotEqual
        case 0x0a:
            return startScript
        case 0x0c:
            return resourceRoutines
        case 0x16:
            return getRandomNumber
        case 0x18:
            return jumpRelative
        case 0x1a, 0x9a:
            return move
        case 0x26:
            return setVarRange
        case 0x27:
            return stringOps
        case 0x28:
            return equalZero
        case 0x2c:
            return cursorCommand
        case 0x2e:
            return delay
        case 0x33:
            return roomOps
        case 0x38:
            return lessOrEqual
        case 0x44:
            return isLess
        case 0x46:
            return increment
        case 0x48, 0xc8:
            return isEqual
        case 0x72:
            return loadRoom
        case 0x80:
            return breakHere
        case 0xac:
            return expression
        case 0xa8:
            return notEqualZero
        case 0xa0:
            return stopObjectCode
        case 0xcc:
            return pseudoRoom
        default:
            return Opcode(
                offset: UInt16(offset),
                opcode: opcode,
                instruction: nil,
                command: nil,
                process: nil
            )
        }
    }
}

// MARK: Helpers

extension OpcodesV5 {
    
    func resultVariableNumber() -> UInt16 {
        let result = vm.bytecode!.wordLE(updatedOffset)
        offset += 2
        return result
    }
    
    func variableValue() -> UInt16 {
        let value = vm.bytecode!.wordLE(updatedOffset)
        offset += 2
        return value
    }
    
    internal func relativeJump(condition: Bool) {
        let relativeOffset = vm.bytecode!.wordLE(updatedOffset)
        offset += 2
        
        if condition == false {   
            //offset += Int(relativeOffset)
            branchToAddress = Int(relativeOffset) + updatedOffset
        }
    }
    
    func readVariable(for variableId: UInt16) -> UInt16? {
        
        var variableId = variableId
        
        if variableId & 0x4000 != 0 {
            variableId &= 0xFFF;
        }
        
        let currentScript = 0       // NOTE: Hack to remember intention
        
        guard variableId < vm.localVariables[currentScript].count else {
            return nil
        }
        
        return vm.localVariables[currentScript][Int(variableId)]
    }
}

// MARK: Variables

enum Variables: UInt16, CaseIterable  {
    case VAR_MACHINE_SPEED = 6
    case VAR_NUM_ACTOR = 8
    case VAR_TIMER_NEXT = 19
    case VAR_CUTSCENEEXIT_KEY = 24
    case VAR_ENTRY_SCRIPT = 28
    case VAR_ENTRY_SCRIPT2 = 29
    case VAR_EXIT_SCRIPT = 30
    case VAR_VERB_SCRIPT = 32
    case VAR_SENTENCE_SCRIPT = 33
    case VAR_INVENTORY_SCRIPT = 34
    case VAR_CUTSCENE_START_SCRIPT = 35
    case VAR_CUTSCENE_END_SCRIPT = 36
    case VAR_CHARINC = 37
    case VAR_DEBUGMODE = 39
    case VAR_RESTART_KEY = 42
    case VAR_PAUSE_KEY = 43
    case VAR_MAINMENU_KEY = 50
    case VAR_FIXEDDISK = 51
    case VAR_TALKSTOP_KEY = 57
    
    var stringValue: String {
        return String(describing: self)
    }
}
