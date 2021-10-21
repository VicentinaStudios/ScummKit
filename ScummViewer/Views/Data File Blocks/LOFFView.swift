//
//  LOFFView.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 21.10.21.
//

import SwiftUI

struct LOFFView: View {
    
    @Binding var buffer: [UInt8]
    @State private var loff: LOFF? = nil
    
    var body: some View {
        
        List {
            
            Section(
                header: HStack {
                    
                    Text("#")
                        .frame(width: Constants.indexLabelWidth, alignment: .trailing)
                    
                    VStack {

                        Text("Room ID")
                            .frame(width: Constants.offsetLabelWidth)
                        
                        Text("1 byte")
                            .font(.system(size: 8))
                    }
                    
                    VStack {
                        
                        Text("Offset ROOM Block")
                        
                        Text("4 bytes")
                            .font(.system(size: 8))
                    }
                    
                }.font(.system(.headline)).buttonStyle(PlainButtonStyle())
            ) {
                
                if let loff = loff {
                    
                    ForEach(0..<loff.numberOfRooms, id: \.self) { index in
                        
                        HStack {
                            
                            Text("\(index + 1)")
                                .foregroundColor(.secondary)
                                .frame(width: Constants.indexLabelWidth, alignment: .trailing)
                            
                            Text("\(loff.rooms[Int(index)].roomId)")
                                .frame(width: Constants.offsetLabelWidth)
                            
                            Text("0x\(loff.rooms[Int(index)].offset.hex)")
                        }
                    }
                }
            }
        }.onAppear {
            loff = LOFF.create(from: $buffer.wrappedValue)
        }
    }
}

struct LOFFView_Previews: PreviewProvider {
    static var previews: some View {
        
        let buffer = ScummStore.buffer(
            at: ScummStore.dataFileURL,
            for: ScummStore.block(),
            xor: 0x69
        )
        
        LOFFView(buffer: .constant(buffer))
    }
}

extension LOFFView {
    
    struct Constants {
        static let indexLabelWidth: CGFloat = 30
        static let offsetLabelWidth: CGFloat = 90
    }
}
