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
    
    @State private var isExpanded = true
        
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 16)
    
    var body: some View {
        
        List {
            
            Section(header: Text("General")) {
                HStack(spacing: 30) {
                    
                    Text("Number of Animations: \(cost.numberOfAnimations)")
                    
                    if isValidCostume {
                        
                        Text("Format: [\(isAnimationMirrored ? "X" : " ")] Mirror WEST Animations")
                        Text("Colors \(cost.colors.count)")
                        
                    } else {
                        Text("No valid costume.")
                    }
                }
            }

            Section(header: Text("Palette")) {
                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(cost.colors, id: \.self) { index in
                            
                            ColorFieldView(
                                index: UInt8(index),
                                indexColor: clut.colors[Int(index)]
                            )
                        }
                    }
                }
            }
            
            Section(header: Text("Commands")) {
                HStack(spacing: 30) {
                    
                    Text("Animation Commands Offset: 0x\(cost.animationComandsOffset.hex)")
                }
            }
            
            Section(header: Text("Limbs")) {
                
                List {
                    
                    Section(
                        header: HStack {
                            
                            Text("#")
                                .frame(width: Constants.indexLabelWidth, alignment: .trailing)
                            
                            VStack {
                                
                                Text("Offset")
                                
                                Text("2 bytes")
                                    .font(.system(size: 8))
                            }
                            
                        }.font(.system(.headline)).buttonStyle(PlainButtonStyle())
                    ) {
                        
                    ForEach(0..<cost.limbsOffsets.count, id: \.self) { index in
                                
                        HStack {
                                    
                            Text("\(index + 1)")
                                .foregroundColor(.secondary)
                                .frame(width: Constants.indexLabelWidth, alignment: .trailing)
                                
                            Text("0x\(cost.limbsOffsets[index].hex)")
                            }
                        }
                    }
                }.frame(height: CGFloat(cost.limbsOffsets.count + 1) * 25, alignment: .leading)
                    .disabled(true)
            }
            
            Section(header: Text("Animations")) {
                
                OutlineGroup(animationDefinitions, id: \.value, children: \.children) { tree in
                    Text(tree.value).font(.subheadline)
                }
            }
            
            Section(header: Text("Commands")) {
                
                List {
                    ForEach(cost.commands, id: \.self) { command in
                        Text("0x\(command.hex)")
                    }
                }.frame(height: CGFloat(cost.commands.count) * 25, alignment: .leading)
                    .disabled(true)
            }
            
            Section(header: Text("Pictures")) {
                
                HStack(spacing: 30) {
                    
                    let numberOfPictures = UInt8(COST.numberOfPictures(for: cost.commands))
                    
                    Text("Number of Pictures: \(numberOfPictures) [0x\(numberOfPictures.hex)]")
                }
                
                List {
                    ForEach(cost.limbs, id: \.self) { limb in
                        Text("0x\(limb.hex)")
                    }
                }.frame(height: CGFloat(cost.limbs.count) * 25, alignment: .leading)
                    .disabled(true)
            }
            
            Section(header: Text("Pictures II")) {
                
                Group {
                    
                    VStack{
                        
                        ForEach(0..<cost.images.count, id: \.self) { index in
                            
                            let image = cost.images[index]
                            
                            HStack {
                                Text("Width = \(image.width) : Height = \(image.height)")
                                Text("RelX = \(image.relX) : RelY = \(image.relY)")
                                Text("MoveX = \(image.moveX) : MoveY = \(image.moveY)")
                            }
                            
                            let texture = Texture(with: image, format: cost.format, clut: clut, colors: cost.colors)
                            if let cgImage = texture.bitmap.cgImage {
                                Image(decorative: cgImage, scale: 0.25).padding()
                            }
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

// MARK: - Helper

extension COSTView {
    
    var isValidCostume: Bool {
        (cost.format > 0x61 || cost.format < 0x57) ? false : true
    }
    
    var isAnimationMirrored: Bool {
        let format = cost.format & 0x7f
        return format & 0x80 == 0 ? true : false
    }
    
    var numberOfColors: UInt8 {
        cost.format & 0x1 == 0 ? 16 : 32
    }
    
    var animationDefinitions: [TreeNode<String>] {
        
        let tree = cost.animations.enumerated().map { index, animation -> TreeNode<String> in
            
            let offset = TreeNode(with: "Offset: 0x\(cost.animationOffsets[index].hex)")
            
            let limbMask = TreeNode(with: "Limb Mask: 0x\(animation.limbMask.hex)")
            let numberOfLimbs = TreeNode(with: "Number of Limbs: \(COST.numberOfLimbs(for: animation.limbMask))")
            
            offset.add(limbMask)
            offset.add(numberOfLimbs)
            
            animation.definition.enumerated().forEach { index, definition in
                
                let animation = TreeNode(with: "Animation \(index + 1)")
                
                let disabled = TreeNode(with: "Disabled: \(definition.index == 0xffff ? "True" : "False")")
                let length = TreeNode(with: "Length: \(definition.length & 0x7f)")
                let noLoop = TreeNode(with: "NoLoop: \((definition.length & 0x80) > 0 ? "True" : "False")")
                let start = TreeNode(with: "Start: \(definition.index)")
                let noLoopAndEndOffset = TreeNode(with: "NoLoopEndOffset: \(definition.length)")
                
                animation.add(disabled)
                animation.add(length)
                animation.add(noLoop)
                animation.add(start)
                animation.add(noLoopAndEndOffset)
                
                offset.add(animation)
            }
            
            return offset
        }
        
        return tree
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

// MARK: - Enums & Constants

extension COSTView {
    
    struct Constants {
        static let indexLabelWidth: CGFloat = 20
        static let cellLabelWidth: CGFloat = 90
    }
}
