//
//  MojoVM.swift
//
//
//  Created by Michael Borgmann on 16/12/2023.
//

import Foundation

/// The `VirtualMachine` class interprets bytecode from a `Chunk`.
///
/// This class emulates a simple virtual machine capable of interpreting bytecode instructions.
public class MojoVM {
    
    /// The bytecode chunk to interpret
    private var chunk: Chunk?
    
    var stack: [Value?]
    var stackTop = 0
    let stackMax = 256
    
    private var decompiler: Decompiler? {
        Configuration.DEBUG_TRACE_EXECUTION ? Decompiler() : nil
    }
    
    /// The instruction pointer pointing to the next bytecode instruction.
    private var instructionPointer: Array.Index?
    
    public init() {
        self.stack = [Value?](repeating: nil, count: stackMax)
        resetStack()
    }
    
    /// Interprets bytecode from a given `Chunk`.
    ///
    /// - Parameter chunk: The bytecode chunk to interpret.
    /// - Throws: A `CompilerError` if an issue occurs during interpretation.
    public func interpret(chunk: Chunk) throws {
        
        guard chunk.size > 0 else {
            return
        }
        
        self.chunk = chunk
        instructionPointer = chunk.codeStart
        
        try run()
    }
    
    public func interpret(source: String) throws {
        
        let compiler = Compiler()
        
        let chunk = try compiler.compile(source: source)
        self.chunk = chunk
        instructionPointer = chunk.codeStart
        
        try run()
    }
    
    /// Executes the bytecode instructions until a termination condition is met.
    ///
    /// This method continuously reads and executes bytecode instructions until a termination  condition,
    /// such as encountering a specific opcode, is met.
    ///
    /// - Throws: A `CompilerError` if an issue occurs during execution.
    private func run() throws {
        
        decompiler?.printHeader(name: "TRACE")
        
        while
            let instructionPointer = instructionPointer,
            let chunk = chunk,
            instructionPointer < chunk.size
        {
            
            try decompiler?.trace(chunk, offset: instructionPointer)
            
            let byte = try readNextByte()
            
            guard let instruction = Opcode(rawValue: byte) else {
                throw CompilerError.unknownOpcode(byte)
            }
            
            switch instruction {
            case .breakHere:
                debugPrint("break here")
            case .add:
                binaryOperation(op: +)
            case .subtract:
                binaryOperation(op: -)
            case .multiply:
                binaryOperation(op: *)
            case .divide:
                binaryOperation(op: /)
            case .return:
                 break
            case .constant:
                let index = try Int(readNextByte())
                let constant = try chunk.readConstant(at: index - 1)
                push(value: constant)
            case .negate:
                push(value: -pop())
            case .expression:
                break
            }
            
            if Configuration.DEBUG_TRACE_EXECUTION {
                showStack()
            }
        }
    }
    
    private func showStack() {
        
        if Configuration.DEBUG_TRACE_EXECUTION, stack.contains { $0 != nil } {
            
            print("            ", terminator: "")
            
            stack.compactMap { $0 }.forEach { slot in
                print("[\(slot)]", terminator: " ")
            }
            print()
        }
    }
    
    /// Reads the next bytecode instruction from the current instruction pointer.
    ///
    /// - Returns: The next bytecode instruction.
    /// - Throws: A `CompilerError` if an issue occurs during bytecode reading.
    private func readNextByte() throws -> UInt8 {
        
        guard let instructionPointer = instructionPointer else {
            throw CompilerError.unknownIndex
        }
        
        guard let byte = try chunk?.read(at: instructionPointer) else {
            throw CompilerError.cantFetchInstruction(instructionPointer)
        }
        
        self.instructionPointer = instructionPointer + 1
        
        return byte
    }
}

// MARK: - Stack

extension MojoVM {
    
    private func binaryOperation(op: (Int, Int) -> Int) {
        
        repeat {
            
            let b = pop()
            let a = pop()
            
            push(value: op(a, b))
            
        } while false
    }
    
    private func push(value: Value) {
        stack[stackTop] = value
        stackTop += 1
    }
    
    private func pop() -> Value {
        stackTop -= 1
        let value = stack[stackTop]
        stack[stackTop] = nil
        return value!
    }
    
    private func resetStack() {
        stackTop = 0
    }
}