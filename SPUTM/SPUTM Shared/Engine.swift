//
//  Engine.swift
//  SPUTM
//
//  Created by Michael Borgmann on 27/08/2023.
//

import Foundation
import ScummCore

protocol EngineProtocol {
    
    var core: ScummCore { get }
    var gameInfo: GameInfo  { get }
    var variables: Variables  { get }
    var opcodes: OpcodeTableProtocol  { get }
    var instructionPointer: Int { get set }
    
    func run(scriptIndex: Int)
}

class Engine {
    
    private let core: ScummCore
    private let variables: Variables
    private var opcodes: OpcodeTableProtocol
    private var instructionPointer = 0
    
    init(gameInfo: GameInfo) throws {
        
        let version = gameInfo.version
        
        self.core = try ScummCore(
            gameDirectory: URL(filePath: gameInfo.path.removingPercentEncoding!, directoryHint: .isDirectory),
            version: gameInfo.version
        )
        
        // Setup SCUM engine
        
        self.variables = try Variables(version)
        self.opcodes = OpcodeTableV5(gameInfo)
        
        try core.loadIndexFile()
        try? core.loadDataFile()
        
        resetScumm()
    }
    
    private func resetScumm() {
        
        // 1. init screens (main, text, verbs, unknown)
        // 2. reset palette
        // 3. load charset
        // 4. set shake
        // 5. cursor animation
        // 6. create actors
        // 7. reset nested scripts
        // 8. reset cut scenes
        // 9. reset verbs
        // 10. reset camera
    }
    
    func run(scriptIndex: Int = 1) {
        
        guard
            let roomOffset = core.indexFile?.resources?.scripts[scriptIndex],
            let script = try? core.dataFile?.readResource(resource: roomOffset, type: .script) as? Script
        else {
            fatalError("Can't load script")
        }
        
        executeScript(script)
    }
    
    func executeScript(_ script: Script) {
        
        while instructionPointer < script.byteCode.count {
            
            let opcode = script.byteCode[instructionPointer]
            
            try? executeOpcode(opcode)
//            try? decompileOpcode(opcode, at: instructionPointer)
            
            instructionPointer += 1
        }
    }
    
    func executeOpcode(_ opcode: UInt8) throws {
        
        guard
            let instruction = opcodes.opcodeTable[opcode]
        else {
            throw EngineError.invalidOpcode(opcode)
        }
        
        instruction.interpret(opcode: opcode)?.execute()
        
    }
    
    func decompileOpcode(_ opcode: UInt8, at instructionPointer: Int) throws {
        
        guard
            let instruction = opcodes.opcodeTable[opcode]?.interpret(opcode: opcode)
        else {
            throw EngineError.invalidOpcode(opcode)
        }
        
        let source = instruction.decompile(at: instructionPointer)
        
        print("[\(instructionPointer)]", "(\(opcode))", source)
    }
}

struct Constants {
    
    struct V5 {
        let screenWidth = 320
        let screenHeight = 200
        
        let numberOfActors = 13
        
        let ofOwnerRoom = 0x0f
        
        let minHeapThreshold = 400000
        let maxHeapThreshold = 550000
    }
}
