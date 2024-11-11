//
//  VirtualMachine.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 11/11/2024.
//


//
//  VirtualMachine.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 12/07/2023.
//

import Foundation

class VirtualMachine: ObservableObject {
    
    // MARK: Code
    
    private (set) var bytecode: [UInt8]? = nil
    @Published var opcodes: [Opcode]? = nil
    
    // MARK: Data
    
    var stack: [StackValue] = []
    var variables: Dictionary<UInt16, UInt16> = [:]
    var localVariables = [[UInt16?]](
        repeating: [UInt16?](repeating: 1, count: Constants.NUM_SCRIPT_LOCAL.rawValue + 1),
        count: Constants.NUM_SCRIPT_SLOT.rawValue
    )
    
    
    
    // MARK: Registers
    
    private(set) var instructionPointer = 0
    
    // MARK: Initialization
    
    init() {
        
        // NOTE: This likely needs to be configured for start
        Variables.allCases.forEach { scummVariable in
            variables[scummVariable.rawValue] = 0
        }
    }
    
    // MARK: Features
    
    func loadBytecode(with bytecode: [UInt8]) {
        self.bytecode = bytecode
        instructionPointer = 0
        opcodes = []
    }
    
    func decompile() {
        
        guard
            let bytecode = bytecode,
            !bytecode.isEmpty
        else {
            debugPrint("No bytecode")
            return
        }
        
        let engine = OpcodesV5(vm: self)
        
        while instructionPointer < bytecode.count {
            
            let opcode = engine.interpret()
            opcodes?.append(opcode)
            
            instructionPointer = engine.updatedOffset
        }
    }
}

// MARK: - Data

extension VirtualMachine {
    
    enum Constants: Int {
        case NUM_SCRIPT_SLOT = 80
        case NUM_SCRIPT_LOCAL = 25
    }
    
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
}
