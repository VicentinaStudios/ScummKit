//
//  Instructions.swift
//  SPUTM
//
//  Created by Michael Borgmann on 27/08/2023.
//

import Foundation
import ScummCore

enum Instructions {
    
    // MARK: - V6 Instructions
    
    case pushByte
    case pushWord
    case pushByteVar
    case pushWordVar
    case byteArrayRead
    case wordArrayRead
    case byteArrayIndexedRead
    case wordArrayIndexedRead
    case dup
    case not
    case eq
    case neq
    case gt
    case lt
    case le
    case ge
    case sub
    case mul
    case div
    case land
    case lor
    case pop
    case writeByteVar
    case writeWordVar
    case byteArrayWrite
    case wordArrayWrite
    case byteArrayIndexedWrite
    case wordArrayIndexedWrite
    case byteVarInc
    case wordVarInc
    case byteArrayInc
    case wordArrayInc
    case byteVarDec
    case wordVarDec
    case byteArrayDec
    case wordArrayDec
    case `if`
    case ifNot
    case startScriptQuick
    case drawObjectAt
    case drawBlastObject
    case setBlastObjectWindow
    case freezeUnfreeze
    case getState
    case setOwner
    case getOwner
    case jump
    case putActorAtXY
    case getRandomNumberRange
    case getObjectX
    case getObjectY
    case getObjectOldDir
    case getVerbFromXY
    case endOverride
    case createBoxMatrix
    case getActorFromXY
    case arrayOps
    case getActorScaleX
    case getActorAnimCounter
    case isAnyOf
    case delaySeconds
    case delayMinutes
    case stopSentence
    case printLine
    case printText
    case printDebug
    case printSystem
    case printActor
    case talkActor
    case talkEgo
    case dimArray
    case startObjectQuick
    case startScriptQuick2
    case dim2dimArray
    case abs
    case distObjectObject
    case distObjectPt
    case distPtPt
    case kernelGetFunctions
    case kernelSetFunctions
    case delayFrames
    case pickOneOf
    case pickOneOfDefault
    case stampObject
    case getDateTime
    case stopTalking
    case getAnimateVariable
    case shuffle
    case jumpToScript
    case band
    case bor
    case isRoomScriptRunning
    case findAllObjects
    case getPixel
    case pickVarRandom
    case setBoxSet
    case getActorLayer
    case getObjectNewDir
    
    // MARK: - V5 Instructions
    
    case stopObjectCode(ScummVersion)       // v5, v6
    case putActor(ScummVersion)             // v2, v5
    case startMusic(ScummVersion)           // v5, v6
    case getActorRoot
    case isGreaterEqual(ScummVersion)       // v2, v5
    case drawObject(ScummVersion)           // v2, v5
    case getActorElevation(ScummVersion)    // v2, v5
    case setState(ScummVersion)             // v5, v6
    case isNotEqual
    case faceActor(ScummVersion)            // v5, v6
    case startScript(ScummVersion)          // v2, v5
    case getVerbEntrypoint(ScummVersion)    // v5, v6
    case resourceRoutines(ScummVersion)     // v2, v5
    case walkActorToActor
    case putActorAtObject(ScummVersion)     // v2, v5
    case oetObjectState
    case getObjectOwner
    case animateActor(ScummVersion)         // v5, v6
    case panCameraTo(ScummVersion)          // v2, v5
    case actorOps(ScummVersion)             // v2, v5
    case print
    case actorFromPos(ScummVersion)         // v2, v5
    case getRandomNr(ScummVersion)          // v5, v6
    case and
    case jumpRelative
    case doSentence(ScummVersion)           // v2, v5
    case move
    case multiply
    case startSound(ScummVersion)           // v5, v6
    case ifClassOfIs(ScummVersion)          // v2, v5
    case walkActorTo(ScummVersion)          // v2, v5
    case isActorInBox(ScummVersion)         // v5, v6
    case stopMusic(ScummVersion)            // v5, v6
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
    case getInventoryCount(ScummVersion)    // v5, v6
    case setCameraAt(ScummVersion)          // v2, v5
    case roomOps(ScummVersion)              // v2, v5
    case getDist
    case findObject(ScummVersion)           // v2, v5
    case walkActorToObject(ScummVersion)    // v2, v5
    case startObject(ScummVersion)          // v5, v6
    case isLessEqual(ScummVersion)          // v2, v5
    case subtract(ScummVersion)             // v2, v5
    case getActorScale
    case stopSound(ScummVersion)            // v5, v6
    case findInventory(ScummVersion)        // v5, v6
    case drawBox(ScummVersion)              // v5, v6
    case cutscene(ScummVersion)             // v2, v5
    case chainScript(ScummVersion)          // v2, v5
    case getActorX(ScummVersion)            // v2, v5
    case isLess(ScummVersion)               // v2, v5
    case increment
    case isEqual
    case soundKludge(ScummVersion)          // v5, v6
    case actorFollowCamera(ScummVersion)    // v5, v6
    case setObjectName(ScummVersion)        // v5, v6
    case getActorMoving(ScummVersion)       // v5, v6
    case or
    case beginOverride(ScummVersion)        // v2, v5
    case add(ScummVersion)                  // v2, v5, v6
    case divide
    case setClass(ScummVersion)             // v5, v6
    case freezeScripts
    case stopScript(ScummVersion)           // v2, v5
    case getActorFacing
    case getClosestObjActor
    case getStringWidth
    case isScriptRunning(ScummVersion)      // v5, v6
    case debug
    case getActorWidth(ScummVersion)        // v5, v6
    case stopObjectScript(ScummVersion)     // v5, v6
    case lights(ScummVersion)               // v2, v5
    case getActorCostume(ScummVersion)      // v5, v6
    case loadRoom(ScummVersion)             // v5, v6
    case isGreater(ScummVersion)            // v2, v5
    case verbOps(ScummVersion)              // v2, v5
    case getActorWalkBox(ScummVersion)      // v2, v5
    case isSoundRunning(ScummVersion)       // v5, v6
    case breakHere(ScummVersion)            // v5, v6
    case getActorRoom(ScummVersion)         // v5, v6
    case getObjectState
    case systemOps(ScummVersion)            // v5, v6
    case dummy(ScummVersion)                // v2, v5
    case notEqualZero
    case saveRestoreVerbs(ScummVersion)     // v5, v6
    case expression
    case wait(ScummVersion)                 // v5, v6
    case endCutscene(ScummVersion)          // v2, v5
    case decrement
    case pseudoRoom(ScummVersion)           // v5, v6
    case printEgo(ScummVersion)             // v5, v6
    
    // MARK: - V4 Instructions
    case oldRoomEffect(ScummVersion)            // v4
    case ifState(ScummVersion)                  // v4
    case saveLoadVars(ScummVersion)             // v4
    case saveLoadGame(ScummVersion)             // v4
    case ifNotState(ScummVersion)               // v4
    
    // MARK: - V3 Instructions
    case waitForActor(ScummVersion)             // v2, v3
    case waitForSentence(ScummVersion)          // v2, v3
    case setBoxFlags(ScummVersion)              // v2, v3
    
    // MARK: - V2 Instructions
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
    
    // MARK: - V0 Instructions
    case stopCurrentScript(ScummVersion)
}

extension Instructions {
    
    func interpret(opcode: UInt8) -> InstructionProtocol? {
        
        switch self {
        case .move:
            return Move(version: .v5, opcode: opcode)
        default:
            debugPrint("Opcode not implemented")
            return nil
        }
    }
}
