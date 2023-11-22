//
//  OpcodeTable.swift
//  SPUTM
//
//  Created by Michael Borgmann on 20/11/2023.
//

import Foundation
import ScummCore

protocol OpcodeTableProtocol {
    var opcodeTable: [UInt8: Opcodes] { get }
    init(_ gameInfo: GameInfo)
}
