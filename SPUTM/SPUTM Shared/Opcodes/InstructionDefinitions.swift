//
//  InstructionDefinitions.swift
//  SPUTM
//
//  Created by Michael Borgmann on 19/11/2023.
//

import Foundation
import ScummCore

// MARK: - Instruction V5
/*
struct StopObjectCode: InstructionProtocol {
    
    let version: ScummVersion
    
    init(_ version: ScummVersion) {
        self.version = version
    }
    
    static func execute() {
        debugPrint("Stop Object Code")
    }
}

struct PutActor: InstructionProtocol {
    
    static func execute() {
        debugPrint("PutActor")
    }
}

struct StartMusic: InstructionProtocol {
    
    static func execute() {
        debugPrint("StartMusic")
    }
}

struct GetActorRoot: InstructionProtocol {
    
    static func execute() {
        debugPrint("GetActorRoot")
    }
}

struct IsGreaterEqual: InstructionProtocol {
    
    static func execute() {
        debugPrint("IsGreaterEqual")
    }
}

struct DrawObject: InstructionProtocol {
    
    static func execute() {
        debugPrint("DrawObject")
    }
}

struct GetActorElevation: InstructionProtocol {
    
    static func execute() {
        debugPrint("GetActorElevation")
    }
}

struct SetState: InstructionProtocol {
    
    static func execute() {
        debugPrint("SetState")
    }
}

struct IsNotEqual: InstructionProtocol {
    
    static func execute() {
        debugPrint("IsNotEqual")
    }
}

struct FaceActor: InstructionProtocol {
    
    static func execute() {
        debugPrint("FaceActor")
    }
}

struct StartScript: InstructionProtocol {
    
    static func execute() {
        debugPrint("StartScript")
    }
}

struct GetVerbEntrypoint: InstructionProtocol {
    
    static func execute() {
        debugPrint("GetVerbEntrypoint")
    }
}

struct ResourceRoutines: InstructionProtocol {
    
    static func execute() {
        debugPrint("ResourceRoutines")
    }
}

struct WalkActorToActor: InstructionProtocol {
    
    static func execute() {
        debugPrint("WalkActorToActor")
    }
}

struct PutActorAtObject: InstructionProtocol {
    
    static func execute() {
        debugPrint("PutActorAtObject")
    }
}

struct GetObjectState: InstructionProtocol {
    
    static func execute() {
        debugPrint("GetObjectState")
    }
}

struct GetObjectOwner: InstructionProtocol {
    
    static func execute() {
        debugPrint("GetObjectOwner")
    }
}

struct AnimateActor: InstructionProtocol {
    
    static func execute() {
        debugPrint("AnimateActor")
    }
}

struct PanCameraTo: InstructionProtocol {
    
    static func execute() {
        debugPrint("PanCameraTo")
    }
}

struct ActorOps: InstructionProtocol {
    
    static func execute() {
        debugPrint("ActorOps")
    }
}

struct Print: InstructionProtocol {
    
    static func execute() {
        debugPrint("Print")
    }
}

struct ActorFromPos: InstructionProtocol {
    
    static func execute() {
        debugPrint("ActorFromPos")
    }
}

struct GetRandomNr: InstructionProtocol {
    
    static func execute() {
        debugPrint("GetRandomNr")
    }
}

struct And: InstructionProtocol {
    
    static func execute() {
        debugPrint("And")
    }
}

struct JumpRelative: InstructionProtocol {
    
    static func execute() {
        debugPrint("JumpRelative")
    }
}

struct DoSentence: InstructionProtocol {
    
    static func execute() {
        debugPrint("DoSentence")
    }
}
*/


/*
struct Multiply: InstructionProtocol {
    
    static func execute() {
        debugPrint("Multiply")
    }
}

struct StartSound: InstructionProtocol {
    
    static func execute() {
        debugPrint("StartSound")
    }
}

struct IfClassOfIs: InstructionProtocol {
    
    static func execute() {
        debugPrint("IfClassOfIs")
    }
}

struct WalkActorTo: InstructionProtocol {
    
    static func execute() {
        debugPrint("WalkActorTo")
    }
}

struct IsActorInBox: InstructionProtocol {
    
    static func execute() {
        debugPrint("IsActorInBox")
    }
}

struct StopMusic: InstructionProtocol {
    
    static func execute() {
        debugPrint("StopMusic")
    }
}

struct GetAnimCounter: InstructionProtocol {
    
    static func execute() {
        debugPrint("GetAnimCounter")
    }
}

struct GetActorY: InstructionProtocol {
    
    static func execute() {
        debugPrint("GetActorY")
    }
}

struct LoadRoomWithEgo: InstructionProtocol {
    
    static func execute() {
        debugPrint("LoadRoomWithEgo")
    }
}

struct PickupObject: InstructionProtocol {
    
    static func execute() {
        
        
        
        debugPrint("PickupObject")
    }
}

struct SetVarRange: InstructionProtocol {
    
    static func execute() {
        debugPrint("SetVarRange")
    }
}

struct StringOps: InstructionProtocol {
    
    static func execute() {
        debugPrint("StringOps")
    }
}

struct EqualZero: InstructionProtocol {
    
    static func execute() {
        debugPrint("EqualZero")
    }
}

struct SetOwnerOf: InstructionProtocol {
    
    static func execute() {
        debugPrint("SetOwnerOf")
    }
}

struct DelayVariable: InstructionProtocol {
    
    static func execute() {
        debugPrint("DelayVariable")
    }
}

struct CursorCommand: InstructionProtocol {
    
    static func execute() {
        debugPrint("CursorCommand")
    }
}

struct PutActorInRoom: InstructionProtocol {
    
    static func execute() {
        debugPrint("PutActorInRoom")
    }
}

struct Delay: InstructionProtocol {
    
    static func execute() {
        debugPrint("Delay")
    }
}

struct MatrixOps: InstructionProtocol {
    
    static func execute() {
        debugPrint("MatrixOps")
    }
}

struct GetInventoryCount: InstructionProtocol {
    
    static func execute() {
        debugPrint("GetInventoryCount")
    }
}

struct SetCameraAt: InstructionProtocol {
    
    static func execute() {
        debugPrint("SetCameraAt")
    }
}

struct RoomOps: InstructionProtocol {
    
    static func execute() {
        debugPrint("RoomOps")
    }
}

struct GetDist: InstructionProtocol {
    
    static func execute() {
        debugPrint("GetDist")
    }
}

struct FindObject: InstructionProtocol {
    
    static func execute() {
        debugPrint("FindObject")
    }
}

struct WalkActorToObject: InstructionProtocol {
    
    static func execute() {
        debugPrint("WalkActorToObject")
    }
}

struct StartObject: InstructionProtocol {
    
    static func execute() {
        debugPrint("StartObject")
    }
}

struct IsLessEqual: InstructionProtocol {
    
    static func execute() {
        debugPrint("IsLessEqual")
    }
}

struct Subtract: InstructionProtocol {
    
    static func execute() {
        debugPrint("Subtract")
    }
}

struct GetActorScale: InstructionProtocol {
    
    static func execute() {
        debugPrint("GetActorScale")
    }
}

struct StopSound: InstructionProtocol {
    
    static func execute() {
        debugPrint("StopSound")
    }
}

struct FindInventory: InstructionProtocol {
    
    static func execute() {
        debugPrint("FindInventory")
    }
}

struct DrawBox: InstructionProtocol {
    
    static func execute() {
        debugPrint("DrawBox")
    }
}

struct Cutscene: InstructionProtocol {
    
    static func execute() {
        debugPrint("Cutscene")
    }
}

struct ChainScript: InstructionProtocol {
    
    static func execute() {
        debugPrint("ChainScript")
    }
}

struct GetActorX: InstructionProtocol {
    
    static func execute() {
        debugPrint("GetActorX")
    }
}

struct IsLess: InstructionProtocol {
    
    static func execute() {
        debugPrint("IsLess")
    }
}

struct Increment: InstructionProtocol {
    
    static func execute() {
        debugPrint("Increment")
    }
}

struct IsEqual: InstructionProtocol {
    
    static func execute() {
        debugPrint("IsEqual")
    }
}

struct SoundKludge: InstructionProtocol {
    
    static func execute() {
        debugPrint("SoundKludge")
    }
}

struct ActorFollowCamera: InstructionProtocol {
    
    static func execute() {
        debugPrint("ActorFollowCamera")
    }
}

struct SetObjectName: InstructionProtocol {
    
    static func execute() {
        debugPrint("SetObjectName")
    }
}

struct GetActorMoving: InstructionProtocol {
    
    static func execute() {
        debugPrint("GetActorMoving")
    }
}

struct Or: InstructionProtocol {
    
    static func execute() {
        debugPrint("Or")
    }
}

struct BeginOverride: InstructionProtocol {
    
    static func execute() {
        debugPrint("BeginOverride")
    }
}

struct Add: InstructionProtocol {
    
    static func execute() {
        debugPrint("Add")
    }
}

struct Divide: InstructionProtocol {
    
    static func execute() {
        debugPrint("Divide")
    }
}

struct SetClass: InstructionProtocol {
    
    static func execute() {
        debugPrint("SetClass")
    }
}

struct FreezeScripts: InstructionProtocol {
    
    static func execute() {
        debugPrint("FreezeScripts")
    }
}

struct StopScript: InstructionProtocol {
    
    static func execute() {
        debugPrint("StopScript")
    }
}

struct GetActorFacing: InstructionProtocol {
    
    static func execute() {
        debugPrint("GetActorFacing")
    }
}

struct GetClosestObjActor: InstructionProtocol {
    
    static func execute() {
        debugPrint("GetClosestObjActor")
    }
}

struct GetStringWidth: InstructionProtocol {
    
    static func execute() {
        debugPrint("GetStringWidth")
    }
}

struct IsScriptRunning: InstructionProtocol {
    
    static func execute() {
        debugPrint("IsScriptRunning")
    }
}

struct Debug: InstructionProtocol {
    
    static func execute() {
        debugPrint("Debug")
    }
}

struct GetActorWidth: InstructionProtocol {
    
    static func execute() {
        debugPrint("GetActorWidth")
    }
}

struct StopObjectScript: InstructionProtocol {
    
    static func execute() {
        debugPrint("StopObjectScript")
    }
}

struct Lights: InstructionProtocol {
    
    static func execute() {
        debugPrint("Lights")
    }
}

struct GetActorCostume: InstructionProtocol {
    
    static func execute() {
        debugPrint("GetActorCostume")
    }
}

struct LoadRoom: InstructionProtocol {
    
    static func execute() {
        debugPrint("LoadRoom")
    }
}

struct IsGreater: InstructionProtocol {
    
    static func execute() {
        debugPrint("IsGreater")
    }
}

struct VerbOps: InstructionProtocol {
    
    static func execute() {
        debugPrint("VerbOps")
    }
}

struct GetActorWalkBox: InstructionProtocol {
    
    static func execute() {
        debugPrint("GetActorWalkBox")
    }
}

struct IsSoundRunning: InstructionProtocol {
    
    static func execute() {
        debugPrint("IsSoundRunning")
    }
}

struct BreakHere: InstructionProtocol {
    
    static func execute() {
        debugPrint("BreakHere")
    }
}

struct GetActorRoom: InstructionProtocol {
    
    static func execute() {
        debugPrint("GetActorRoom")
    }
}

struct SystemOps: InstructionProtocol {
    
    static func execute() {
        debugPrint("SystemOps")
    }
}

struct Dummy: InstructionProtocol {
    
    static func execute() {
        debugPrint("Dummy")
    }
}

struct NotEqualZero: InstructionProtocol {
    
    static func execute() {
        debugPrint("NotEqualZero")
    }
}

struct SaveRestoreVerbs: InstructionProtocol {
    
    static func execute() {
        debugPrint("SaveRestoreVerbs")
    }
}

struct Expression: InstructionProtocol {
    
    static func execute() {
        debugPrint("Expression")
    }
}

struct Wait: InstructionProtocol {
    
    static func execute() {
        debugPrint("Wait")
    }
}

struct EndCutscene: InstructionProtocol {
    
    static func execute() {
        debugPrint("EndCutscene")
    }
}

struct Decrement: InstructionProtocol {
    
    static func execute() {
        debugPrint("Decrement")
    }
}

struct PseudoRoom: InstructionProtocol {
    
    static func execute() {
        debugPrint("PseudoRoom")
    }
}

struct PrintEgo: InstructionProtocol {
    
    static func execute() {
        debugPrint("PrintEgo")
    }
}

// MARK: - Opcodes V4

/*
struct DrawObject: OpcodeProtocol {
    
    static func execute() {
        debugPrint("DrawObject")
    }
}
*/

/*
struct PickupObject: OpcodeProtocol {
    
    static func execute() {
        debugPrint("PickupObject")
    }
}
*/

struct OldRoomEffect: InstructionProtocol {
    
    static func execute() {
        debugPrint("OldRoomEffect")
    }
}

struct IfState: InstructionProtocol {
    
    static func execute() {
        debugPrint("IfState")
    }
}

struct IfNotState: InstructionProtocol {
    
    static func execute() {
        debugPrint("IfNotState")
    }
}

struct SaveLoadVars: InstructionProtocol {
    
    static func execute() {
        debugPrint("SaveLoadVars")
    }
}

struct SaveLoadGame: InstructionProtocol {
    
    static func execute() {
        debugPrint("SaveLoadGame")
    }
}
*/
