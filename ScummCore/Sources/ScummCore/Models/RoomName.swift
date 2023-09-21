//
//  RoomName.swift
//  
//
//  Created by Michael Borgmann on 21/09/2023.
//

import Foundation

/// Represents a room name in a SCUMM game.
///
/// A `RoomName` structure holds information about a room, including its `number` and `name`.
/// It is used to represent room names within the context of a SCUMM game.
public struct RoomName {
    
    /// The unique identifier or number of the room.
    public let number: Int
    
    /// The name or label associated with the room.
    public let name: String
}
