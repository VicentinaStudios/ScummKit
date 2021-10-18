//
//  DetailsView.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 17.10.21.
//

import SwiftUI

struct DetailsView: View {
    
    @State var block: Block
    
    @State private var blockType: String = ""
    @State private var blockSize: String = ""
    @State private var blockOffset: String = ""
    
    var body: some View {

        HStack {
            
            Spacer()
            
            Text("Block Type: \(block.name)")
                .frame(alignment: .leading)
            
            Spacer()

            Text("Block Size: \(block.size) bytes")
                .frame(alignment: .leading)
            
            Spacer()
            
            Text("Block Offset: 0x\(block.offset.hex)")
                .frame(alignment: .leading)
            
            Spacer()
        }
    }
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        
        let block = Block(for: "ROOM", with: 10, at: 20)
        
        DetailsView(block: block)
    }
}
