//
//  OpcodeDefinitions.swift
//  SPUTM
//
//  Created by Michael Borgmann on 19/11/2023.
//

import Foundation
import ScummCore

// MARK: - Opcode Protocol

protocol OpcodeProtocol {
    var version: ScummVersion { get }
    static func execute(byteCode: Int)
}

extension OpcodeProtocol {
    var version: ScummVersion { .v5 }
}

// MARK: - Opcodes V5

struct StopObjectCode: OpcodeProtocol {
    
    let version: ScummVersion
    
    init(_ version: ScummVersion) {
        self.version = version
    }
    
    static func execute(byteCode: Int) {
        debugPrint("Stop Object Code (0x\(byteCode))")
    }
}

struct PutActor: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("PutActor (0x\(byteCode))")
    }
}

struct StartMusic: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("StartMusic (0x\(byteCode))")
    }
}

struct GetActorRoot: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("GetActorRoot (0x\(byteCode))")
    }
}

struct IsGreaterEqual: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("IsGreaterEqual (0x\(byteCode))")
    }
}

struct DrawObject: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("DrawObject (0x\(byteCode))")
    }
}

struct GetActorElevation: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("GetActorElevation (0x\(byteCode))")
    }
}

struct SetState: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("SetState (0x\(byteCode))")
    }
}

struct IsNotEqual: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("IsNotEqual (0x\(byteCode))")
    }
}

struct FaceActor: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("FaceActor (0x\(byteCode))")
    }
}

struct StartScript: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("StartScript (0x\(byteCode))")
    }
}

struct GetVerbEntrypoint: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("GetVerbEntrypoint (0x\(byteCode))")
    }
}

struct ResourceRoutines: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("ResourceRoutines (0x\(byteCode))")
    }
}

struct WalkActorToActor: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("WalkActorToActor (0x\(byteCode))")
    }
}

struct PutActorAtObject: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("PutActorAtObject (0x\(byteCode))")
    }
}

struct GetObjectState: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("GetObjectState (0x\(byteCode))")
    }
}

struct GetObjectOwner: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("GetObjectOwner (0x\(byteCode))")
    }
}

struct AnimateActor: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("AnimateActor (0x\(byteCode))")
    }
}

struct PanCameraTo: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("PanCameraTo (0x\(byteCode))")
    }
}

struct ActorOps: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("ActorOps (0x\(byteCode))")
    }
}

struct Print: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("Print (0x\(byteCode))")
    }
}

struct ActorFromPos: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("ActorFromPos (0x\(byteCode))")
    }
}

struct GetRandomNr: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("GetRandomNr (0x\(byteCode))")
    }
}

struct And: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("And (0x\(byteCode))")
    }
}

struct JumpRelative: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("JumpRelative (0x\(byteCode))")
    }
}

struct DoSentence: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("DoSentence (0x\(byteCode))")
    }
}

struct Move: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("Move (0x\(byteCode))")
    }
}

struct Multiply: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("Multiply (0x\(byteCode))")
    }
}

struct StartSound: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("StartSound (0x\(byteCode))")
    }
}

struct IfClassOfIs: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("IfClassOfIs (0x\(byteCode))")
    }
}

struct WalkActorTo: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("WalkActorTo (0x\(byteCode))")
    }
}

struct IsActorInBox: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("IsActorInBox (0x\(byteCode))")
    }
}

struct StopMusic: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("StopMusic (0x\(byteCode))")
    }
}

struct GetAnimCounter: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("GetAnimCounter (0x\(byteCode))")
    }
}

struct GetActorY: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("GetActorY (0x\(byteCode))")
    }
}

struct LoadRoomWithEgo: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("LoadRoomWithEgo (0x\(byteCode))")
    }
}

struct PickupObject: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        
        
        
        debugPrint("PickupObject (0x\(byteCode))")
    }
}

struct SetVarRange: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("SetVarRange (0x\(byteCode))")
    }
}

struct StringOps: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("StringOps (0x\(byteCode))")
    }
}

struct EqualZero: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("EqualZero (0x\(byteCode))")
    }
}

struct SetOwnerOf: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("SetOwnerOf (0x\(byteCode))")
    }
}

struct DelayVariable: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("DelayVariable (0x\(byteCode))")
    }
}

struct CursorCommand: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("CursorCommand (0x\(byteCode))")
    }
}

struct PutActorInRoom: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("PutActorInRoom (0x\(byteCode))")
    }
}

struct Delay: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("Delay (0x\(byteCode))")
    }
}

struct MatrixOps: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("MatrixOps (0x\(byteCode))")
    }
}

struct GetInventoryCount: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("GetInventoryCount (0x\(byteCode))")
    }
}

struct SetCameraAt: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("SetCameraAt (0x\(byteCode))")
    }
}

struct RoomOps: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("RoomOps (0x\(byteCode))")
    }
}

struct GetDist: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("GetDist (0x\(byteCode))")
    }
}

struct FindObject: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("FindObject (0x\(byteCode))")
    }
}

struct WalkActorToObject: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("WalkActorToObject (0x\(byteCode))")
    }
}

struct StartObject: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("StartObject (0x\(byteCode))")
    }
}

struct IsLessEqual: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("IsLessEqual (0x\(byteCode))")
    }
}

struct Subtract: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("Subtract (0x\(byteCode))")
    }
}

struct GetActorScale: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("GetActorScale (0x\(byteCode))")
    }
}

struct StopSound: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("StopSound (0x\(byteCode))")
    }
}

struct FindInventory: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("FindInventory (0x\(byteCode))")
    }
}

struct DrawBox: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("DrawBox (0x\(byteCode))")
    }
}

struct Cutscene: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("Cutscene (0x\(byteCode))")
    }
}

struct ChainScript: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("ChainScript (0x\(byteCode))")
    }
}

struct GetActorX: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("GetActorX (0x\(byteCode))")
    }
}

struct IsLess: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("IsLess (0x\(byteCode))")
    }
}

struct Increment: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("Increment (0x\(byteCode))")
    }
}

struct IsEqual: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("IsEqual (0x\(byteCode))")
    }
}

struct SoundKludge: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("SoundKludge (0x\(byteCode))")
    }
}

struct ActorFollowCamera: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("ActorFollowCamera (0x\(byteCode))")
    }
}

struct SetObjectName: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("SetObjectName (0x\(byteCode))")
    }
}

struct GetActorMoving: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("GetActorMoving (0x\(byteCode))")
    }
}

struct Or: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("Or (0x\(byteCode))")
    }
}

struct BeginOverride: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("BeginOverride (0x\(byteCode))")
    }
}

struct Add: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("Add (0x\(byteCode))")
    }
}

struct Divide: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("Divide (0x\(byteCode))")
    }
}

struct SetClass: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("SetClass (0x\(byteCode))")
    }
}

struct FreezeScripts: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("FreezeScripts (0x\(byteCode))")
    }
}

struct StopScript: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("StopScript (0x\(byteCode))")
    }
}

struct GetActorFacing: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("GetActorFacing (0x\(byteCode))")
    }
}

struct GetClosestObjActor: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("GetClosestObjActor (0x\(byteCode))")
    }
}

struct GetStringWidth: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("GetStringWidth (0x\(byteCode))")
    }
}

struct IsScriptRunning: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("IsScriptRunning (0x\(byteCode))")
    }
}

struct Debug: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("Debug (0x\(byteCode))")
    }
}

struct GetActorWidth: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("GetActorWidth (0x\(byteCode))")
    }
}

struct StopObjectScript: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("StopObjectScript (0x\(byteCode))")
    }
}

struct Lights: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("Lights (0x\(byteCode))")
    }
}

struct GetActorCostume: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("GetActorCostume (0x\(byteCode))")
    }
}

struct LoadRoom: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("LoadRoom (0x\(byteCode))")
    }
}

struct IsGreater: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("IsGreater (0x\(byteCode))")
    }
}

struct VerbOps: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("VerbOps (0x\(byteCode))")
    }
}

struct GetActorWalkBox: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("GetActorWalkBox (0x\(byteCode))")
    }
}

struct IsSoundRunning: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("IsSoundRunning (0x\(byteCode))")
    }
}

struct BreakHere: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("BreakHere (0x\(byteCode))")
    }
}

struct GetActorRoom: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("GetActorRoom (0x\(byteCode))")
    }
}

struct SystemOps: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("SystemOps (0x\(byteCode))")
    }
}

struct Dummy: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("Dummy (0x\(byteCode))")
    }
}

struct NotEqualZero: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("NotEqualZero (0x\(byteCode))")
    }
}

struct SaveRestoreVerbs: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("SaveRestoreVerbs (0x\(byteCode))")
    }
}

struct Expression: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("Expression (0x\(byteCode))")
    }
}

struct Wait: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("Wait (0x\(byteCode))")
    }
}

struct EndCutscene: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("EndCutscene (0x\(byteCode))")
    }
}

struct Decrement: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("Decrement (0x\(byteCode))")
    }
}

struct PseudoRoom: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("PseudoRoom (0x\(byteCode))")
    }
}

struct PrintEgo: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("PrintEgo (0x\(byteCode))")
    }
}

// MARK: - Opcodes V4

/*
struct DrawObject: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("DrawObject (0x\(byteCode))")
    }
}
*/

/*
struct PickupObject: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("PickupObject (0x\(byteCode))")
    }
}
*/

struct OldRoomEffect: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("OldRoomEffect (0x\(byteCode))")
    }
}

struct IfState: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("IfState (0x\(byteCode))")
    }
}

struct IfNotState: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("IfNotState (0x\(byteCode))")
    }
}

struct SaveLoadVars: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("SaveLoadVars (0x\(byteCode))")
    }
}

struct SaveLoadGame: OpcodeProtocol {
    
    static func execute(byteCode: Int) {
        debugPrint("SaveLoadGame (0x\(byteCode))")
    }
}
