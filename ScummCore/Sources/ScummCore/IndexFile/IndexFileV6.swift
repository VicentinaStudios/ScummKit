//
//  IndexFileV6.swift
//  
//
//  Created by Michael Borgmann on 18/09/2023.
//

import Foundation

class IndexFileV6: IndexFile {
    
    var indexFileURL: URL
    
    var roomNames: [RoomName]?
    
    var resources: Resources?
    
    required init(at gameDirectoryURL: URL) throws {
        
        guard let directoryContent = FileUtils.directoryContent(in: gameDirectoryURL)
        else {
            throw ScummCoreError.emptyDirectory(gameDirectoryURL.path)
        }
        
        guard let matchedURL = directoryContent.filter({ $0.pathExtension == "000" || $0.pathExtension == "SM0" }).first
        else {
            throw ScummCoreError.noIndexFileFound(gameDirectoryURL.path)
        }
        
        indexFileURL = matchedURL
        
        try readIndexFile(indexFileURL)
    }

    
    internal func readIndexFile(_ fileURL: URL) throws {
        
    }
}
