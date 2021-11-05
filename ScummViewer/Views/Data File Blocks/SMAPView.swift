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
            
            List {
                
                Section(
                    header: HStack {
                        
                        
                        Text("#")
                            .frame(width: Constants.indexLabelWidth, alignment: .trailing)
                    
                        VStack {
                            
                            Text("Stripe Offsets")
                            
                            Text("4 bytes")
                                .font(.system(size: 8))
                        }
                        
                    }.font(.system(.headline)).buttonStyle(PlainButtonStyle())
                ) {
                    
                    ForEach(smap.stripeOffsets.indices, id: \.self) { index in
                        HStack {
                            
                            Text("\(index + 1)")
                                .foregroundColor(.secondary)
                                .frame(width: Constants.indexLabelWidth, alignment: .trailing)
                            
                            Text("0x\(smap.stripeOffsets[index].hex)")
                        }
                    }
                
                }
            }.frame(width: 160)
            
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
                    
                    Image(decorative: cgImage, scale: 1).padding()
                    
                    Button("Export") {
                        try! cgImage.pngData?.savePng()
                    }
                }
            }
            
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
        let block = Block(for: .SMAP, with: 22206, at: 0x6ff)
        let node = (scummStore.scummFiles.last?.value.tree?.search(for: block))!
        
        SMAPView(node: .constant(node))
            .environmentObject(scummStore)
    }
}

// MARK: - Enums & Constants

extension SMAPView {
    
    struct Constants {
        static let indexLabelWidth: CGFloat = 20
        static let roomsLabelWidth: CGFloat = 90
    }
}
