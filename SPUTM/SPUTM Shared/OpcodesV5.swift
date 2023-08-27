//
//  OpcodesV5.swift
//  SPUTM
//
//  Created by Michael Borgmann on 27/08/2023.
//

import Foundation

struct Opcode {
    
    private lazy var opcodes: [UInt8: () -> Void] = {
        [:
            0x00: stopObjectCode,
            0x01: putActor,
            0x02: startMusic,
            0x03: getActorRoot,
            0x04: isGreaterEqual,
            0x05: drawObject,
            0x06: getActorElevation,
            0x07: setState,
            0x08: isNotEqual,
            0x09: faceActor,
            0x0a: startScript,
            0x0b: getVerbEntrypoint,
            0x0c: resourceRoutines,
            0x0d: walkActorToActor,
            0x0e: putActorAtObject,
            0x0f: getObjectState,
            0x10: getObjectOwner,
            0x11: animateActor,
            0x12: panCameraTo,
            0x13: actorOps,
            0x14: print,
            0x15: actorFromPos,
            0x16: getRandomNr,
            0x17: and,
            0x18: jumpRelative,
            0x19: doSentence,
            0x1a: move,
            0x1b: multiply,
            0x1c: startSound,
            0x1d: ifClassOfIs,
            0x1e: walkActorTo,
            0x1f: isActorInBox,
            0x20: stopMusic,
            0x21: putActor,
            0x22: getAnimCounter,
            0x23: getActorY,
            0x24: loadRoomWithEgo,
            0x25: pickupObject,
            0x26: setVarRange,
            0x27: stringOps,
            0x28: equalZero,
            0x29: setOwnerOf,
            0x2a: startScript,
            0x2b: delayVariable,
            0x2c: cursorCommand,
            0x2d: putActorInRoom
            0x2e: delay
            //0x2f: ifNotState,
            0x30: matrixOps,
            0x31: getInventoryCount,
            0x32: setCameraAt,
            0x33: roomOps,
            0x34: getDist,
            0x35: findObject,
            0x36: walkActorToObject,
            0x37: startObject,
            0x38: isLessEqual,
            0x39: doSentence,
            0x3a: subtract,
            0x3b: getActorScale,
            0x3c: stopSound,
            0x3d: findInventory,
            0x3e: walkActorTo,
            0x3f: drawBox,
            0x40: cutscene,
            0x41: putActor,
            0x42: chainScript,
            0x43: getActorX,
            0x44: isLess,
            //0x45: drawObject,
            0x46: increment,
            0x47: setState,
            0x48: isEqual,
            0x49: faceActor,
            0x4a: startScript,
            0x4b: getVerbEntrypoint,
            0x4c: soundKludge,
            0x4d: walkActorToActor,
            0x4e: putActorAtObject,
            //0x4f: ifState,
            //0x50: pickupObjectOld,
            0x51: animateActor,
            0x52: actorFollowCamera,
            0x53: actorOps,
            0x54: setObjectName,
            0x55: actorFromPos,
            0x56: getActorMoving,
            0x57: or,
            0x58: beginOverride,
            0x59: doSentence,
            0x5a: add,
            0x5b: divide,
            //0x5c: oldRoomEffect,
            0x5d: setClass,
            0x5e: walkActorTo,
            0x5f: isActorInBox,
            0x60: freezeScripts,
            0x61: putActor,
            0x62: stopScript,
            0x63: getActorFacing,
            0x64: loadRoomWithEgo,
            0x65: pickupObject,
            0x66: getClosestObjActor,
            0x67: getStringWidth,
            0x68: isScriptRunning,
            0x69: setOwnerOf,
            0x6a: startScript,
            0x6b: debug,
            0x6c: getActorWidth,
            0x6d: putActorInRoom,
            0x6e: stopObjectScript,
            //0x6f: ifNotState,
            0x70: lights,
            0x71: getActorCostume,
            0x72: loadRoom,
            0x73: roomOps,
            0x74: getDist,
            0x75: findObject,
            0x76: walkActorToObject,
            0x77: startObject,
            0x78: isGreater,
            0x79: doSentence,
            0x7a: verbOps,
            0x7b: getActorWalkBox,
            0x7c: isSoundRunning,
            0x7d: findInventory,
            0x7e: walkActorTo,
            0x7f: drawBox,
            0x80: breakHere,
            0x81: putActor,
            0x82: startMusic,
            0x83: getActorRoom,
            0x84: isGreaterEqual,
            0x85: drawObject,
            0x86: getActorElevation,
            0x87: setState,
            0x88: isNotEqual,
            0x89: faceActor,
            0x8a: startScript,
            0x8b: getVerbEntrypoint,
            0x8c: resourceRoutines,
            0x8d: walkActorToActor,
            0x8e: putActorAtObject,
            0x8f: getObjectState,
            0x90: getObjectOwner,
            0x91: animateActor,
            0x92: panCameraTo,
            0x93: actorOps,
            0x94: print,
            0x95: actorFromPos,
            0x96: getRandomNr,
            0x97: and,
            0x98: systemOps,
            0x99: doSentence,
            0x9a: move,
            0x9b: multiply,
            0x9c: startSound,
            0x9d: ifClassOfIs,
            0x9e: walkActorTo,
            0x9f: isActorInBox,
            0xa0: stopObjectCode,
            0xa1: putActor,
            0xa2: getAnimCounter,
            0xa3: getActorY,
            0xa4: loadRoomWithEgo,
            0xa5: pickupObject,
            0xa6: setVarRange,
            0xa7: dummy,
            0xa8: notEqualZero,
            0xa9: setOwnerOf,
            0xaa: startScript,
            0xab: saveRestoreVerbs,
            0xac: expression,
            0xad: putActorInRoom,
            0xae: wait,
            //0xaf: ifNotState,
            0xb0: matrixOps,
            0xb1: getInventoryCount,
            0xb2: setCameraAt,
            0xb3: roomOps,
            0xb4: getDist,
            0xb5: findObject,
            0xb6: walkActorToObject,
            0xb7: startObject,
            0xb8: isLessEqual,
            0xb9: doSentence,
            0xba: subtract,
            0xbb: getActorScale,
            0xbc: stopSound,
            0xbd: findInventory,
            0xbe: walkActorTo,
            0xbf: drawBox,
            0xc0: endCutscene,
            0xc1: putActor,
            0xc2: chainScript,
            0xc3: getActorX,
            0xc4: isLess,
            //0xc5: drawObject,
            0xc6: decrement,
            0xc7: setState,
            0xc8: isEqual,
            0xc9: faceActor,
            0xca: startScript,
            0xcb: getVerbEntrypoint,
            0xcc: pseudoRoom,
            0xcd: walkActorToActor,
            0xce: putActorAtObject,
            //0xcf: ifState,
            //0xd0: pickupObjectOld,
            0xd1: animateActor,
            0xd2: actorFollowCamera,
            0xd3: actorOps,
            0xd4: setObjectName,
            0xd5: actorFromPos,
            0xd6: getActorMoving,
            0xd7: or,
            0xd8: printEgo,
            0xd9: doSentence,
            0xda: add,
            0xdb: divide,
            //0xdc: oldRoomEffect,
            0xdd: setClass,
            0xde: walkActorTo,
            0xdf: isActorInBox,
            0xe0: freezeScripts,
            0xe1: putActor,
            0xe2: stopScript,
            0xe3: getActorFacing,
            0xe4: loadRoomWithEgo,
            0xe5: pickupObject,
            0xe6: getClosestObjActor,
            0xe7: getStringWidth,
            0xe8: isScriptRunning,
            0xe9: setOwnerOf,
            0xea: startScript,
            0xeb: debug,
            0xec: getActorWidth,
            0xed: putActorInRoom,
            0xee: stopObjectScript,
            //0xef: ifNotState,
            0xf0: lights,
            0xf1: getActorCostume,
            0xf2: loadRoom,
            0xf3: roomOps,
            0xf4: getDist,
            0xf5: findObject,
            0xf6: walkActorToObject,
            0xf7: startObject,
            0xf8: isGreater,
            0xf9: doSentence,
            0xfa: verbOps,
            0xfb: getActorWalkBox,
            0xfc: isSoundRunning,
            0xfd: findInventory,
            0xfe: walkActorTo,
            0xff: drawBox
        ]
    }()
    
    private func stopObjectCode() {}
    private func putActor() {}
    private func startMusic() {}
    private func getActorRoot() {}
    private func isGreaterEqual() {}
    private func drawObject() {}
    private func getActorElevation() {}
    private func setState() {}
    private func isNotEqual() {}
    private func faceActor() {}
    private func startScript() {}
    private func getVerbEntrypoint() {}
    private func resourceRoutines() {}
    private func walkActorToActor() {}
    private func putActorAtObject() {}
    private func getObjectState() {}
    private func getObjectOwner() {}
    private func animateActor() {}
    private func panCameraTo() {}
    private func actorOps() {}
    private func print() {}
    private func actorFromPos() {}
    private func getRandomNr() {}
    private func and() {}
    private func jumpRelative() {}
    private func doSentence() {}
    private func move() {}
    private func multiply() {}
    private func startSound() {}
    private func ifClassOfIs() {}
    private func walkActorTo() {}
    private func isActorInBox() {}
    private func stopMusic() {}
    private func getAnimCounter() {}
    private func getActorY() {}
    private func loadRoomWithEgo() {}
    private func pickupObject() {}
    private func setVarRange() {}
    private func stringOps() {}
    private func equalZero() {}
    private func setOwnerOf() {}
    private func delayVariable() {}
    private func cursorCommand() {}
    private func putActorInRoom() {}
    private func delay() {}
    //private func ifNotState() {}
    private func matrixOps() {}
    private func getInventoryCount() {}
    private func setCameraAt() {}
    private func roomOps() {}
    private func getDist() {}
    private func findObject() {}
    private func walkActorToObject() {}
    private func startObject() {}
    private func isLessEqual() {}
    private func subtract() {}
    private func getActorScale() {}
    private func stopSound() {}
    private func findInventory() {}
    private func drawBox() {}
    private func cutscene() {}
    private func chainScript() {}
    private func getActorX() {}
    private func isLess() {}
    private func increment() {}
    private func isEqual() {}
    private func soundKludge() {}
    //private func ifState() {}
    //private func pickupObjectOld() {}
    private func actorFollowCamera() {}
    private func setObjectName() {}
    private func getActorMoving() {}
    private func or() {}
    private func beginOverride() {}
    private func divide() {}
    //private func oldRoomEffect() {}
    private func setClass() {}
    private func freezeScripts() {}
    private func stopScript() {}
    private func getActorFacing() {}
    private func getClosestObjActor() {}
    private func getStringWidth() {}
    private func isScriptRunning() {}
    private func debug() {}
    private func getActorWidth() {}
    private func stopObjectScript() {}
    private func lights() {}
    private func getActorCostume() {}
    private func loadRoom() {}
    private func isGreater() {}
    private func verbOps() {}
    private func getActorWalkBox() {}
    private func isSoundRunning() {}
    private func breakHere() {}
    private func getActorRoom() {}
    private func systemOps() {}
    private func dummy() {}
    private func notEqualZero() {}
    private func saveRestoreVerbs() {}
    private func expression() {}
    private func wait() {}
    private func endCutscene() {}
    private func decrement() {}
    private func pseudoRoom() {}
    private func printEgo() {}
}
