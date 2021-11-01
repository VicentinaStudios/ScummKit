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
                    let cgImage = image.bitmap?.cgImage
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
            let clutNode = find(blockType: .CLUT),
            let rmhdNode = find(blockType: .RMHD)
        else {
            return
        }
        
        var buffer = try! read(block: clutNode.value)
        clut = CLUT.create(from: buffer)
        
        buffer = try! read(block: rmhdNode.value)
        rmhd = RMHD.create(from: buffer)
        
        buffer = try! read(block: node.value)
        smap = SMAP.create(from: buffer, imageWidth: rmhd.width)
    }
}

// MARK: - Queries

extension SMAPView {
    
    private func read(block: Block) throws -> [UInt8] {
        
        do {
            let buffer = try blockData(for: block).byteBuffer.xor(
                with: scummStore.scummVersion?.xor ?? 0
            )
            
            return buffer
            
        } catch {
            throw FileError.loadFailure
        }
    }
    
    var fileURL: URL? {
        
        let url = scummStore.scummFiles.first { file in
            file.value.fileURL.lastPathComponent == node.root.value.name
        }
        
        return url?.value.fileURL
    }
    
    func findParent(of type: BlockType) -> TreeNode<Block> {
        
        var parent = node
        
        while parent.value.name != BlockType.ROOM.rawValue {
            if let grandParent = parent.parent {
                parent = grandParent
            }
        }
        
        return parent
    }
    
    func find(blockType: BlockType) -> TreeNode<Block>? {
        
        let parent = findParent(of: .ROOM)
        
        let block = parent.children?.first { block in
            block.value.name == blockType.rawValue
        }
        
        return block
    }
    
    func blockData(for block: Block) throws -> Data {
            
        guard let url = fileURL else {
            throw FileError.urlFailure
        }
        
        do {
            
            return try readData(
                from: url,
                at: UInt64(block.offset),
                with: Int(block.size)
            )
            
        } catch {
            throw FileError.loadFailure
        }
    }
    
    var blockData: Data {
        
        get throws {
            
            guard let url = fileURL else {
                throw FileError.urlFailure
            }
            
            do {
                
                return try readData(
                    from: url,
                    at: UInt64(node.value.offset),
                    with: Int(node.value.size)
                )
                
            } catch {
                throw FileError.loadFailure
            }
        }
    }
    
    private func readData(from file: URL, at offset: UInt64, with length: Int) throws -> Data {
        
        do {
            
            let fileHandle = try FileHandle(forReadingFrom: file)
            fileHandle.seek(toFileOffset: offset)
            let data = fileHandle.readData(ofLength: length)
            
            fileHandle.closeFile()
            
            return data
            
        } catch {
            throw FileError.loadFailure
        }
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
