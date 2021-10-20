//
//  HexEditorView.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 20.10.21.
//

import SwiftUI

struct HexEditorView: View {
    
    @Binding var buffer: [UInt8]
    
    let columns = [GridItem(.flexible())]
    
    var body: some View {
        
        let offsetsHeader = "Offsets "
        
        let hexHeader = (0...0xf).map {
            UInt8($0).hex
        }.joined(separator: " ")
        
        let byteHeader = (0...0xf).map {
            String(format: "%01hhx", $0)
        }.joined(separator: " ")
        
        let rows = Optional(buffer.count)
            .map { Double($0) / 16}
            .map { ceil($0)}
            .map { Int($0)}
        
        LazyVGrid(columns: columns, pinnedViews: .sectionHeaders) {
            
            Section(
                header: Text("\(offsetsHeader)   \(hexHeader)   \(byteHeader)")
                    .font(.system(.headline, design: .monospaced))
                    .padding()
                    .background(Color.gray)
                    .foregroundColor(.black)
            ) {
                
                ForEach(0..<rows!, id: \.self) { index in
                    
                    let start = index * 16
                    let end = start + 16
                    
                    let offs = UInt32(start).hex
                    
                    let hex = (start..<end).map {
                        $0 < buffer.count ? buffer[$0].hex : "  "
                    }.joined(separator: " ")
                                        
                    let chars = (start..<end).map {
                        $0 < buffer.count ? buffer[$0].printable : " "
                    }.joined(separator: " ")
                    
                    Text("\(offs)   \(hex)   \(chars)")
                        .font(.system(.headline, design: .monospaced))
                }
            }
        }.frame(width: 780)
    }
}

struct HexEditorView_Previews: PreviewProvider {
    static var previews: some View {
        
        let buffer = Data("This is a buffer...".utf8).byteBuffer
        
        HexEditorView(buffer: .constant(buffer))
    }
}
