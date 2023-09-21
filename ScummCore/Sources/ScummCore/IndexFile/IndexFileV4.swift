//
//  File 2.swift
//  
//
//  Created by Michael Borgmann on 17/09/2023.
//

import Foundation

class IndexFileV4: IndexFile {
    
    var indexFileURL: URL
        
    required init(at gameDirectoryURL: URL) throws {
        
        guard let directoryContent = FileUtils.directoryContent(in: gameDirectoryURL)
        else {
            throw ScummCoreError.emptyDirectory(gameDirectoryURL.path)
        }
        
        guard let matchedURL = directoryContent.filter({ $0.lastPathComponent == "000.LFL" }).first
        else {
            throw ScummCoreError.noIndexFileFound(gameDirectoryURL.path)
        }
        
        indexFileURL = matchedURL
        
        try readIndexFile(indexFileURL)
    }
    
    internal func readIndexFile(_ fileURL: URL) throws {
        
    }
}
