//
//  NavigatorView.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 16.10.21.
//

import SwiftUI

struct NavigatorView: View {
    
    @EnvironmentObject var scummStore: ScummStore
    
    var body: some View {
        List {
            ForEach(scummStore.scummFiles, id: \.self) { fileURL in
                Section(header: Text(fileURL.value.lastPathComponent)) {
                    
                    OutlineGroup(
                        fileURL.children ?? [],
                        id: \.value,
                        children: \.children
                    ) { node in
                        Text(node.value.absoluteString).font(.subheadline)
                    }
                }
            }
        }
    }
}

struct NavigatorView_Previews: PreviewProvider {
    static var previews: some View {
        NavigatorView()
            .environmentObject(ScummStore.create)
    }
}
