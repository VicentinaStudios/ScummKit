//
//  OpcodeTableV5.swift
//  SPUTM
//
//  Created by Michael Borgmann on 22/11/2023.
//

import Foundation
import ScummCore

public struct OpcodeTableV5: OpcodeTableProtocol {
    
    var opcodeTable: [UInt8 : Opcodes] = [:]
    
    init(_ gameInfo: GameInfo) {
        
        opcodeTable = CommonOpcodes.sharedV3V4V5
        
        opcodeTable.merge(versionSpecificOpcodes, uniquingKeysWith: { _, new in
            new
        })
    }
    
    private var versionSpecificOpcodes: [UInt8 : Opcodes] = [
        0x0f: .getObjectState,
        0x8f: .getObjectState,
        
        0x22: .getAnimCounter,
        0xa2: .getAnimCounter,
        
        0x25: .pickupObject(.v5),
        0x65: .pickupObject(.v5),
        0xa5: .pickupObject(.v5),
        0xe5: .pickupObject(.v5),
        
        0x3b: .getActorScale,
        0xbb: .getActorScale,
        
        0x4c: .soundKludge(.v5),
        
        0xa7: .dummy(.v5)
    ]
}
