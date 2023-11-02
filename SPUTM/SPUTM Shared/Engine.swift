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
    private let opcodes: Opcode
    
    static private var gameDirectoryURL: URL {
        
        get throws {
            
            guard let path = CLI().extractFilenames else {
                throw EngineError.missingGameDirectory
            }

            var isDirectory: ObjCBool = true
            let isPathExisting = FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
            
            guard isPathExisting && isDirectory.boolValue else {
                throw EngineError.invalidDirectory(path)
            }
            
            return URL(filePath: path, directoryHint: .isDirectory)
        }
    }
    
    init() throws {
        
        self.variables = try Variables(.v5)
        self.opcodes = Opcode()
        
        self.core = try ScummCore(gameDirectory: try Engine.gameDirectoryURL, version: .v5)
        
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
