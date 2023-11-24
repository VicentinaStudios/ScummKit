//
//  OpcodeTableV4.swift
//  SPUTM
//
//  Created by Michael Borgmann on 22/11/2023.
//

import Foundation
import ScummCore

public struct OpcodeTableV4: OpcodeTableProtocol {
    
    var opcodeTable: [UInt8 : Instructions] = [:]
    
    init(_ gameInfo: GameInfo) {
        
        opcodeTable = CommonOpcodes.sharedV3V4V5
        
        opcodeTable.merge(CommonOpcodes.sharedV3V4) { _, new in new }
    }
}
