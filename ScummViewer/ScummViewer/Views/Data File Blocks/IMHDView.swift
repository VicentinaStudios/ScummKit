//
//  IMHDView.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 07.11.21.
//

import SwiftUI

struct IMHDView: View {
    
    @Binding var buffer: [UInt8]
    @State private var imhd = IMHD.empty
    
    var body: some View {
        VStack {
            
            InputFieldView(
                title: "Object ID",
                placeholder: "value",
                value: $imhd.objectID,
                titleWidth: Constants.keyLabelWidth
            ).padding()
            
            InputFieldView(
                title: "Number of Images",
                placeholder: "value",
                value: $imhd.numberOfIMNN,
                titleWidth: Constants.keyLabelWidth
            ).padding(.horizontal)
            
            InputFieldView(
                title: "Number of Z-Planes",
                placeholder: "value",
                value: $imhd.numberOfZPNN,
                titleWidth: Constants.keyLabelWidth
            ).padding()
            
            /*
            InputFieldView(
                title: "Flags",
                placeholder: "value",
                value: $imhd.flags,
                titleWidth: Constants.keyLabelWidth
            ).padding()
             
            InputFieldView(
                title: "Unknown",
                placeholder: "value",
                value: $imhd.unknown,
                titleWidth: Constants.keyLabelWidth
            ).padding()
            */
            
            InputFieldView(
                title: "X",
                placeholder: "value",
                value: $imhd.x,
                titleWidth: Constants.keyLabelWidth
            ).padding()
            
            InputFieldView(
                title: "Y",
                placeholder: "value",
                value: $imhd.y,
                titleWidth: Constants.keyLabelWidth
            ).padding()
            
            InputFieldView(
                title: "Width",
                placeholder: "value",
                value: $imhd.width,
                titleWidth: Constants.keyLabelWidth
            ).padding()
            
            InputFieldView(
                title: "Height",
                placeholder: "value",
                value: $imhd.height,
                titleWidth: Constants.keyLabelWidth
            ).padding()
            
        }.overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.secondary, lineWidth: 1)
        ).onAppear {
            imhd = IMHD.create(from: $buffer.wrappedValue)
        }
    }
}

struct IMHDView_Previews: PreviewProvider {
    static var previews: some View {
        
        let block = Block(for: .IMHD, with: 24, at: 0x5fb5)
        let buffer = ScummStore.buffer(at: ScummStore.dataFileURL, for: block)
        
        IMHDView(buffer: .constant(buffer))
            .frame(width: 300, height: 200)
    }
}

extension IMHDView {
    
    struct Constants {
        static let keyLabelWidth: CGFloat = 127
    }
}
