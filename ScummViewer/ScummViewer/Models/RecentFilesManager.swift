//
//  RecentFilesManager.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 23/08/2023.
//

import SwiftUI

class RecentFilesManager: ObservableObject {

    @AppStorage("recentFiles") private var recentFilesData: Data = Data()
    
    var recentFiles: [URL] {
        get {
            do {
                return try JSONDecoder().decode([URL].self, from: recentFilesData)
            } catch {
                return []
            }
        }
        set {
            
            let limitedList = newValue.count > 5 ? newValue.dropLast() : newValue
            
            if let encoded = try? JSONEncoder().encode(limitedList) {
                recentFilesData = encoded
            }
        }
    }

    /// Update the recent files list
    /// - Parameter files: Update list of recent `URL`s
    func updateRecentFiles(_ files: [URL]) {
        recentFiles = files
    }
}
