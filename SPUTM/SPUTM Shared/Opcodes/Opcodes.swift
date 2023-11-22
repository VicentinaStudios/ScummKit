//
//  OpcodesV5.swift
//  SPUTM
//
//  Created by Michael Borgmann on 27/08/2023.
//

import Foundation
import ScummCore

enum Opcodes {
    
    case stopObjectCode
    case putActor(ScummVersion)             // v2, v5
    case startMusic
    case getActorRoot
    case isGreaterEqual(ScummVersion)       // v2, v5
    case drawObject(ScummVersion)           // v2, v5
    case getActorElevation(ScummVersion)    // v2, v5
    case setState
    case isNotEqual
    case faceActor
    case startScript(ScummVersion)          // v2, v5
    case getVerbEntrypoint
    case resourceRoutines(ScummVersion)     // v2, v5
    case walkActorToActor
    case putActorAtObject(ScummVersion)     // v2, v5
    case oetObjectState
    case getObjectOwner
    case animateActor
    case panCameraTo(ScummVersion)          // v2, v5
    case actorOps(ScummVersion)             // v2, v5
    case print
    case actorFromPos(ScummVersion)         // v2, v5
    case getRandomNr
    case and
    case jumpRelative
    case doSentence(ScummVersion)           // v2, v5
    case move
    case multiply
    case startSound
    case ifClassOfIs(ScummVersion)          // v2, v5
    case walkActorTo(ScummVersion)          // v2, v5
    case isActorInBox
    case stopMusic
    case getAnimCounter
    case getActorY(ScummVersion)            // v2, v5
    case loadRoomWithEgo(ScummVersion)      // v2, v5
    case pickupObject(ScummVersion)         // v2, v4
    case setVarRange
    case stringOps
    case equalZero
    case setOwnerOf(ScummVersion)           // v2, v5
    case delayVariable
    case cursorCommand(ScummVersion)        // v2, v5
    case putActorInRoom(ScummVersion)       // v2, v5
    case delay(ScummVersion)                // v2, v5
    case matrixOps
    case getInventoryCount
    case setCameraAt(ScummVersion)          // v2, v5
    case roomOps(ScummVersion)              // v2, v5
    case getDist
    case findObject(ScummVersion)           // v2, v5
    case walkActorToObject(ScummVersion)    // v2, v5
    case startObject
    case isLessEqual(ScummVersion)          // v2, v5
    case subtract(ScummVersion)             // v2, v5
    case getActorScale
    case stopSound
    case findInventory
    case drawBox
    case cutscene(ScummVersion)             // v2, v5
    case chainScript(ScummVersion)          // v2, v5
    case getActorX(ScummVersion)            // v2, v5
    case isLess(ScummVersion)               // v2, v5
    case increment
    case isEqual
    case soundKludge
    case actorFollowCamera
    case setObjectName
    case getActorMoving
    case or
    case beginOverride(ScummVersion)        // v2, v5
    case add(ScummVersion)                  // v2, v5
    case divide
    case setClass
    case freezeScripts
    case stopScript(ScummVersion)           // v2, v5
    case getActorFacing
    case getClosestObjActor
    case getStringWidth
    case isScriptRunning
    case debug
    case getActorWidth
    case stopObjectScript
    case lights(ScummVersion)               // v2, v5
    case getActorCostume
    case loadRoom
    case isGreater(ScummVersion)            // v2, v5
    case verbOps(ScummVersion)              // v2, v5
    case getActorWalkBox(ScummVersion)      // v2, v5
    case isSoundRunning
    case breakHere
    case getActorRoom
    case getObjectState
    case systemOps
    case dummy(ScummVersion)                // v2, v5
    case notEqualZero
    case saveRestoreVerbs
    case expression
    case wait
    case endCutscene(ScummVersion)          // v2, v5
    case decrement
    case pseudoRoom
    case printEgo
    
    // MARK: - V4 Opcodes
    case oldRoomEffect(ScummVersion)            // v4
    case ifState(ScummVersion)                  // v4
    case saveLoadVars(ScummVersion)             // v4
    case saveLoadGame(ScummVersion)             // v4
    case ifNotState(ScummVersion)               // v4
    
    // MARK: - V3 Opcodes
    case waitForActor(ScummVersion)             // v2, v3
    case waitForSentence(ScummVersion)          // v2, v3
    case setBoxFlags(ScummVersion)              // v2, v3
    
    // MARK: - V2 Opcodes
    case assignVarByte(ScummVersion)            // v2
    case setBitVar(ScummVersion)                // v2
    case getBitVar(ScummVersion)                // v2
    case setState01(ScummVersion)               // v2
    case setState02(ScummVersion)               // v2
    case setState04(ScummVersion)               // v2
    case setState08(ScummVersion)               // v2
    case clearState01(ScummVersion)             // v2
    case clearState02(ScummVersion)             // v2
    case clearState04(ScummVersion)             // v2
    case clearState08(ScummVersion)             // v2
    case ifState01(ScummVersion)                // v2
    case ifState02(ScummVersion)                // v2
    case ifState04(ScummVersion)                // v2
    case ifState08(ScummVersion)                // v2
    case ifNotState01(ScummVersion)             // v2
    case ifNotState02(ScummVersion)             // v2
    case ifNotState04(ScummVersion)             // v2
    case ifNotState08(ScummVersion)             // v2
    case assignVarWordIndirect(ScummVersion)    // v2
    case setObjPreposition(ScummVersion)        // v2
    case addIndirect(ScummVersion)              // v2
    case subIndirect(ScummVersion)              // v2
    case setActorElevation(ScummVersion)        // v2
    case getObjPreposition(ScummVersion)        // v2
    case restart(ScummVersion)                  // v2
    case switchCostumeSet(ScummVersion)         // v2
    case drawSentence(ScummVersion)             // v2
    case waitForMessage(ScummVersion)           // v2
    
    // MARK: - V0 Opcodes
    case stopCurrentScript(ScummVersion)
}
