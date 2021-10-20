//
//  InspectView.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 20.10.21.
//

import SwiftUI

struct InspectView: View {
    
    @Binding var buffer: [UInt8]
    @State var blockName: String = ""
    
    var body: some View {
        VStack {
            
            if !buffer.isEmpty {
                
                switch blockName {
                case "RNAM":
                    RNAMView(buffer: $buffer)
                case "MAXS":
                    MAXSView(buffer: $buffer)
                default:
                    Text("Cannot inspect block")
                }
            }
        }.onAppear {
            blockName = buffer.dwordLE.char.joined()
        }
    }
}

struct InspectView_Previews: PreviewProvider {
    static var previews: some View {
        
        let block = Block(for: "RNAM", with: 859, at: 0)
        let path = "\(ScummStore.gamePath!)/\(ScummStore.indexFile!)"
        let url = URL(fileURLWithPath: path, isDirectory: true)
        let buffer = try! block.read(from: url).byteBuffer.map { $0.xor(with: 0x69) }
        
        InspectView(buffer: .constant(buffer))
    }
}
