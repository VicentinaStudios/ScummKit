//
//  COSTView.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 09.11.21.
//

import SwiftUI

struct COSTView: View {
    
    @EnvironmentObject var scummStore: ScummStore
    @Binding var node: TreeNode<Block>
    //@Binding var buffer: [UInt8]
    @State private var cost = COST.empty
    @State private var clut = CLUT.empty
    
    var body: some View {
        
        List {
            
            Group {
            
                Text("Number of Animations: \(cost.numberOfAnimations)")
                Text("Format: 0x\(cost.format.hex)")
                
                let decode = cost.format & 0x7f
                
                Text("- Colors: 0x\(decode.hex) (0x58 = 16 colors, 0x59 = 32 colors)")
                Text("- Alignement: \(cost.format & 0x80) (0x0=normal alignement, 0x80 different alignment)")
                
                ForEach(0..<cost.colors.count, id: \.self) { index in
                    Text("Color #\(index): \(cost.colors[index])")
                }
            }
            
            Group {
            
                Text("Animation Commands Offset: 0x\(cost.animationComandsOffset.hex)")
                
                ForEach(0..<cost.limbsOffsets.count, id: \.self) { index in
                    Text("Limb Offset #\(index): 0x\(cost.limbsOffsets[index].hex)")
                }
                
                ForEach(0..<cost.animationOffsets.count, id: \.self) { index in
                    Text("Animation Offsets #\(index): 0x\(cost.animationOffsets[index].hex)")
                }
            }
            
            Group {
                
                VStack(alignment: .leading) {
                    ForEach(0..<cost.animations.count) { index in
                        
                        let limbMask = cost.animations[index].limbMask
                        let activeLimbs = COST.numberOfLimbs(for: limbMask)
                        
                        Text(
                            "Animation Offset[0x\(cost.animationOffsets[index].hex)]" +
                            " - Limb Mask [0b\(limbMask.binary)]" +
                            " - Active Limbs: \(activeLimbs)"
                        )
                        
                        VStack(alignment: .leading) {
                            ForEach(0..<cost.animations[index].definition.count) { idx in
                                
                                HStack {
                                
                                    let start = cost.animations[index].definition[idx].index
                                    
                                    if start == 0xffff {
                                        Text("- Limb#\(idx) DISABLE")
                                    } else {
                                        Text("- Limb#\(idx) Start: 0x\(start.hex)")
                                    }
                                    
                                    if let end = cost.animations[index].definition[idx].length {
                                        let masked = end & 0b1111111
                                        Text("- End: 0x\(masked.hex)")
                                        
                                        let isLooping = end & 0b10000000
                                        Text("- Loop: \(isLooping)")
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            Group {
                VStack {
                    Text("Commands: ")
                    ForEach(0..<cost.commands.count, id: \.self) { index in
                        Text("#\(index) 0x\(cost.commands[index].hex)")
                    }
                }.frame(width: 700)
            }
            
            ForEach(0..<cost.limbs.count, id: \.self) { index in
                Text("#\(index) Limb (picture offset): 0x\(cost.limbs[index].hex)")
            }
            
            Group {
                
                VStack{
                    
                    ForEach(0..<cost.images.count, id: \.self) { index in
                        
                        let image = cost.images[index]
                        
                        HStack {
                            Text("Width = \(image.width) : Height = \(image.height)")
                            Text("RelX = \(image.relX) : RelY = \(image.relY)")
                            Text("MoveX = \(image.moveX) : MoveY = \(image.moveY)")
                        }
                        
                        let texture = Texture(with: image, format: cost.format, palette: clut)
                        if let cgImage = texture.bitmap.cgImage {
                            Image(decorative: cgImage, scale: 0.25).padding()
                        }
                    }
                }
                
            }
            
        }.overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.secondary, lineWidth: 1)
        ).onAppear {
            
            guard let clutNode = clutNode else {
                return
            }
            
            var buffer = try! clutNode.read(in: fileURL)
            clut = CLUT.create(from: buffer)
            
            buffer = try! node.read(in: fileURL)
            cost = COST.create(from: buffer)
        }
    }
}

// MARK: - Queries

extension COSTView {
        
    var fileURL: URL? {
        
        let url = scummStore.scummFiles.first { file in
            file.value.fileURL.lastPathComponent == node.root.value.name
        }
        
        return url?.value.fileURL
    }
    
    var clutNode: TreeNode<Block>? {
        node.parent?.children?
            .first { $0.value.name == BlockType.ROOM.rawValue }?
            .children?
            .first { $0.value.name == BlockType.CLUT.rawValue }
            
    }
}

struct COSTView_Previews: PreviewProvider {
    static var previews: some View {
        
        let scummStore = ScummStore.create
        let block = Block(for: .COST, with: 382, at: 0x17fe3)
        //let buffer = ScummStore.buffer(at: ScummStore.dataFileURL, for: block)
        let node = (scummStore.scummFiles.last?.value.tree?.search(for: block))!
        
        COSTView(node: .constant(node))
            .environmentObject(scummStore)
    }
}
