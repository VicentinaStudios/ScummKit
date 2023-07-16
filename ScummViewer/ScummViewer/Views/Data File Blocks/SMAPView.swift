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
    @State private var imhd = IMHD.empty
    @State private var image: ScummImage? = nil
    @State private var width: UInt16 = 320
    @State private var height: UInt16 = 500
    
    var body: some View {
        
        HStack {
            
            NumberedListView(values: smap.stripeOffsets)
                .frame(width: 160)
            
            VStack {
                
                HStack {
                    
                    Text("Width: \(width)")
                    Text("Height: \(height)")
                    Text("Stripes: \(smap.stripes.count)")
                }
                
                if
                    let image = image,
                    let cgImage = image.bitmap.cgImage
                {
                    
                    VStack {
                        Image(decorative: cgImage, scale: 0.5).padding()
                            .frame(width: CGFloat(width))
                        
                        Button("Export") {
                            try! cgImage.pngData?.savePng()
                        }
                    }.frame(width: CGFloat(width))
                        .padding()
                }
            }.frame(minWidth: 320 * 2, minHeight: 500)
                .padding()
            
        }.onAppear {
            
            loadColorData()
            
            if isRoom {
                
                loadRoomData()
                
                width = rmhd.width
                height = rmhd.height
                
            } else if isObject {
                
                loadObjectData()

                width = imhd.width
                height = imhd.height
            }
            
            image = ScummImage(
                from: smap,
                palette: clut,
                width: width,
                height: height
            )
        }
    }
}

extension SMAPView {
    
    private var isRoom: Bool {
        
        guard let value = node.parent?.parent?.value else {
            return false
        }
        
        return BlockType(rawValue: value.name) == .RMIM ? true : false
    }
    
    private var isObject: Bool {
        guard let value = node.parent?.parent?.value else {
            return false
        }
        
        return BlockType(rawValue: value.name) == .OBIM ? true : false
    }
    
    private func loadColorData() {
        
        guard
            let trnsNode = node.find(blockType: .TRNS),
            let clutNode = node.find(blockType: .CLUT)
        else {
            return
        }
        
        var buffer = try! trnsNode.read(in: fileURL)
        trns = TRNS.create(from: buffer)
        
        buffer = try! clutNode.read(in: fileURL)
        clut = CLUT.create(from: buffer)
    }
    
    private func loadRoomData() {
        
        guard
            let rmhdNode = node.find(blockType: .RMHD)
        else {
            return
        }
        
        var buffer = try! rmhdNode.read(in: fileURL)
        rmhd = RMHD.create(from: buffer)
        
        buffer = try! node.read(in: fileURL)
        smap = SMAP.create(from: buffer, imageWidth: rmhd.width)
    }
    
    private func loadObjectData() {
        
        guard
            let trnsNode = node.find(blockType: .TRNS),
            let clutNode = node.find(blockType: .CLUT),
            let imhdNode = node.find(blockType: .IMHD, in: .OBIM)
        else {
            return
        }
        
        var buffer = try! trnsNode.read(in: fileURL)
        trns = TRNS.create(from: buffer)
        
        buffer = try! clutNode.read(in: fileURL)
        clut = CLUT.create(from: buffer)
        
        buffer = try! imhdNode.read(in: fileURL)
        imhd = IMHD.create(from: buffer)
        
        buffer = try! node.read(in: fileURL)
        smap = SMAP.create(from: buffer, imageWidth: imhd.width)
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
