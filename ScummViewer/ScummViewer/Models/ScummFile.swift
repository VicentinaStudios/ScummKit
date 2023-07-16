//
//  ScummFile.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 18.10.21.
//

import Foundation

struct ScummFile: Hashable {
    
    enum FileType {
        case indexFile
        case dataFile
    }
    
    let fileURL: URL
    let tree: TreeNode<Block>?
    let type: FileType?
}
