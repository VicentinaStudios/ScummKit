//
//  MAXSView.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 20.10.21.
//

import SwiftUI

struct MAXSView: View {
    
    @Binding var buffer: [UInt8]
    @State private var maxs = MAXS.empty
    
    var body: some View {
        
        List {
            
//            if let maxs = maxs {
                
                Section(header: HStack {
                    Text("Variable").frame(width: Constants.variableNameLabelWidth, alignment: .trailing)
                    Text("Value (2 bytes)")
                }) {
                    ValueFieldView(name: "Variables", value: maxs.variables)
                    ValueFieldView(name: "Unknown", value: maxs.unknown)
                    ValueFieldView(name: "Bit Variables", value: maxs.bitVariables)
                    ValueFieldView(name: "Local Objects", value: maxs.localObjects)
                    ValueFieldView(name: "New Names", value: maxs.newNames)
                    ValueFieldView(name: "Character Sets", value: maxs.characterSets)
                    ValueFieldView(name: "Verbs", value: maxs.verbs)
                    ValueFieldView(name: "Array", value: maxs.array)
                    ValueFieldView(name: "Inventory Objects", value: maxs.inventoryObjects)
                }
//            }
        }.onAppear {
            maxs = MAXS.create(from: $buffer.wrappedValue)
        }
    }
}

struct MAXSView_Previews: PreviewProvider {
    static var previews: some View {
        
        let block = Block(for: .MAXS, with: 26, at: 0x35b)
        let buffer = ScummStore.buffer(at: ScummStore.indexFileURL, for: block)
        
        MAXSView(buffer: .constant(buffer))
    }
}

// MARK: - Enums & Constants

extension MAXSView {
    
    struct Constants {
        static let variableNameLabelWidth: CGFloat = 110
    }
}
