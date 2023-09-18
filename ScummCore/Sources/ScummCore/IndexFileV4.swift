//
//  File 2.swift
//  
//
//  Created by Michael Borgmann on 17/09/2023.
//

import Foundation

class IndexFileV4: IndexFile {
    
    var isIndexFile: (URL) -> Bool = { url in
        url.lastPathComponent == "000.LFL"
    }
    
    var indexFileURL: URL? = nil
        
    required init(at gameDirectoryURL: URL) throws {
        
        guard let directoryContent = FileUtils.directoryContent(in: gameDirectoryURL)
        else {
            throw ScummCoreError.emptyDirectory(gameDirectoryURL.path)
        }
        
        guard let matchedURL = directoryContent.filter({ isIndexFile($0) }).first
        else {
            throw ScummCoreError.noIndexFileFound(gameDirectoryURL.path)
        }
        
        indexFileURL = matchedURL
    }
    
    internal func readIndexFile(_ fileURL: URL) throws {
    }
}
