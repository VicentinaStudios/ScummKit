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
            BlockInfoView(block: $block)

            ScrollView(.vertical) {
                HexEditorView(buffer: $buffer)
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
        
        let block = Block(for: "ROOM", with: 20, at: 20)
        
        let path = "SCUMM.000"
        let url = URL(fileURLWithPath: path, isDirectory: true)
        
        DetailsView(
            block: .constant(block),
            url: .constant(url)
        )
        .environmentObject(ScummStore.create)
    }
}
