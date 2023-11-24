//
//  CommonOpcodes.swift
//  SPUTM
//
//  Created by Michael Borgmann on 22/11/2023.
//

import Foundation

struct CommonOpcodes {
    
    static var sharedV3V4: [UInt8: Instructions] {
        [
            0x0f: .ifState(.v4),
            0x4f: .ifState(.v4),
            0x8f: .ifState(.v4),
            0xcf: .ifState(.v4),
            
            0x2f: .ifNotState(.v4),
            0x6f: .ifNotState(.v4),
            0xaf: .ifNotState(.v4),
            0xef: .ifNotState(.v4),
            
            0x25: .drawObject(.v5),
            0x45: .drawObject(.v5),
            0x65: .drawObject(.v5),
            0xa5: .drawObject(.v5),
            0xc5: .drawObject(.v5),
            0xe5: .drawObject(.v5),
            
            0x50: .pickupObject(.v4),
            0xd0: .pickupObject(.v4),
            
            0x5c: .oldRoomEffect(.v4),
            0xdc: .oldRoomEffect(.v4),
            
            0xa7: .saveLoadVars(.v4),
            
            0x22: .saveLoadGame(.v4),
            0xa2: .saveLoadGame(.v4),
        ]
    }
    
    static var sharedV3V4V5: [UInt8: Instructions] {
        [
            0x00: .stopObjectCode(.v5),
            0x01: .putActor(.v5),
            0x02: .startMusic(.v5),
            0x03: .getActorRoot,
            0x04: .isGreaterEqual(.v5),
            0x05: .drawObject(.v5),
            0x06: .getActorElevation(.v5),
            0x07: .setState(.v5),
            0x08: .isNotEqual,
            0x09: .faceActor(.v5),
            0x0a: .startScript(.v5),
            0x0b: .getVerbEntrypoint(.v5),
            0x0c: .resourceRoutines(.v5),
            0x0d: .walkActorToActor,
            0x0e: .putActorAtObject(.v5),
            //0x0f
            0x10: .getObjectOwner,
            0x11: .animateActor(.v5),
            0x12: .panCameraTo(.v5),
            0x13: .actorOps(.v5),
            0x14: .print,
            0x15: .actorFromPos(.v5),
            0x16: .getRandomNr(.v5),
            0x17: .and,
            0x18: .jumpRelative,
            0x19: .doSentence(.v5),
            0x1a: .move,
            0x1b: .multiply,
            0x1c: .startSound(.v5),
            0x1d: .ifClassOfIs(.v5),
            0x1e: .walkActorTo(.v5),
            0x1f: .isActorInBox(.v5),
            0x20: .stopMusic(.v5),
            0x21: .putActor(.v5),
            //0x22
            0x23: .getActorY(.v5),
            0x24: .loadRoomWithEgo(.v5),
            //0x25
            0x26: .setVarRange,
            0x27: .stringOps,
            0x28: .equalZero,
            0x29: .setOwnerOf(.v5),
            0x2a: .startScript(.v5),
            0x2b: .delayVariable,
            0x2c: .cursorCommand(.v5),
            0x2d: .putActorInRoom(.v5),
            0x2e: .delay(.v5),
            //0x2f
            0x30: .matrixOps,
            0x31: .getInventoryCount(.v5),
            0x32: .setCameraAt(.v5),
            0x33: .roomOps(.v5),
            0x34: .getDist,
            0x35: .findObject(.v5),
            0x36: .walkActorToObject(.v5),
            0x37: .startObject(.v5),
            0x38: .isLessEqual(.v5),
            0x39: .doSentence(.v5),
            0x3a: .subtract(.v5),
            //0x3b
            0x3c: .stopSound(.v5),
            0x3d: .findInventory(.v5),
            0x3e: .walkActorTo(.v5),
            0x3f: .drawBox(.v5),
            0x40: .cutscene(.v5),
            0x41: .putActor(.v5),
            0x42: .chainScript(.v5),
            0x43: .getActorX(.v5),
            0x44: .isLess(.v5),
            //0x45
            0x46: .increment,
            0x47: .setState(.v5),
            0x48: .isEqual,
            0x49: .faceActor(.v5),
            0x4a: .startScript(.v5),
            0x4b: .getVerbEntrypoint(.v5),
            //0x4c
            0x4d: .walkActorToActor,
            0x4e: .putActorAtObject(.v5),
            //0x4f
            0x51: .animateActor(.v5),
            0x52: .actorFollowCamera(.v5),
            0x53: .actorOps(.v5),
            0x54: .setObjectName(.v5),
            0x55: .actorFromPos(.v5),
            0x56: .getActorMoving(.v5),
            0x57: .or,
            0x58: .beginOverride(.v5),
            0x59: .doSentence(.v5),
            0x5a: .add(.v5),
            0x5b: .divide,
            //0x5c
            0x5d: .setClass(.v5),
            0x5e: .walkActorTo(.v5),
            0x5f: .isActorInBox(.v5),
            0x60: .freezeScripts,
            0x61: .putActor(.v5),
            0x62: .stopScript(.v5),
            0x63: .getActorFacing,
            0x64: .loadRoomWithEgo(.v5),
            //0x65
            0x66: .getClosestObjActor,
            0x67: .getStringWidth,
            0x68: .isScriptRunning(.v5),
            0x69: .setOwnerOf(.v5),
            0x6a: .startScript(.v5),
            0x6b: .debug,
            0x6c: .getActorWidth(.v5),
            0x6d: .putActorInRoom(.v5),
            0x6e: .stopObjectScript(.v5),
            //0x6f
            0x70: .lights(.v5),
            0x71: .getActorCostume(.v5),
            0x72: .loadRoom(.v5),
            0x73: .roomOps(.v5),
            0x74: .getDist,
            0x75: .findObject(.v5),
            0x76: .walkActorToObject(.v5),
            0x77: .startObject(.v5),
            0x78: .isGreater(.v5),
            0x79: .doSentence(.v5),
            0x7a: .verbOps(.v5),
            0x7b: .getActorWalkBox(.v5),
            0x7c: .isSoundRunning(.v5),
            0x7d: .findInventory(.v5),
            0x7e: .walkActorTo(.v5),
            0x7f: .drawBox(.v5),
            0x80: .breakHere(.v5),
            0x81: .putActor(.v5),
            0x82: .startMusic(.v5),
            0x83: .getActorRoom(.v5),
            0x84: .isGreaterEqual(.v5),
            0x85: .drawObject(.v5),
            0x86: .getActorElevation(.v5),
            0x87: .setState(.v5),
            0x88: .isNotEqual,
            0x89: .faceActor(.v5),
            0x8a: .startScript(.v5),
            0x8b: .getVerbEntrypoint(.v5),
            0x8c: .resourceRoutines(.v5),
            0x8d: .walkActorToActor,
            0x8e: .putActorAtObject(.v5),
            //0x8f
            0x90: .getObjectOwner,
            0x91: .animateActor(.v5),
            0x92: .panCameraTo(.v5),
            0x93: .actorOps(.v5),
            0x94: .print,
            0x95: .actorFromPos(.v5),
            0x96: .getRandomNr(.v5),
            0x97: .and,
            0x98: .systemOps(.v5),
            0x99: .doSentence(.v5),
            0x9a: .move,
            0x9b: .multiply,
            0x9c: .startSound(.v5),
            0x9d: .ifClassOfIs(.v5),
            0x9e: .walkActorTo(.v5),
            0x9f: .isActorInBox(.v5),
            0xa0: .stopObjectCode(.v5),
            0xa1: .putActor(.v5),
            //0xa2
            0xa3: .getActorY(.v5),
            0xa4: .loadRoomWithEgo(.v5),
            //0xa5
            0xa6: .setVarRange,
            //0xa7
            0xa8: .notEqualZero,
            0xa9: .setOwnerOf(.v5),
            0xaa: .startScript(.v5),
            0xab: .saveRestoreVerbs(.v5),
            0xac: .expression,
            0xad: .putActorInRoom(.v5),
            0xae: .wait(.v5),
            //0xa8
            0xb0: .matrixOps,
            0xb1: .getInventoryCount(.v5),
            0xb2: .setCameraAt(.v5),
            0xb3: .roomOps(.v5),
            0xb4: .getDist,
            0xb5: .findObject(.v5),
            0xb6: .walkActorToObject(.v5),
            0xb7: .startObject(.v5),
            0xb8: .isLessEqual(.v5),
            0xb9: .doSentence(.v5),
            0xba: .subtract(.v5),
            //0xbb
            0xbc: .stopSound(.v5),
            0xbd: .findInventory(.v5),
            0xbe: .walkActorTo(.v5),
            0xbf: .drawBox(.v5),
            0xc0: .endCutscene(.v5),
            0xc1: .putActor(.v5),
            0xc2: .chainScript(.v5),
            0xc3: .getActorX(.v5),
            0xc4: .isLess(.v5),
            //0xc5
            0xc6: .decrement,
            0xc7: .setState(.v5),
            0xc8: .isEqual,
            0xc9: .faceActor(.v5),
            0xca: .startScript(.v5),
            0xcb: .getVerbEntrypoint(.v5),
            0xcc: .pseudoRoom(.v5),
            0xcd: .walkActorToActor,
            0xce: .putActorAtObject(.v5),
            //0xcf
            //0xd0
            0xd1: .animateActor(.v5),
            0xd2: .actorFollowCamera(.v5),
            0xd3: .actorOps(.v5),
            0xd4: .setObjectName(.v5),
            0xd5: .actorFromPos(.v5),
            0xd6: .getActorMoving(.v5),
            0xd7: .or,
            0xd8: .printEgo(.v5),
            0xd9: .doSentence(.v5),
            0xda: .add(.v5),
            0xdb: .divide,
            //0xdc
            0xdd: .setClass(.v5),
            0xde: .walkActorTo(.v5),
            0xdf: .isActorInBox(.v5),
            0xe0: .freezeScripts,
            0xe1: .putActor(.v5),
            0xe2: .stopScript(.v5),
            0xe3: .getActorFacing,
            0xe4: .loadRoomWithEgo(.v5),
            //0xe5
            0xe6: .getClosestObjActor,
            0xe7: .getStringWidth,
            0xe8: .isScriptRunning(.v5),
            0xe9: .setOwnerOf(.v5),
            0xea: .startScript(.v5),
            0xeb: .debug,
            0xec: .getActorWidth(.v5),
            0xed: .putActorInRoom(.v5),
            0xee: .stopObjectScript(.v5),
            //0xef
            0xf0: .lights(.v5),
            0xf1: .getActorCostume(.v5),
            0xf2: .loadRoom(.v5),
            0xf3: .roomOps(.v5),
            0xf4: .getDist,
            0xf5: .findObject(.v5),
            0xf6: .walkActorToObject(.v5),
            0xf7: .startObject(.v5),
            0xf8: .isGreater(.v5),
            0xf9: .doSentence(.v5),
            0xfa: .verbOps(.v5),
            0xfb: .getActorWalkBox(.v5),
            0xfc: .isSoundRunning(.v5),
            0xfd: .findInventory(.v5),
            0xfe: .walkActorTo(.v5),
            0xff: .drawBox(.v5)
        ]
    }
}
