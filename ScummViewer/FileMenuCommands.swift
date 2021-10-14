//
//  CustomMenuCommands.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 13.10.21.
//

import SwiftUI

struct FileMenuCommands: Commands {
    
    @Binding var url: URL?
    
    var body: some Commands {
        
        CommandGroup(after: .newItem) {
            
            Button(action: {
                
                let panel = NSOpenPanel()
                
                panel.allowsMultipleSelection = false
                panel.canChooseDirectories = false
                
                if panel.runModal() == .OK {
                    url = panel.url
                }
            }, label: {
                Text("Open File…")
            })
            
            Button(action: {
                
                let panel = NSOpenPanel()
                
                panel.canChooseDirectories = true
                panel.canChooseFiles = false
                
                if panel.runModal() == .OK {
                    url = panel.url
                }
            }, label: {
                Text("Open Directory…")
            })
        }
    }
}
