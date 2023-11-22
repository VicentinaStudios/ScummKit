//
//  OpcodeTableV2.swift
//  SPUTM
//
//  Created by Michael Borgmann on 22/11/2023.
//

import Foundation
import ScummCore

public struct OpcodeTableV2: OpcodeTableProtocol {
    
    var opcodeTable: [UInt8 : Opcodes] = [:]
    
    init(_ gameInfo: GameInfo) {
        
        opcodeTable = [
            0x00: .stopObjectCode,
            0x01: .putActor(.v2),
            0x02: .startMusic,
            0x03: .getActorRoom,
            
            0x04: .isGreaterEqual(.v2),
            0x05: .drawObject(.v2),
            0x06: .getActorElevation(.v2),
            0x07: .setState08(.v2),
            
            0x08: .isNotEqual,
            0x09: .faceActor,
            0x0a: .assignVarWordIndirect(.v2),
            0x0b: .setObjPreposition(.v2),
            
            0x0c: .resourceRoutines(.v2),
            0x0d: .walkActorToActor,
            0x0e: .putActorAtObject(.v2),
            0x0f: .ifNotState08(.v2),
            
            0x10: .getObjectOwner,
            0x11: .animateActor,
            0x12: .panCameraTo(.v2),
            0x13: .actorOps(.v2),
            
            0x14: .print,
            0x15: .actorFromPos(.v2),
            0x16: .getRandomNr,
            0x17: .clearState02(.v2),
            
            0x18: .jumpRelative,
            0x19: .doSentence(.v2),
            0x1a: .move,
            0x1b: .setBitVar(.v2),
            
            0x1c: .startSound,
            0x1d: .ifClassOfIs(.v2),
            0x1e: .walkActorTo(.v2),
            0x1f: .ifState02(.v2),
            
            0x20: .stopMusic,
            0x21: .putActor(.v2),
            0x22: .saveLoadGame(.v4),
            0x23: .getActorY(.v2),
            
            0x24: .loadRoomWithEgo(.v2),
            0x25: .drawObject(.v2),
            0x26: .setVarRange,
            0x27: .setState04(.v2),
            
            0x28: .equalZero,
            0x29: .setOwnerOf(.v2),
            0x2a: .addIndirect(.v2),
            0x2b: .delayVariable,
            
            0x2c: .assignVarByte(.v2),
            0x2d: .putActorInRoom(.v2),
            0x2e: .delay(.v2),
            0x2f: .ifNotState04(.v2),
            
            0x30: .setBoxFlags(.v3),
            0x31: .getBitVar(.v2),
            0x32: .setCameraAt(.v2),
            0x33: .roomOps(.v2),
            
            0x34: .getDist,
            0x35: .findObject(.v2),
            0x36: .walkActorToObject(.v2),
            0x37: .setState01(.v2),
            
            0x38: .isLessEqual(.v2),
            0x39: .doSentence(.v2),
            0x3a: .subtract(.v2),
            0x3b: .waitForActor(.v2),
            
            0x3c: .stopSound,
            0x3d: .setActorElevation(.v2),
            0x3e: .walkActorTo(.v2),
            0x3f: .ifNotState01(.v2),
            
            0x40: .cutscene(.v2),
            0x41: .putActor(.v2),
            0x42: .startScript(.v2),
            0x43: .getActorX(.v2),
            
            0x44: .isLess(.v2),
            0x45: .drawObject(.v2),
            0x46: .increment,
            0x47: .clearState08(.v2),
            
            0x48: .isEqual,
            0x49: .faceActor,
            0x4a: .chainScript(.v2),
            0x4b: .setObjPreposition(.v2),
            
            0x4c: .waitForSentence(.v2),
            0x4d: .walkActorToActor,
            0x4e: .putActorAtObject(.v2),
            0x4f: .ifState08(.v2),
            
            0x50: .pickupObject(.v2),
            0x51: .animateActor,
            0x52: .actorFollowCamera,
            0x53: .actorOps(.v2),
            
            0x54: .setObjectName,
            0x55: .actorFromPos(.v2),
            0x56: .getActorMoving,
            0x57: .setState01(.v2),
            
            0x58: .beginOverride(.v2),
            0x59: .doSentence(.v2),
            0x5a: .add(.v2),
            0x5b: .setBitVar(.v2),
            
            0x5c: .dummy(.v2),
            0x5d: .ifClassOfIs(.v2),
            0x5e: .walkActorTo(.v2),
            0x5f: .ifNotState02(.v2),
            
            0x60: .cursorCommand(.v2),
            0x61: .putActor(.v2),
            0x62: .stopScript(.v2),
            0x63: .getActorFacing,
            
            0x64: .loadRoomWithEgo(.v2),
            0x65: .drawObject(.v2),
            0x66: .getClosestObjActor,
            0x67: .clearState04(.v2),
            
            0x68: .isScriptRunning,
            0x69: .setOwnerOf(.v2),
            0x6a: .subIndirect(.v2),
            0x6b: .dummy(.v2),
            
            0x6c: .getObjPreposition(.v2),
            0x6d: .putActorInRoom(.v2),
            0x6e: .dummy(.v2),
            0x6f: .ifState04(.v2),
            
            0x70: .lights(.v2),
            0x71: .getActorCostume,
            0x72: .loadRoom,
            0x73: .roomOps(.v2),
            
            0x74: .getDist,
            0x75: .findObject(.v2),
            0x76: .walkActorToObject(.v2),
            0x77: .clearState01(.v2),
            
            0x78: .isGreater(.v2),
            0x79: .doSentence(.v2),
            0x7a: .verbOps(.v2),
            0x7b: .getActorWalkBox(.v2),
            
            0x7c: .isSoundRunning,
            0x7d: .setActorElevation(.v2),
            0x7e: .walkActorTo(.v2),
            0x7f: .ifState01(.v2),
            
            0x80: .breakHere,
            0x81: .putActor(.v2),
            0x82: .startMusic,
            0x83: .getActorRoom,
            
            0x84: .isGreaterEqual(.v2),
            0x85: .drawObject(.v2),
            0x86: .getActorElevation(.v2),
            0x87: .setState08(.v2),
            
            0x88: .isNotEqual,
            0x89: .faceActor,
            0x8a: .assignVarWordIndirect(.v2),
            0x8b: .setObjPreposition(.v2),
            
            0x8c: .resourceRoutines(.v2),
            0x8d: .walkActorToActor,
            0x8e: .putActorAtObject(.v2),
            0x8f: .ifNotState08(.v2),
            
            0x90: .getObjectOwner,
            0x91: .animateActor,
            0x92: .panCameraTo(.v2),
            0x93: .actorOps(.v2),
            
            0x94: .print,
            0x95: .actorFromPos(.v2),
            0x96: .getRandomNr,
            0x97: .clearState02(.v2),
            
            0x98: .restart(.v2),
            0x99: .doSentence(.v2),
            0x9a: .move,
            0x9b: .setBitVar(.v2),
            
            0x9c: .startSound,
            0x9d: .ifClassOfIs(.v2),
            0x9e: .walkActorTo(.v2),
            0x9f: .ifState02(.v2),
            
            0xa0: .stopObjectCode,
            0xa1: .putActor(.v2),
            0xa2: .saveLoadGame(.v4),
            0xa3: .getActorY(.v2),
            
            0xa4: .loadRoomWithEgo(.v2),
            0xa5: .drawObject(.v2),
            0xa6: .setVarRange,
            0xa7: .setState04(.v2),
            
            0xa8: .notEqualZero,
            0xa9: .setOwnerOf(.v2),
            0xaa: .addIndirect(.v2),
            0xab: .switchCostumeSet(.v2),
            
            0xac: .drawSentence(.v2),
            0xad: .putActorInRoom(.v2),
            0xae: .waitForMessage(.v2),
            0xaf: .ifNotState04(.v2),
            
            0xb0: .setBoxFlags(.v3),
            0xb1: .getBitVar(.v2),
            0xb2: .setCameraAt(.v2),
            0xb3: .roomOps(.v2),
            
            0xb4: .getDist,
            0xb5: .findObject(.v2),
            0xb6: .walkActorToObject(.v2),
            0xb7: .setState01(.v2),
            
            0xb8: .isLessEqual(.v2),
            0xb9: .doSentence(.v2),
            0xba: .subtract(.v2),
            0xbb: .waitForActor(.v2),
            
            0xbc: .stopSound,
            0xbd: .setActorElevation(.v2),
            0xbe: .walkActorTo(.v2),
            0xbf: .ifNotState01(.v2),
            
            0xc0: .endCutscene(.v2),
            0xc1: .putActor(.v2),
            0xc2: .startScript(.v2),
            0xc3: .getActorX(.v2),
            
            0xc4: .isLess(.v2),
            0xc5: .drawObject(.v2),
            0xc6: .decrement,
            0xc7: .clearState08(.v2),
            
            0xc8: .isEqual,
            0xc9: .faceActor,
            0xca: .chainScript(.v2),
            0xcb: .setObjPreposition(.v2),
            
            0xcc: .pseudoRoom,
            0xcd: .walkActorToActor,
            0xce: .putActorAtObject(.v2),
            0xcf: .ifState08(.v2),
            
            0xd0: .pickupObject(.v2),
            0xd1: .animateActor,
            0xd2: .actorFollowCamera,
            0xd3: .actorOps(.v2),
            
            0xd4: .setObjectName,
            0xd5: .actorFromPos(.v2),
            0xd6: .getActorMoving,
            0xd7: .setState02(.v2),
            
            0xd8: .printEgo,
            0xd9: .doSentence(.v2),
            0xda: .add(.v2),
            0xdb: .setBitVar(.v2),
            
            0xdc: .dummy(.v2),
            0xdd: .ifClassOfIs(.v2),
            0xde: .walkActorTo(.v2),
            0xdf: .ifNotState02(.v2),
            
            0xe0: .cursorCommand(.v2),
            0xe1: .putActor(.v2),
            0xe2: .stopScript(.v2),
            0xe3: .getActorFacing,
            
            0xe4: .loadRoomWithEgo(.v2),
            0xe5: .drawObject(.v2),
            0xe6: .getClosestObjActor,
            0xe7: .clearState04(.v2),
            
            0xe8: .isScriptRunning,
            0xe9: .setOwnerOf(.v2),
            0xea: .subIndirect(.v2),
            0xeb: .dummy(.v2),
            
            0xec: .getObjPreposition(.v2),
            0xed: .putActorInRoom(.v2),
            0xee: .dummy(.v2),
            0xef: .ifState04(.v2),
            
            0xf0: .lights(.v2),
            0xf1: .getActorCostume,
            0xf2: .loadRoom,
            0xf3: .roomOps(.v2),
            
            0xf4: .getDist,
            0xf5: .findObject(.v2),
            0xf6: .walkActorToObject(.v2),
            0xf7: .clearState01(.v2),
            
            0xf8: .isGreater(.v2),
            0xf9: .doSentence(.v2),
            0xfa: .verbOps(.v2),
            0xfb: .getActorWalkBox(.v2),
            
            0xfc: .isSoundRunning,
            0xfd: .setActorElevation(.v2),
            0xfe: .walkActorTo(.v2),
            0xff: .ifState01(.v2)
        ]
    }
}
