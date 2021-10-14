//
//  ScummViewerApp.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 13.10.21.
//

import SwiftUI

@main
struct ScummViewerApp: App {
    
    @State private var url: URL? = nil
    
    var body: some Scene {
        
        WindowGroup {
            ContentView(url: $url)
                .frame(minWidth: 640, maxWidth: .infinity, minHeight: 480, maxHeight: .infinity, alignment: .center)
                .environmentObject(ScummStore())
        }.commands {
            FileMenuCommands(url: $url)
        }.onChange(of: url) { url in
            self.url = url
        }
    }
}
