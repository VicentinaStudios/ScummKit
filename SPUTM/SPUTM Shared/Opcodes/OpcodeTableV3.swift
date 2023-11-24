//
//  OpcodeTableV3.swift
//  SPUTM
//
//  Created by Michael Borgmann on 22/11/2023.
//

import Foundation
import ScummCore

public struct OpcodeTableV3: OpcodeTableProtocol {
    
    var opcodeTable: [UInt8 : Instructions] = [:]
    
    init(_ gameInfo: GameInfo) {
        
        opcodeTable = CommonOpcodes.sharedV3V4V5
        
        opcodeTable.merge(CommonOpcodes.sharedV3V4) { _, new in new }
        
        opcodeTable[0x3b] = .waitForActor(.v3)
        opcodeTable[0xbb] = .waitForActor(.v3)
        opcodeTable[0x4c] = .waitForSentence(.v3)
        
        if gameInfo.id != .loom && gameInfo.platform != .pcengine {
            opcodeTable[0x30] = .setBoxFlags(.v3)
            opcodeTable[0xb0] = .setBoxFlags(.v3)
        }
    }
}
