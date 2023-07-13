//
//  ScriptsV5.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 12/07/2023.
//

import Foundation


class OpcodesV5 {
    
    let bytecode: [UInt8]
    
    var variables: Dictionary<UInt16, UInt16> = [:]
    
    enum StackValue {
        case literal(UInt16)
        case variable(id: UInt16, value: UInt16)
        
        var value: UInt16 {
            switch self {
            case .literal(let value):
                return value
            case .variable(_, let value):
                return value
            }
        }

        var id: UInt16? {
            switch self {
            case .literal:
                return nil
            case .variable(let id, _):
                return id
            }
        }
    }
    
    var stack: [StackValue] = []
    
    private var instructionOffset = 0
    private var position: Int = 0
    var updatedOffset: Int { instructionOffset + position }
    
    init(for bytecode: [UInt8]) {
        self.bytecode = bytecode
    }
    
    func interpret(offset: Int) -> Opcode {
        
        instructionOffset = offset
        
        let opcode = bytecode[offset]
        position = 1
        
        switch opcode {
        
        case 0x0c:
            return resourceRoutines
        case 0x1a:
            return move
        case 0x26:
            return setVarRange
        case 0x27:
            return stringOps
        case 0x2c:
            return cursorCommand
        case 0xac:
            return expression
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
        let result = bytecode.wordLE(updatedOffset)
        position += 2
        return result
    }
    
    func variableValue() -> UInt16 {
        let value = bytecode.wordLE(updatedOffset)
        position += 2
        return value
    }
}

// MARK: Opcodes

extension OpcodesV5 {
    
    var resourceRoutines: Opcode {
        
        let subOpcode = bytecode[updatedOffset]
        position += 1
        
        let resourceId = (0x00...0x10).contains(subOpcode) || [0x12, 0x13].contains(subOpcode)
            ? bytecode[updatedOffset] : nil
        if let _ = resourceId { position += 1 }
        
        let room = subOpcode == 0x14 ? bytecode[updatedOffset] : nil
        if let _ = room { position += 1 }
        let object = subOpcode == 0x14 ? bytecode.wordLE(updatedOffset) : nil
        if let _ = object { position += 2 }
        
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
            offset: UInt16(instructionOffset),
            opcode: bytecode[instructionOffset],
            instruction: "resourceRoutines",
            command: command,
            process: nil
        )
    }
    
    var move: Opcode {
        
        let result = resultVariableNumber()
        let value = variableValue()
        
        variables[result] = value
        
        let variable = Variables(rawValue: result)?.stringValue ?? "Var[\(result)]"
        
        return Opcode(
            offset: UInt16(instructionOffset),
            opcode: bytecode[instructionOffset],
            instruction: "move",
            command: "\(variable) = \(value)",
            process: nil
        )
    }
    
    var setVarRange: Opcode {
        
        let result = resultVariableNumber()
        
        let length = bytecode[updatedOffset]
        position += 1
        
        let array = (0..<Int(length)).map {
            bytecode[updatedOffset + $0]         // NOTE: This can also be a word
        }
        position += array.count
        
        let arrayString = array.map { "\($0)" }.joined(separator: ",")
        
        return Opcode(
            offset: UInt16(instructionOffset),
            opcode: bytecode[instructionOffset],
            instruction: "setVarRange",
            command: "setVarRange(Var[\(result)], \(length), [\(arrayString)])",
            process: nil
        )
    }
    
    var stringOps: Opcode {
        
        let subOpcode = bytecode[updatedOffset]
        position += 1
        
        let command: String?
        
        switch subOpcode {
        case 0x1:
            
            let stringId = bytecode[updatedOffset]
            position += 1
            
            let string = bytecode[updatedOffset...].prefix(while: { $0 != 0 }).map { String($0.char) }.joined()
            
            position += string.count + 1
            
            command = "PutCodeInString(\(stringId), \"\(string)\")"
            
        case 0x2:
            command = "CopyString"
        case 0x3:
            
            let stringId = bytecode[updatedOffset]
            position += 1
            
            let index = bytecode[updatedOffset]
            position += 1
            
            let character = bytecode[updatedOffset]
            position += 1
            
            command = "SetStringChar(\(stringId), \(index), \(character))"
        case 0x4:
            command = "GetStringChar"
        case 0x5:
            
            let stringId = bytecode[updatedOffset]
            position += 1
            
            let size = bytecode[updatedOffset]
            position += 1
            
            command = "CreateString(\(stringId), \(size))"
        default:
            command = nil
        }
        
        return Opcode(
            offset: UInt16(instructionOffset),
            opcode: bytecode[instructionOffset],
            instruction: "stringOps",
            command: command,
            process: nil
        )
    }
    
    var cursorCommand: Opcode {
        
        let subOpcode = bytecode[updatedOffset]
        position += 1
        
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
            
            let cursorNumber = bytecode[updatedOffset]
            position += 1
            
            let characterLetter = bytecode[updatedOffset]
            position += 1
            
            command = "SetCursorImg(\(cursorNumber), \(characterLetter))"
        case 0x0b:
            
            let index = bytecode[updatedOffset]
            position += 1
            
            let x = bytecode[updatedOffset]
            position += 1
            
            let y = bytecode[updatedOffset]
            position += 1
            
            command = "SetCursorHotspot(\(index), \(x), \(y))"
        case 0x0c:
            
            let cursor = bytecode[updatedOffset]
            position += 1
            
            command = "InitCursor(\(cursor))"
        case 0x0d:
            
            let charset = bytecode[updatedOffset]
            position += 1
            
            command = "InitCharset(\(charset))"
        case 0x0e:
            command = "CursorCommand (unknown)"
        default:
            command = nil
        }
        
        return Opcode(
            offset: UInt16(instructionOffset),
            opcode: bytecode[instructionOffset],
            instruction: "cursorCommand",
            command: "\(command ?? "")",
            process: nil
        )
    }
    
    var expression: Opcode {
        
        let result = resultVariableNumber()
        
        var expr = ""
        
        var subOpcode = bytecode[updatedOffset]
        position += 1
        
        while subOpcode != 0xff {
            
            switch subOpcode & 0x1F {
            case 0x1:
                
                if ((subOpcode & 0x80) != 0) {
                    
                    let variableId = bytecode.wordLE(updatedOffset)
                    position += 2
                    
                    if let value = variables[variableId] {
                        stack.append(StackValue.variable(id: variableId, value: value))
                    }
                    
                } else {
                    let value = bytecode.wordLE(updatedOffset)
                    position += 2
                    stack.append(StackValue.literal(value))
                }
                
            case 0x2:
                
                guard stack.count >= 2 else {
                    expr = "stack overflow"
                    break
                }
                
                let head = stack.removeLast()
                let penultimate = stack.removeLast()
                
                let result = penultimate.value + head.value
                stack.append(StackValue.literal(result))
                
                let leftExpr: String
                if let leftValue = penultimate.id {
                    leftExpr = "Var[\(leftValue)]"
                } else {
                    leftExpr = "\(penultimate.value)"
                }

                let rightExpr: String
                if let rightValue = head.id {
                    rightExpr = "Var[\(rightValue)]"
                } else {
                    rightExpr = "\(head.value)"
                }

                expr = "\(leftExpr) + \(rightExpr)"
                
            
            case 0x3:
                
                guard stack.count >= 2 else {
                    expr = "unknown"
                    break
                }
                
                let head = stack.removeLast()
                let penultimate = stack.removeLast()
                
                guard penultimate.value >= head.value else {
                    expr = "overflows"
                    break
                }
                
                let result = penultimate.value - head.value
                stack.append(StackValue.literal(result))
                
                
                let leftExpr: String
                if let leftValue = penultimate.id {
                    leftExpr = "Var[\(leftValue)]"
                } else {
                    leftExpr = "\(penultimate.value)"
                }

                let rightExpr: String
                if let rightValue = head.id {
                    rightExpr = "Var[\(rightValue)]"
                } else {
                    rightExpr = "\(head.value)"
                }

                expr = "\(leftExpr) - \(rightExpr)"
                
            case 0x4:
                
                guard stack.count >= 2 else {
                    expr = "unknown"
                    break
                }
                
                let head = stack.removeLast()
                let penultimate = stack.removeLast()
                
                let result = penultimate.value &* head.value
                stack.append(StackValue.literal(result))
                
                let leftExpr: String
                if let leftValue = penultimate.id {
                    leftExpr = "Var[\(leftValue)]"
                } else {
                    leftExpr = "\(penultimate.value)"
                }

                let rightExpr: String
                if let rightValue = head.id {
                    rightExpr = "Var[\(rightValue)]"
                } else {
                    rightExpr = "\(head.value)"
                }

                expr = "\(leftExpr) * \(rightExpr)"
                
            case 0x5:
                
                guard stack.count >= 2 else {
                    expr = "unknown"
                    break
                }
                
                let head = stack.removeLast()
                let penultimate = stack.removeLast()
                
                guard head.value == 0 else {
                    expr = "division by 0"
                    break
                }
                
                let result = penultimate.value / head.value
                stack.append(StackValue.literal(result))
                
                let leftExpr: String
                if let leftValue = penultimate.id {
                    leftExpr = "Var[\(leftValue)]"
                } else {
                    leftExpr = "\(penultimate.value)"
                }

                let rightExpr: String
                if let rightValue = head.id {
                    rightExpr = "Var[\(rightValue)]"
                } else {
                    rightExpr = "\(head.value)"
                }

                expr = "\(leftExpr) / \(rightExpr)"
                
            default:
                break
            }
         
            subOpcode = bytecode[updatedOffset]
            position += 1
        }
        
        let variable = Variables(rawValue: result)?.stringValue ?? "Var[\(result)]"
        
        return Opcode(
            offset: UInt16(instructionOffset),
            opcode: bytecode[instructionOffset],
            instruction: "expression",
            command: "Exprmode \(variable) = (\(expr))",
            process: nil
        )
    }
}

// MARK: Variables

enum Variables: UInt16  {
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
    case VAR_RESTART_KEY = 42
    case VAR_PAUSE_KEY = 43
    case VAR_MAINMENU_KEY = 50
    case VAR_FIXEDDISK = 51
    case VAR_TALKSTOP_KEY = 57
    
    var stringValue: String {
        return String(describing: self)
    }
}
