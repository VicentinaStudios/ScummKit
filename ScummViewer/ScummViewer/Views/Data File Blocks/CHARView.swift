//
//  CHARView.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 20/08/2023.
//

import SwiftUI

struct CHARView: View {
    
    @EnvironmentObject var scummStore: ScummStore
    @Binding var node: TreeNode<Block>
    @State private var char = CHAR.empty
    @State private var clut = CLUT.empty
    
    var body: some View {
        
        List {
            
            VStack {
                
                InputFieldView(
                    title: "Size (-23)",
                    placeholder: "value",
                    value: $char.size,
                    titleWidth: Constants.labelWidth
                ).padding()
                
                InputFieldView(
                    title: "Version",
                    placeholder: "value",
                    value: $char.version,
                    titleWidth: Constants.labelWidth
                ).padding()
                
                VStack {
                    
                    Text("Color Map")
                    
                    HStack {
                        
                        ForEach(char.colorMap, id: \.self) { colorIndex in
                            
                            ColorFieldView(
                                index: colorIndex,
                                indexColor: clut.colors[Int(colorIndex)]
                            )
                        }
                    }
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.secondary, lineWidth: 1)
                )
                
                InputFieldView(
                    title: "Bits per Pixel",
                    placeholder: "value",
                    value: $char.bitsPerPixel,
                    titleWidth: Constants.labelWidth
                ).padding()
                
                InputFieldView(
                    title: "Font Height",
                    placeholder: "value",
                    value: $char.fontHeight,
                    titleWidth: Constants.labelWidth
                ).padding()
                
                InputFieldView(
                    title: "Number of Characters",
                    placeholder: "value",
                    value: $char.numberOfCharacter,
                    titleWidth: Constants.labelWidth
                ).padding()
                
                Section(header: Text("Character Data Offsets")) {
                    
                    List {
                        
                        Section(
                            header: HStack {
                                
                                Text("#")
                                    .frame(width: Constants.indexNumber, alignment: .trailing)
                                
                                VStack {
                                    
                                    Text("Offset")
                                    
                                    Text("4 bytes")
                                        .font(.system(size: 8))
                                }
                                .frame(width: Constants.offsetWidth, alignment: .trailing)
                                
                                Text("Width")
                                    .frame(width: Constants.widthWidth, alignment: .trailing)
                                
                                Text("Height")
                                    .frame(width: Constants.heightLabel, alignment: .trailing)
                                
                                Text("Offset X")
                                    .frame(width: Constants.numericWidth, alignment: .trailing)
                                
                                Text("Offset Y")
                                    .frame(width: Constants.numericWidth, alignment: .trailing)
                                
                                Text("Glyp Data")
                                    .frame(width: Constants.glyphDataWidth, alignment: .trailing)
                                
                                Text("Glyp")
                                    .frame(width: Constants.indexNumber, alignment: .trailing)
                                
                            }.font(.system(.headline)).buttonStyle(PlainButtonStyle())
                        ) {
                            
                            ForEach(0..<char.characterDataOffsets.count, id: \.self) { index in
                                
                                HStack {
                                    
                                    Text("\(index + 1)")
                                        .foregroundColor(.secondary)
                                        .frame(width: Constants.indexNumber, alignment: .trailing)
                                    
                                    Text("0x\(char.characterDataOffsets[index].hex)")
                                        .frame(width: Constants.offsetWidth, alignment: .trailing)

                                    Text("\(char.characterGlyps[index].width)")
                                        .frame(width: Constants.widthWidth, alignment: .trailing)
                                    Text("\(char.characterGlyps[index].height)")
                                        .frame(width: Constants.heightLabel, alignment: .trailing)
                                    Text("\(char.characterGlyps[index].offsetX)")
                                        .frame(width: Constants.numericWidth, alignment: .trailing)
                                    Text("\(char.characterGlyps[index].offsetY)")
                                        .frame(width: Constants.numericWidth, alignment: .trailing)
                                    
                                    let glyphData = char.characterGlyps[index].bitstream
                                        .map { "\($0)" }
                                        .joined(separator: ",")
                                    
                                    Text("\(glyphData)")
                                        .frame(width: Constants.glyphDataWidth, alignment: .leading)
                                    
                                    if let glyph = Glyph(
                                        with: char.characterGlyps[index],
                                        bitsPerPixel: char.bitsPerPixel,
                                        colors: clut.colors,
                                        colorMap: char.colorMap
                                    ).bitmap?.cgImage {
                                        Image(decorative: glyph, scale: 0.25)
                                    }
                                }
                            }
                        }
                    }.frame(height: CGFloat(char.characterDataOffsets.count + 1) * 25, alignment: .leading)
                        .disabled(true)
                }
                
            }.onAppear() {
                
                guard
                    let roomNode = node.find(blockType: .ROOM, in: .LFLF),
                    let clutNode = roomNode.find(blockType: .CLUT)
                else {
                    return
                }
                
                var buffer = try! clutNode.read(in: fileURL)
                clut = CLUT.create(from: buffer)
                
                buffer = try! node.read(in: fileURL)
                char = CHAR.create(from: buffer)
            }
        }
    }
}

extension CHARView {
        
    var fileURL: URL? {
        
        let url = scummStore.scummFiles.first { file in
            file.value.fileURL.lastPathComponent == node.root.value.name
        }
        
        return url?.value.fileURL
    }
}

struct CHARView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        let scummStore = ScummStore.create
        let block = Block(for: .CHAR, with: 2601, at: 0x76be1)
        let node = (scummStore.scummFiles.last?.value.tree!.search(for: block))!
        
        CHARView(node: .constant(node))
            .frame(width: 300, height: 400)
    }
}

extension CHARView {
    
    struct Constants {
        
        static let labelWidth: CGFloat = 100
        
        static let indexNumber: CGFloat = 30
        static let offsetWidth: CGFloat = 90
        static let widthWidth: CGFloat = 45
        static let heightLabel: CGFloat = 45
        static let numericWidth: CGFloat = 55
        static let glyphDataWidth: CGFloat = 230
    }
}
