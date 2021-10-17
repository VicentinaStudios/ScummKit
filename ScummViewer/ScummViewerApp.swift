//
//  ScummViewerApp.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 13.10.21.
//

import SwiftUI

@main
struct ScummViewerApp: App {
    
    @StateObject private var scummStore:  ScummStore
    @State private var showAlert = false
    
    init() {
        _scummStore = StateObject(wrappedValue: ScummStore())
    }
    
    var body: some Scene {
        
        WindowGroup {
            ContentView()
                .frame(minWidth: 640, maxWidth: .infinity, minHeight: 480, maxHeight: .infinity, alignment: .center)
                .environmentObject(scummStore)
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Error"),
                        message: Text("Couldn't load SCUMM game data.")
                    )
                }
        }.commands {
            CommandGroup(after: .newItem) {
                Button(action: openGame) {
                    Text("Open Game…")
                }
            }
        }
    }
    
    private func openGame() {
        
        let panel = NSOpenPanel()
        
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        
        if panel.runModal() == .OK {
            
            guard let url = panel.url else {
                return
            }
            
            do {
                try scummStore.readDirectory(at: url)
                scummStore.scummVersion = ScummVersion.dectect(files: scummStore.scummFiles.map { $0.value} )
            } catch {
                showAlert = true
            }
                
        }
    }
}
