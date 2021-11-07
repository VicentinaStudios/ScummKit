//
//  NumberedListView.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 06.11.21.
//

import SwiftUI

struct NumberedListView: View {
    
    let values: [UInt32]
    
    var body: some View {
        
        List {
        
            Section(
                header: HStack {
                    
                    
                    Text("#")
                        .frame(width: Constants.indexLabelWidth, alignment: .trailing)
                    
                    VStack {
                        
                        Text("Stripe Offsets")
                        
                        Text("4 bytes")
                            .font(.system(size: 8))
                    }
                    
                }.font(.system(.headline)).buttonStyle(PlainButtonStyle())
            ) {
                
                ForEach(values.indices, id: \.self) { index in
                    HStack {
                        
                        Text("\(index + 1)")
                            .foregroundColor(.secondary)
                            .frame(width: Constants.indexLabelWidth, alignment: .trailing)
                        
                        Text("0x\(values[index].hex)")
                    }
                }
                
            }
        }
    }
}


struct NumberedListView_Previews: PreviewProvider {
    static var previews: some View {
        NumberedListView(values: [1, 2, 3, 4, 5, 5])
            .previewLayout(.sizeThatFits)
    }
}

// MARK: - Enums & Constants

extension NumberedListView {
    
    struct Constants {
        static let indexLabelWidth: CGFloat = 20
        static let roomsLabelWidth: CGFloat = 90
    }
}
