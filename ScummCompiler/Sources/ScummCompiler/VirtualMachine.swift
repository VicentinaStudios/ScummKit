//
//  VirtualMachine.swift
//
//
//  Created by Michael Borgmann on 16/12/2023.
//

import Foundation

/// The `VirtualMachine` class interprets bytecode from a `Chunk`.
///
/// This class emulates a simple virtual machine capable of interpreting bytecode instructions.
public class VirtualMachine {
    
    /// The bytecode chunk to interpret
    private var chunk: Chunk?
    
    /// The instruction pointer pointing to the next bytecode instruction.
    private var instructionPointer: Array.Index?
    
    public init() { }
    
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
        
        chunk = Chunk()
        instructionPointer = chunk!.codeStart
        
        let compiler = Compiler()
        
        if try compiler.compile(source: source, chunk: chunk!) {
            throw CompilerError.compileError
        }
        
        try run()
    }
    
    /// Executes the bytecode instructions until a termination condition is met.
    ///
    /// This method continuously reads and executes bytecode instructions until a termination  condition,
    /// such as encountering a specific opcode, is met.
    ///
    /// - Throws: A `CompilerError` if an issue occurs during execution.
    private func run() throws {
        
        while
            let instructionPointer = instructionPointer,
            let chunk = chunk,
            instructionPointer < chunk.size
        {
            
            let byte = try readNextByte()
            
            guard let instruction = Opcode(rawValue: byte) else {
                throw CompilerError.unknownOpcode(byte)
            }
            
            switch instruction {
            case .breakHere:
                debugPrint("break here")
            }
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
