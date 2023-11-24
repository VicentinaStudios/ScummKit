//
//  InstructionProtocol.swift
//  SPUTM
//
//  Created by Michael Borgmann on 24/11/2023.
//

import Foundation
import ScummCore

protocol InstructionProtocol {
    
    var version: ScummVersion { get }
    var opcode: UInt8 { get }
    var instruction: String { get }
    
    func execute()
    func decompile(at instructionPointer: Int) -> String
}
