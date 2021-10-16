//
//  ScummData.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 13.10.21.
//

import Foundation

enum FileError: Error {
    case loadFailure
    case saveFailure
    case urlFailure
}

class ScummStore: ObservableObject {
    
    @Published var scummFiles: [TreeNode<URL>] = []
    
    init() {}
        
    init(witchChecking: Bool) throws {
        
        #if DEBUG
        do {
            try createDevData()
        } catch {
            throw error
        }
        #endif
    }
    
    func readDirectory(at url: URL) throws {
        
        do {            
            let urls = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
            
            guard !urls.isEmpty else {
                throw FileError.urlFailure
            }
            
            let sorted = urls.sorted { a, b in
                a.lastPathComponent.localizedStandardCompare(b.lastPathComponent) == ComparisonResult.orderedAscending
            }
            
            scummFiles.removeAll()
            
            sorted.forEach { fileURL in
                let file = TreeNode<URL>(with: fileURL)
                scummFiles.append(file)
            }
        } catch {
            throw error
        }
    }
    
    static var create: ScummStore {
        do {
            return try ScummStore(witchChecking: true)
        } catch {
            return ScummStore()
        }
    }
}
