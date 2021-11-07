//
//  SMAPView.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 23.10.21.
//

import SwiftUI

struct SMAPView: View {
    
    @EnvironmentObject var scummStore: ScummStore
    @Binding var node: TreeNode<Block>
    @State private var smap = SMAP.empty
    @State private var clut = CLUT.empty
    @State private var trns = TRNS.empty
    @State private var rmhd = RMHD.empty
    @State private var image: ScummImage? = nil
    
    var body: some View {
        
        HStack {
            
            NumberedListView(values: smap.stripeOffsets)
                .frame(width: 160)
            
            VStack {
                
                HStack {
                    
                    Text("Width: \(rmhd.width)")
                    Text("Height: \(rmhd.height)")
                    Text("Stripes: \(smap.stripes.count)")
                }
                
                if
                    let image = image,
                    let cgImage = image.bitmap.cgImage
                {
                    
                    VStack {
                        Image(decorative: cgImage, scale: 0.5).padding()
                            .frame(width: CGFloat(rmhd.width))
                        
                        Button("Export Image") {
                            try! cgImage.pngData?.savePng()
                        }
                    }.frame(width: CGFloat(rmhd.width))
                        .padding()
                }
            }.frame(minWidth: 320 * 2, minHeight: 500)
                .padding()
            
        }.onAppear {
            loadData()
            
            image = ScummImage(from: smap, info: rmhd, palette: clut)
        }
    }
    
    private func loadData() {
        
        guard
            let trnsNode = node.find(blockType: .TRNS),
            let clutNode = node.find(blockType: .CLUT),
            let rmhdNode = node.find(blockType: .RMHD)
        else {
            return
        }
        
        var buffer = try! trnsNode.read(in: fileURL)
        trns = TRNS.create(from: buffer)
        
        buffer = try! clutNode.read(in: fileURL)
        clut = CLUT.create(from: buffer)
        
        buffer = try! rmhdNode.read(in: fileURL)
        rmhd = RMHD.create(from: buffer)
        
        buffer = try! node.read(in: fileURL)
        smap = SMAP.create(from: buffer, imageWidth: rmhd.width)
    }
}

// MARK: - Queries

extension SMAPView {
        
    var fileURL: URL? {
        
        let url = scummStore.scummFiles.first { file in
            file.value.fileURL.lastPathComponent == node.root.value.name
        }
        
        return url?.value.fileURL
    }
}

// MARK: - Preview

struct SMAPView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        let scummStore = ScummStore.create
        let block = Block(for: .SMAP, with: 34314, at: 0x18a9f)
        let node = (scummStore.scummFiles.last?.value.tree?.search(for: block))!
        
        SMAPView(node: .constant(node))
            .environmentObject(scummStore)
    }
}
