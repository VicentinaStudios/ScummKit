//
//  VirtualMachine.swift
//  ScummCompiler
//
//  Created by Michael Borgmann on 25/11/2023.
//

import Foundation

struct VirtualMachine {
    
    var chunk: Chunk?
    var ip: Int = 0
    
    let stackMax = 256
    var stack: [Value?]
    var stackTop = 0
    
    init() {
        self.stack = [Value?](repeating: nil, count: stackMax)
        resetStack()
    }
    
    private mutating func resetStack() {
        stackTop = 0
    }
    
    mutating func push(value: Value) {
        stack[stackTop] = value
        stackTop += 1
    }
    
    mutating func pop() -> Value {
        stackTop -= 1
        let value = stack[stackTop]
        stack[stackTop] = nil
        return value!
    }
    
    mutating func interpret(source: String) -> InterpretResult {
        compile(source: source)
        return .ok
    }
    
    mutating func run() -> InterpretResult{
        
        while true {
            
            if DEBUG_TRACE_EXECUTION {
                
                print("          ", terminator: "")
                stack.forEach { value in
                    guard let value = value else { return }
                    print("[ ", value, " ]", terminator: "")
                }
                print()
                
                disassembleInstruction(chunk: chunk!, offset: ip)
            }
            
            let instruction = readByte()
            
            switch Opcode(rawValue: instruction) {
            case .constant:
                let constant = readConstant()
                push(value: constant)
            case .add:
                binaryOperation(op: +)
            case .subtract:
                binaryOperation(op: -)
            case .multiply:
                binaryOperation(op: *)
            case .divide:
                binaryOperation(op: /)
            case .negate:
                push(value: -pop())
            case .return:
                printValue(value: pop())
                print()
                return .ok
            default:
                return .runtimeError
            }
        }
    }
    
    private mutating func readByte() -> UInt8 {
        let instruction = chunk!.code[ip]
        ip += 1
        return instruction
    }
    
    private mutating func readConstant() -> Value {
        let index = Int(readByte())
        let value = chunk!.constants.values[index - 1]
        return value
    }
    
    private mutating func binaryOperation(op: (Double, Double) -> Double) {
        
        repeat {
            
            let b = pop()
            let a = pop()
            
            push(value: op(a, b))
            
        } while false
    }
}

enum InterpretResult {
    
    case ok
    case compileError
    case runtimeError
}
