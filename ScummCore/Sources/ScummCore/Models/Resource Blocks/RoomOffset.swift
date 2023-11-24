//
//  RoomOffset.swift
//
//
//  Created by Michael Borgmann on 23/11/2023.
//

import Foundation

/// Represents the offset and room number for a room entry in the game's data.
public struct RoomOffset: Codable {
    
    /// The unique identifier or room number associated with the directory entry.
    public let roomNumber: Int
    
    /// The offset or position of the resource within the game's data.
    public let offset: Int
    
    /// Reads all room offsets from the provided `ScummFile`.
    ///
    /// - Parameter dataFile: The `ScummFile` containing the room offset data.
    /// - Returns: An array of `RoomOffset` instances.
    /// - Throws: A `ScummCoreError` if there is an issue reading the room offsets.
    public static func readAll(from dataFile: ScummFile) throws -> Result<[RoomOffset], ScummCoreError> {
        
        let header = try ResourceHeader(from: dataFile, offset: 8)
        
        guard header.resourceType == .roomOffsets else {
            throw ScummCoreError.missingResource("Room Offset Table", "data file")
        }
                
        do {
            
            let numberOfRooms = try dataFile.consumeUInt8
            
            let roomOffsets = try (0..<numberOfRooms).map { _ in
                try createRoomOffset(from: dataFile)
            }
            
            return .success(roomOffsets)
            
        } catch let scummCoreError as ScummCoreError {
            return .failure(scummCoreError)
        } catch {
            return .failure(.unknownBlock(header.resourceType.rawValue))
        }
    }
    
    /// Creates a `RoomOffset` instance by reading information from the given `ScummFile`.
    ///
    /// - Parameter dataFile: The `ScummFile` to read room offset information from.
    /// - Returns: A `RoomOffset` instance.
    /// - Throws: A `ScummCoreError` if there is an issue creating the room offset.
    internal static func createRoomOffset(from dataFile: ScummFile) throws -> RoomOffset {
        RoomOffset(
            roomNumber: Int(try dataFile.consumeUInt8),
            offset: Int(try dataFile.consumeUInt32)
        )
    }
}
