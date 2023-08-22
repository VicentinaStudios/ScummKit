//
//  DetailsView.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 17.10.21.
//

import Foundation
import SwiftUI

struct DetailsView: View {
    
    @EnvironmentObject var scummStore: ScummStore
    
    @Binding var block: Block
    @Binding var node: TreeNode<Block>
    @Binding var url: URL

    @State private var buffer: [UInt8] = []
    @State private var title: String = ""
    
    private let columns = [GridItem(.flexible())]
    
    var body: some View {
        
        VStack {
            
            Text(title)
                .padding()
                .font(.system(.title2))
            
            BlockInfoView(block: $block)
            
            TabView {
                
                switch BlockType(rawValue: block.name) {
                
                case
                    .RNAM, .MAXS, .DROO, .DSCR, .DSOU, .DCOS, .DCHR, .DOBJ,
                    .LOFF, .RMHD, .CLUT, .SMAP, .TRNS, .IMHD,
                    .COST, .CDHD, .CHAR, .SOUN:
                        //.ZP01, .ZP02, .ZP03:
                    
                    InspectView(buffer: $buffer, node: $node)
                        .tabItem { Text("Inspect") }
                    
                default:
                    EmptyView()
                }
                
                ScrollView(.vertical) {
                    HexEditorView(buffer: $buffer)
                }.tabItem { Text("Hex View") }
            }
            
        }.onAppear {
            
            buffer = try! blockData.byteBuffer.xor(
                with: scummStore.scummVersion?.xor ?? 0
            )

            title = BlockType.init(rawValue: node.value.name)?.title ?? "Unkown"
        }
    }
}

extension DetailsView {

    var blockData: Data {
        get throws {
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

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        
        let node = TreeNode<Block>(with: ScummStore.block())
        
        DetailsView(
            block: .constant(ScummStore.block()),
            node: .constant(node),
            url: .constant(ScummStore.indexFileURL)
        ).environmentObject(ScummStore.create)
    }
}
