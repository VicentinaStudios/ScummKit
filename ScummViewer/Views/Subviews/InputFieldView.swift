//
//  InputFieldView.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 21.10.21.
//

import SwiftUI

struct InputFieldView: View {
    
    
    let title: String
    let placeholder: String
    @Binding var value: UInt16
    let titleWidth: CGFloat
    
    var body: some View {
        HStack {
            
            HStack {
                
                Spacer()
                Text("\(title):")
                
            }.frame(width: titleWidth)
            
            TextField("\(placeholder)", value: $value, formatter: NumberFormatter())
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 80)
        }
    }
}


struct InputFieldView_Previews: PreviewProvider {
    static var previews: some View {
        
        let value: UInt16 = 23
        
        InputFieldView(
            title: "Title",
            placeholder: "Placeholder",
            value: .constant(value),
            titleWidth: 200
        )
    }
}
