//
//  ScummStoreDevData.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 13.10.21.
//

import Foundation

extension ScummStore {
  
    func createDevData() throws  {
        
        let path = "/PATH/OF/SCUMM/GAME"
        let url = URL(fileURLWithPath: path, isDirectory: true)
        
        do {
            try readDirectory(at: url)
        } catch {
            throw error
        }
    }
}
