//
//  TRNSView.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 05.11.21.
//

import SwiftUI

struct TRNSView: View {
    
    @EnvironmentObject var scummStore: ScummStore
    @Binding var node: TreeNode<Block>
    @State private var trns = TRNS.empty
    @State private var clut = CLUT.empty
    
    private var paletteIndex: Int {
        Int(trns.paletteIndex)
    }
    
    private var tranparentColor: CLUT.Color? {
        
        guard !clut.isEmpty && !trns.isEmpty else {
            return nil
        }
        
        return CLUT.Color(
            red: clut.colors[paletteIndex].red,
            green: clut.colors[paletteIndex].green,
            blue: clut.colors[paletteIndex].blue
        )
    }
    
    var body: some View {
        
        VStack {
            
            if let tranparentColor = tranparentColor {
                
                ColorFieldView(
                    index: trns.paletteIndex,
                    indexColor: tranparentColor
                )
            } else {
                EmptyView()
            }
             
        }.onAppear {
            
            guard
                let clutNode = node.find(blockType: .CLUT)
            else {
                return
            }
            
            var buffer = try! clutNode.read(in: fileURL)
            clut = CLUT.create(from: buffer)
            
            buffer = try! node.read(in: fileURL)
            trns = TRNS.create(from: buffer)
        }
    }
}

// MARK: - Helper

extension TRNSView {
        
    var fileURL: URL? {
        
        let url = scummStore.scummFiles.first { file in
            file.value.fileURL.lastPathComponent == node.root.value.name
        }
        
        return url?.value.fileURL
    }
}

// MARK: - Preview

struct TRNSView_Previews: PreviewProvider {
    static var previews: some View {
        
        let scummStore = ScummStore.create
        let block = Block(for: .TRNS, with: 10, at: 0x131a2d)
        let node = (scummStore.scummFiles.last?.value.tree?.search(for: block))!
        
        TRNSView(node: .constant(node))
            .environmentObject(scummStore)
    }
}
