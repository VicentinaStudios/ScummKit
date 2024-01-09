//
//  VirtualMachine.swift
//
//
//  Created by Michael Borgmann on 09/01/2024.
//

import Foundation

// MARK: - Virtual Machine Protocal

/// A protocol representing a virtual machine for interpreting and running bytecode.
///
/// A virtual machine interprets and executes bytecode instructions. Implementations of this
/// protocol define the behavior for interpreting bytecode chunks and running the virtual machine.
/// Custom virtual machines should conform to this protocol to provide specific runtime execution.
///
/// - Note: Conforming types must implement the `run()` method to specify the execution logic
///         of the virtual machine.
protocol VirtualMachine {
    
    /// Interprets a given bytecode chunk.
    ///
    /// This method takes a bytecode chunk as input and interprets its instructions. The specific
    /// implementation defines the behavior of interpreting bytecode instructions, and it is
    /// expected to throw errors if issues occur during interpretation.
    ///
    /// - Parameter chunk: The bytecode chunk to interpret.
    /// - Throws: An error if there's an issue during interpretation.
    func interpret(chunk: Chunk) throws
    
    /// Interprets a given source code and compiles it into bytecode before execution.
    ///
    /// This method compiles the provided source code into bytecode using a compiler. It then
    /// interprets and executes the generated bytecode. The specific implementation defines the
    /// behavior of interpreting bytecode instructions, and it is expected to throw errors if
    /// issues occur during interpretation.
    ///
    /// - Parameter source: The source code to interpret.
    /// - Throws: An error if there's an issue during compilation or interpretation.
    func interpret(source: String) throws
    
    /// Executes the virtual machine.
    ///
    /// This method contains the main runtime logic of the virtual machine. Conforming types
    /// must provide their own implementation to define how the virtual machine should execute.
    ///
    /// - Throws: An error if there's an issue during execution.
    func run() throws
}

// MARK: - Base Virtual Machine

/// A base implementation of the `VirtualMachine` protocol.
///
/// The `BaseVM` class provides a basic foundation for implementing virtual machines. It includes
/// common functionality such as a stack, instruction pointer, and methods for interpreting
/// bytecode chunks. Conforming types should inherit from `BaseVM` and implement the `run()` method
/// to specify their own execution logic.
public class BaseVM: VirtualMachine {
    
    // MARK: Properties
    
    /// The current bytecode chunk being executed.
    internal var chunk: Chunk?
    
    /// The current instruction pointer within the bytecode chunk.
    internal var instructionPointer: Array.Index?
    
    /// The stack used for storing intermediate values during execution.
    internal var stack: [Value?]
    
    /// The current top index of the stack.
    internal var stackTop = 0
    
    /// The maximum size of the stack.
    internal let stackMax = 256
    
    // MARK: Computed Propertiex
    
    /// The decompiler used for debugging traces.
    internal var decompiler: Decompiler? {
        Configuration.DEBUG_TRACE_EXECUTION ? Decompiler() : nil
    }
    
    // MARK: Lifecycle
    
    /// Initializes a new instance of the virtual machine.
    public init() {
        stack = [Value?](repeating: nil, count: stackMax)
        resetStack()
    }
    
    // MARK: Actions
    
    /// Interprets a given bytecode chunk.
    ///
    /// This method serves as the entry point for interpreting bytecode chunks. It sets up the
    /// initial state and then calls the `run()` method to execute the virtual machine's logic.
    ///
    /// - Parameter chunk: The bytecode chunk to interpret.
    /// - Throws: An error if there's an issue during interpretation.
    public func interpret(chunk: Chunk) throws {
        
        guard chunk.size > 0 else {
            return
        }
        
        self.chunk = chunk
        instructionPointer = chunk.codeStart
        
        try run()
    }
    
    /// Interprets a given source code and compiles it into bytecode before execution.
    ///
    /// This method compiles the provided source code into bytecode using a compiler. It then
    /// interprets and executes the generated bytecode. The specific implementation defines the
    /// behavior of interpreting bytecode instructions, and it is expected to throw errors if
    /// issues occur during interpretation.
    ///
    /// - Parameter source: The source code to interpret.
    /// - Throws: An error if there's an issue during compilation or interpretation.
    public func interpret(source: String) throws {
        
        let compiler = Compiler()
        
        let chunk = try compiler.compile(source: source)
        self.chunk = chunk
        instructionPointer = chunk.codeStart
        
        try run()
    }
    
    // MARK: Virtual Machine Runtime Execution
    
    /// Executes the virtual machine.
    ///
    /// This method serves as the main runtime logic for the virtual machine. Conforming types
    /// must provide their own implementation to define how the virtual machine should execute.
    ///
    /// - Throws: An error if there's an issue during execution.
    internal func run() throws {
        
        // NOTE: Implement this in the concrete virtual machine
        fatalError("Subclasses must implement their own run method.")
        
        defer {
            if Configuration.DEBUG_TRACE_EXECUTION {
                showStack()
            }
        }
        
        decompiler?.printHeader(name: "TRACE")
    }
}

// MARK: - Stack

extension BaseVM {
    
    /// Resets the stack to its initial state.
    ///
    /// This method sets all elements of the stack to `nil` and resets the stack top to 0.
    internal func resetStack() {
        stack = [Value?](repeating: nil, count: stackMax)
        stackTop = 0
    }
    
    /// Displays the current state of the stack, if debug tracing is enabled.
    ///
    /// If debug tracing is enabled (`Configuration.DEBUG_TRACE_EXECUTION`), this method
    /// prints the contents of the stack to the console.
    internal func showStack() {
        
        if Configuration.DEBUG_TRACE_EXECUTION, stack.contains(where: { $0 != nil }) {
            
            print("            ", terminator: "")
            
            stack.compactMap { $0 }.forEach { slot in
                print("[\(slot)]", terminator: " ")
            }
            print()
        }
    }
    
    /// Performs a binary operation on the top two values of the stack.
    ///
    /// This method pops the top two values from the stack, applies the specified binary
    /// operation (`op`), and pushes the result back onto the stack.
    ///
    /// - Parameter op: The binary operation to perform.
    /// - Throws: An error if there's an issue during the operation, such as division by zero.
    internal func binaryOperation(op: (Int, Int) -> Int) throws {
        
        repeat {
            
            let b = try pop()
            let a = try pop()
            
            guard b != 0 else {
                
                let line = instructionPointer != nil
                    ? chunk?.lines[instructionPointer!]
                    : nil
                
                throw VirtualMachineError.divisionByZero(line: line)
            }
            
            try push(value: op(a, b))
            
        } while false
    }
    
    /// Pushes a value onto the stack.
    ///
    /// - Parameter value: The value to push onto the stack.
    /// - Throws: An error if the stack is full (`VirtualMachineError.fullStack`).
    internal func push(value: Value) throws {
        
        guard stackTop < stackMax else {
            throw VirtualMachineError.fullStack
        }
        
        stack[stackTop] = value
        stackTop += 1
    }
    
    /// Pops a value from the stack.
    ///
    /// - Returns: The popped value from the stack.
    /// - Throws: An error if the stack is empty (`VirtualMachineError.emptyStack`).
    internal func pop() throws -> Value {
        
        guard stackTop > 0 else {
            throw VirtualMachineError.emptyStack
        }
        
        stackTop -= 1
        let value = stack[stackTop]
        stack[stackTop] = nil
        return value!
    }
}

// MARK: - Helper

extension BaseVM {
    
    /// Reads the next byte from the bytecode chunk.
    ///
    /// This method reads the byte at the current instruction pointer and increments
    /// the instruction pointer to point to the next byte.
    ///
    /// - Returns: The byte read from the bytecode chunk.
    /// - Throws: An error if there's an issue fetching the instruction or if the
    ///           instruction pointer is undefined (`VirtualMachineError.undefinedInstructionPointer`).
    internal func readNextByte() throws -> UInt8 {
        
        guard
            let instructionPointer = instructionPointer,
            instructionPointer < chunk?.size ?? 0
        else {
            throw VirtualMachineError.undefinedInstructionPointer
        }
        
        guard let byte = try chunk?.read(at: instructionPointer) else {
            throw CompilerError.cantFetchInstruction(instructionPointer)
        }
        
        self.instructionPointer = instructionPointer + 1
        
        return byte
    }
}
