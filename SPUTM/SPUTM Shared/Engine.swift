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
    
    func run(scriptIndex: Int)
}

class Engine {
    
    private let core: ScummCore
    private let variables: Variables
    private var opcodes: OpcodeTableProtocol
    
    init(gameInfo: GameInfo) throws {
        
        let version = gameInfo.version
        
        self.core = try ScummCore(
            gameDirectory: URL(filePath: gameInfo.path.removingPercentEncoding!, directoryHint: .isDirectory),
            version: gameInfo.version
        )
        
        // Setup SCUM engine
        
        self.variables = try Variables(version)
        self.opcodes = try OpcodeTableV5(gameInfo)
        
        try core.loadIndexFile()
        
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
        
        execeuteScript()
    }
    
    func execeuteScript() {
        
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
