//
//  CDHDView.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 10/07/2023.
//

import SwiftUI

struct CDHDView: View {
    
    @Binding var buffer: [UInt8]
    @State private var cdhd = CDHD.empty
    
    var body: some View {
        
        VStack {
            
            InputFieldView(
                title: "Object ID",
                placeholder: "value",
                value: $cdhd.objectID,
                titleWidth: Constants.keyLabelWidth
            ).padding()
            
            
            InputFieldView(
                title: "X",
                placeholder: "value",
                value: $cdhd.x,
                titleWidth: Constants.keyLabelWidth
            ).padding()
            
            InputFieldView(
                title: "Y",
                placeholder: "value",
                value: $cdhd.y,
                titleWidth: Constants.keyLabelWidth
            ).padding()
            
            InputFieldView(
                title: "Width",
                placeholder: "value",
                value: $cdhd.width,
                titleWidth: Constants.keyLabelWidth
            ).padding()
            
            InputFieldView(
                title: "Height",
                placeholder: "value",
                value: $cdhd.height,
                titleWidth: Constants.keyLabelWidth
            ).padding()
            
            InputFieldView(
                title: "Flags",
                placeholder: "value",
                value: $cdhd.flags,
                titleWidth: Constants.keyLabelWidth
            ).padding()
            
            InputFieldView(
                title: "Parent",
                placeholder: "value",
                value: $cdhd.parent,
                titleWidth: Constants.keyLabelWidth
            ).padding()
            
            InputFieldView(
                title: "Walk X",
                placeholder: "value",
                value: $cdhd.walkX,
                titleWidth: Constants.keyLabelWidth
            ).padding()
            
            InputFieldView(
                title: "Walk Y",
                placeholder: "value",
                value: $cdhd.walkY,
                titleWidth: Constants.keyLabelWidth
            ).padding()
            
            InputFieldView(
                title: "Actor Direction",
                placeholder: "value",
                value: $cdhd.actorDirection,
                titleWidth: Constants.keyLabelWidth
            ).padding()
            
        }.overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.secondary, lineWidth: 1)
        ).onAppear {
            cdhd = CDHD.create(from: $buffer.wrappedValue)
        }
    }
}

struct CDHDView_Previews: PreviewProvider {
    static var previews: some View {
        
        let block = Block(for: .CDHD, with: 21, at: 0xae61)
        let buffer = ScummStore.buffer(at: ScummStore.dataFileURL, for: block)
        
        CDHDView(buffer: .constant(buffer))
            .frame(width: 300, height: 400)
    }
}

extension CDHDView {
    
    struct Constants {
        static let keyLabelWidth: CGFloat = 127
    }
}
