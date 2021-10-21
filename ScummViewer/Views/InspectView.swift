//
//  InspectView.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 20.10.21.
//

import SwiftUI

struct InspectView: View {
    
    @Binding var buffer: [UInt8]
    @State var blockName: String = ""
    
    var body: some View {
        VStack {
            
            if !buffer.isEmpty {
                
                switch BlockType(rawValue: blockName) {
                case .RNAM:
                    RNAMView(buffer: $buffer)
                case .MAXS:
                    MAXSView(buffer: $buffer)
                case .DROO, .DSCR, .DSOU, .DCOS, .DCHR:
                    DirectoryView(buffer: $buffer)
                case .DOBJ:
                    DirectoryOfObjectView(buffer: $buffer)
                case .LOFF:
                    LOFFView(buffer: $buffer)
                case .RMHD:
                    RMHDView(buffer: $buffer)
                default:
                    Text("Cannot inspect block")
                }
            }
        }.onAppear {
            blockName = buffer.dwordLE.string
        }
    }
}

struct InspectView_Previews: PreviewProvider {
    static var previews: some View {
        
        let buffer = ScummStore.buffer(at: ScummStore.indexFileURL)
        
        InspectView(buffer: .constant(buffer))
    }
}
