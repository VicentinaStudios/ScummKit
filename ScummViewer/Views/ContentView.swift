//
//  ContentView.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 13.10.21.
//

import SwiftUI

struct Tree<Value: Hashable>: Hashable {
    let value: Value
    var children: [Tree]? = nil
}

struct ContentView: View {
    
    @Binding var url: URL?
    @EnvironmentObject var data: ScummStore
    
    var body: some View {
        
        List {
            
            ForEach(data.scummFiles, id: \.self) { filename in
                
                Section(header: Text(filename.value)) {
                    
                    OutlineGroup(
                        filename.children ?? [],
                        id: \.value,
                        children: \.children
                    ) { tree in
                        Text(tree.value).font(.subheadline)
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        ContentView(url: .constant(nil))
            .environmentObject(ScummStore())
    }
}
