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
        
        NavigationView {
        
            List {
                
                ForEach(scummStore.scummFiles, id: \.self) { file in
                    
                    Section(header: Text(file.value.fileURL.lastPathComponent)) {
                        
                        OutlineGroup(
                            file.value.tree?.children ?? [],
                            id: \.value,
                            children: \.children
                        ) { node in
                            
                            NavigationLink(
                                destination: DetailsView(
                                    block: .constant(node.value),
                                    node: .constant(node),
                                    url: .constant(file.value.fileURL)
                                )
                            ) {
                                Text(node.value.name).font(.subheadline)
                            }
                        }
                    }
                }
                
            }.listStyle(SidebarListStyle())
        }
    }
}

struct NavigatorView_Previews: PreviewProvider {
    static var previews: some View {
        NavigatorView()
            .environmentObject(ScummStore.create)
            .previewLayout(.sizeThatFits)
    }
}
