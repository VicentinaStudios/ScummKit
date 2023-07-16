//
//  RMHDView.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 21.10.21.
//

import SwiftUI

struct RMHDView: View {
    
    @Binding var buffer: [UInt8]
    @State private var rmhd = RMHD.empty
    
    var body: some View {
        
        VStack {
            
            InputFieldView(
                title: "Width",
                placeholder: "value",
                value: $rmhd.width,
                titleWidth: Constants.keyLabelWidth
            ).padding()
            
            InputFieldView(
                title: "Height",
                placeholder: "value",
                value: $rmhd.height,
                titleWidth: Constants.keyLabelWidth
            ).padding(.horizontal)
            
            InputFieldView(
                title: "Number of Objects",
                placeholder: "value",
                value: $rmhd.numberOfObjects,
                titleWidth: Constants.keyLabelWidth
            ).padding()
            
        }.overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.secondary, lineWidth: 1)
        ).onAppear {
            rmhd = RMHD.create(from: $buffer.wrappedValue)
        }
    }
}

struct RMHDView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        let block = Block(for: .RMHD, with: 14, at: 0x1c5)
        let buffer = ScummStore.buffer(at: ScummStore.dataFileURL, for: block)
        
        RMHDView(buffer: .constant(buffer))
            .frame(width: 300, height: 200)
    }
}

extension RMHDView {
    
    struct Constants {
        static let keyLabelWidth: CGFloat = 127
    }
}
