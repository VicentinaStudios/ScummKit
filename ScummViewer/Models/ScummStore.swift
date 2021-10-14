//
//  ScummData.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 13.10.21.
//

import Foundation

class ScummStore: ObservableObject {
    
    @Published var scummFiles: [TreeNode<String>] = []
    
    init() {
        
        //#if DEBUG
        createDevData()
        //#endif
    }
    
    private func readDirectory(at url: URL) -> [URL]? {
        
        do {
            let urls = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
            
            let sorted = urls.sorted { a, b in
                a.lastPathComponent.localizedStandardCompare(b.lastPathComponent) == ComparisonResult.orderedAscending
            }
            
            return sorted
            
        } catch {
            debugPrint("Cannot read directory")
            return nil
        }
    }
}
