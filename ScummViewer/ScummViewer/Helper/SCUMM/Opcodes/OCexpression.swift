//
//  OCexpression.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 13/07/2023.
//

import Foundation

extension OpcodesV5 {
    
    var expression: Opcode {
        
        let result = resultVariableNumber()
        
        var expr = ""
        
        var subOpcode = vm.bytecode![updatedOffset]
        offset += 1
        
        while subOpcode != 0xff {
            
            switch subOpcode & 0x1F {
            case 0x1:
                
                if ((subOpcode & 0x80) != 0) {
                    
                    let variableId = vm.bytecode!.wordLE(updatedOffset)
                    offset += 2
                    
                    if let value = vm.variables[variableId] {
                        vm.stack.append(VirtualMachine.StackValue.variable(id: variableId, value: value))
                    }
                    
                } else {
                    let value = vm.bytecode!.wordLE(updatedOffset)
                    offset += 2
                    vm.stack.append(VirtualMachine.StackValue.literal(value))
                }
                
            case 0x2:
                
                guard vm.stack.count >= 2 else {
                    expr = "stack overflow"
                    break
                }
                
                let head = vm.stack.removeLast()
                let penultimate = vm.stack.removeLast()
                
                let result = penultimate.value + head.value
                vm.stack.append(VirtualMachine.StackValue.literal(result))
                
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
                
                guard vm.stack.count >= 2 else {
                    expr = "unknown"
                    break
                }
                
                let head = vm.stack.removeLast()
                let penultimate = vm.stack.removeLast()
                
                guard penultimate.value >= head.value else {
                    expr = "overflows"
                    break
                }
                
                let result = penultimate.value - head.value
                vm.stack.append(VirtualMachine.StackValue.literal(result))
                
                
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
                
                guard vm.stack.count >= 2 else {
                    expr = "unknown"
                    break
                }
                
                let head = vm.stack.removeLast()
                let penultimate = vm.stack.removeLast()
                
                let result = penultimate.value &* head.value
                vm.stack.append(VirtualMachine.StackValue.literal(result))
                
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
                
                guard vm.stack.count >= 2 else {
                    expr = "unknown"
                    break
                }
                
                let head = vm.stack.removeLast()
                let penultimate = vm.stack.removeLast()
                
                guard head.value == 0 else {
                    expr = "division by 0"
                    break
                }
                
                let result = penultimate.value / head.value
                vm.stack.append(VirtualMachine.StackValue.literal(result))
                
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
         
            subOpcode = vm.bytecode![updatedOffset]
            offset += 1
        }
        
        let variable = Variables(rawValue: result)?.stringValue ?? "Var[\(result)]"
        
        return Opcode(
            offset: UInt16(vm.instructionPointer),
            opcode: vm.bytecode![vm.instructionPointer],
            instruction: "expression",
            command: "Exprmode \(variable) = (\(expr))",
            process: nil
        )
    }
}
