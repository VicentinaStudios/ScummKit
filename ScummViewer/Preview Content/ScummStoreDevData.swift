//
//  ScummStoreDevData.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 13.10.21.
//

import Foundation

extension ScummStore {
    
    static var gamePath: String? {
        Bundle.main.infoDictionary?["SCUMM Game Path"] as? String
    }
    
    static var indexFile: String? {
        Bundle.main.infoDictionary?["Index File"] as? String
    }
    
    static var dataFile: String? {
        Bundle.main.infoDictionary?["Data File"] as? String
    }
  
    func createDevData() throws  {
        
        guard let path = ScummStore.gamePath else {
            return
        }
        
        let url = URL(fileURLWithPath: path, isDirectory: true)
        
        do {
            try readDirectory(at: url)
            
            let urls = scummFiles.map { $0.value.fileURL }
            scummVersion = ScummVersion.dectect(files: urls)
            
        } catch {
            throw error
        }
        
    }
}
