//
//  URL+Ext.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 17.10.21.
//

import Foundation

extension URL {
    
    var prefix: String {
        self.deletingPathExtension().lastPathComponent
    }
    
    var suffix: String {
        self.pathExtension
    }
}
