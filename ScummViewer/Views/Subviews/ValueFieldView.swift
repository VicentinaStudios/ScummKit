//
//  ValueFieldView.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 21.10.21.
//

import SwiftUI


struct ValueFieldView: View {
    
    var keyLabelWidth: CGFloat = 110
    let name: String
    let value: UInt16
    
    var body: some View {
        
        HStack {
            Text(name).frame(width: keyLabelWidth, alignment: .trailing)
            Text("\(value)")
        }
    }
}

struct ValueFieldView_Previews: PreviewProvider {
    static var previews: some View {
        ValueFieldView(name: "NAME", value: 0xff)
            .previewLayout(.sizeThatFits)
    }
}
