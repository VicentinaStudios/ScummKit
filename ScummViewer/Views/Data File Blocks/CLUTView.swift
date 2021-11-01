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
                    
                    let color = Color(
                        red: Double(clut.colors[index].red) / 255,
                        green: Double(clut.colors[index].green) / 255,
                        blue: Double(clut.colors[index].blue) / 255
                    )
                    
                    VStack(alignment: .leading) {
                        
                        Text("\(index)")
                            .font(.system(size: 8, design: .monospaced))
                            .foregroundColor(.black)
                            .background(Color.white)
                            .frame(alignment: .topLeading)
                            
                        
                        Spacer()
                        
                        ZStack {
                            Rectangle()
                                .fill(Color.white)
                            .frame(width: 40, height: 10)

                            Text("#" +
                                 "\(clut.colors[index].red.hex)" +
                                 "\(clut.colors[index].green.hex)" +
                                 "\(clut.colors[index].blue.hex)"
                            )
                                .foregroundColor(.black)
                                .font(.system(size: 8, design: .monospaced))
                        }
                        
                    }
                    .frame(width: 40, height: 40)
                    .background(color)
                    .overlay(RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.black, lineWidth: 1))
                    .cornerRadius(5)
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
