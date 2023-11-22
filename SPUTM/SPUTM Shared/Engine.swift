//
//  Engine.swift
//  SPUTM
//
//  Created by Michael Borgmann on 27/08/2023.
//

import Foundation
import ScummCore

class Engine {
    
    private let core: ScummCore
    private let variables: Variables
    private var opcodes: OpcodeTableProtocol
    
    init(gameInfo: GameInfo) throws {
        
        let version = gameInfo.version
        
        self.variables = try Variables(version)
        
        switch version {
        case .v3:
            self.opcodes = OpcodeTableV3(gameInfo)
        case .v4:
            self.opcodes = OpcodeTableV4(gameInfo)
        case .v5:
            self.opcodes = OpcodeTableV5(gameInfo)
        default:
            fatalError("Couldn't create opcodes for v\(version.rawValue)")
        }
        
        self.core = try ScummCore(
            gameDirectory: URL(filePath: gameInfo.path.removingPercentEncoding!, directoryHint: .isDirectory),
            version: gameInfo.version
        )
        
        try core.loadIndexFile()
    }
    
    func run(scriptIndex: Int = 1) {
        
        guard
            let indexFile = core.indexFile?.indexFileURL.path(),
            let script = core.indexFile?.resources?.scripts[scriptIndex],
            let room = core.indexFile?.resources?.rooms[script.roomNumber],
            let roomName = core.indexFile?.roomNames?.first(where: { $0.number == script.roomNumber })
        else {
            debugPrint("No start script found")
            return
        }
        
        debugPrint("Index file:", indexFile)
        debugPrint("Start script:", scriptIndex)
        debugPrint(" - Room number:", script.roomNumber)
        debugPrint(" - Offset:", script.offset)
        debugPrint(" - Room name:", roomName)
        debugPrint(" - Room offset:", room.offset)
    }
}

struct Constants {
    
    let screenWidth = 320
    let screenHeight = 200
    
    let numberOfActors = 13
    
    let ofOwnerRoomer = 0x0f
    
    let minHeapThreshold = 400000
    let maxHeapThreshold = 550000
}
