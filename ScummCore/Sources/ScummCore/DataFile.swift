//
//  DataFile.swift
//
//
//  Created by Michael Borgmann on 23/11/2023.
//

import Foundation

public enum ResourceType: String {
    
    case roomOffsets
    case script
    case unknown
    
    public init(rawValue: String) {
        
        switch rawValue {
        
        case "LOFF":
            self = .roomOffsets
        case "SCRP":
            self = .script
        default:
            self = .unknown
        }
    }
}

public protocol DataFile {
    
    /// The URL of the data file if found, otherwise `nil`.
    var dataFileURL: URL { get }
    
    /// List of the room offsets in a SCUMM data file.
    var roomOffsets: [RoomOffset] { get throws }
    
//    var scripts: [ScriptBlock]? { get }
    func readResource(resource: Resources.DirectoryEntry, type: ResourceType) throws -> ResourceProtocol
}

/// Represents a DataFileV5, responsible for reading SCUMM resource data files.
class DataFileV5: DataFile {
    
    /// The SCUMM file being read.
    private let scummFile: ScummFile
    
    /// The URL of the data file.
    var dataFileURL: URL
    
    /// List of the room offsets in a SCUMM data file.
    var roomOffsets: [RoomOffset] {
        get throws {
            try RoomOffset.readAll(from: scummFile).get()
        }
    }
    
    required init(at gameDirectoryURL: URL) throws {
        
        guard
            let directoryContent = FileUtils.directoryContent(in: gameDirectoryURL)
        else {
            throw ScummCoreError.emptyDirectory(gameDirectoryURL.path)
        }
        
        guard
            let matchedURL = directoryContent.filter({ $0.pathExtension == "001" }).first
        else {
            throw ScummCoreError.noDataFileFound(gameDirectoryURL.path)
        }
        
        dataFileURL = matchedURL
        scummFile = try ScummFile(fileURL: dataFileURL, encryptionKey: 0x69)
    }
    
    func readResource(resource: Resources.DirectoryEntry, type: ResourceType) throws -> ResourceProtocol {
        
        guard
            let offset = try? roomOffsets[resource.roomNumber - 1].offset + resource.offset
        else {
            throw ScummCoreError.cantLoadResource(type.rawValue, dataFileURL.lastPathComponent)
        }
        
        
        switch type {
            
        case .script:
            return try Script.load(from: scummFile, at: offset)
        default:
            throw ScummCoreError.cantLoadResource(type.rawValue, dataFileURL.lastPathComponent)
        }
        
        
    }
}
