//
//  ContentView.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 13.10.21.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var scummStore: ScummStore
    
    var body: some View {
        
        VStack {
            
            NavigatorView()
            
            BottomBarView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        ContentView()
            .environmentObject(ScummStore.create)
    }
}
