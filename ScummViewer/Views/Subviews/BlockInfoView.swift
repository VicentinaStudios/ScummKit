//
//  BlockInfoView.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 19.10.21.
//

import SwiftUI

struct BlockInfoView: View {
    
    @Binding var block: Block
    
    var body: some View {
        HStack {
            
            Spacer()
            
            Text("Block Type: \($block.name.wrappedValue)")
                .frame(alignment: .leading)
            
            Spacer()
            
            Text("Block Size: \($block.size.wrappedValue) bytes")
                .frame(alignment: .leading)
            
            Spacer()
            
            Text("Block Offset: 0x\($block.offset.wrappedValue.hex)")
                .frame(alignment: .leading)
            
            Spacer()
        }
    }
}

struct BlockInfoView_Previews: PreviewProvider {
    static var previews: some View {
        
        let block = Block(for: BlockType.ROOM.rawValue, with: 10, at: 20)
        
        BlockInfoView(block: .constant(block))
    }
}
