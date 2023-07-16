//
//  CLUTView.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 23.10.21.
//

import SwiftUI

struct CLUTView: View {
    
    @Binding var buffer: [UInt8]
    @State private var clut = CLUT.empty
    
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 16)
    
    var body: some View {
        
        ScrollView {
            LazyVGrid(columns: columns) {
                
                ForEach(clut.colors.indices, id: \.self) { index in
                    
                    ColorFieldView(
                        index: UInt8(index),
                        indexColor: clut.colors[index]
                    )
                }
            }.onAppear {
                clut = CLUT.create(from: $buffer.wrappedValue)
            }
        }.padding(.horizontal)
    }
}

struct CLUTView_Previews: PreviewProvider {
    static var previews: some View {
        
        let block = Block(for: .CLUT, with: 776, at: 0x3b5)
        let buffer = ScummStore.buffer(at: ScummStore.dataFileURL, for: block)
        
        CLUTView(buffer: .constant(buffer))
    }
}
