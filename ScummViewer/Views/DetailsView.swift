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
    @Binding var url: URL

    @State private var buffer: [UInt8] = []
    
    private let columns = [GridItem(.flexible())]
    
    var body: some View {
        
        VStack {
            
            Text("Room Names")
                .padding()
                .font(.system(.title2))
            
            BlockInfoView(block: $block)
            
            TabView {
                
                InspectView(buffer: $buffer)
                    .tabItem { Text("Inspect") }
                
                ScrollView(.vertical) {
                    HexEditorView(buffer: $buffer)
                }.tabItem { Text("Hex View") }
            }
            
        }.onAppear {
            buffer = try! blockData.byteBuffer.map { $0.xor(with: 0x69) }
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
        
        let scummStore = ScummStore.create
        let block = Block(for: "RNAM", with: 859, at: 0)
        let path = "\(ScummStore.gamePath!)/\(ScummStore.indexFile!)"
        let url = URL(fileURLWithPath: path, isDirectory: true)
        
        DetailsView(
            block: .constant(block),
            url: .constant(url)
        )
        .environmentObject(scummStore)
    }
}
