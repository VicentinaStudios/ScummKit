//
//  BottomBarView.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 21.10.21.
//

import SwiftUI

struct BottomBarView: View {
    
    @EnvironmentObject var scummStore: ScummStore
    
    var body: some View {
        HStack {
            
            if let version = scummStore.scummVersion {
                Text("SCUMM Version: \(String(describing: version))")
                    .padding(.horizontal)
            }
            
            if let xor = scummStore.scummVersion?.xor {
                Text("XOR Value: 0x\(xor.hex)")
                    .padding(.horizontal)
            }
        }
    }
}


struct BottomBarView_Previews: PreviewProvider {
    static var previews: some View {
        BottomBarView()
            .environmentObject(ScummStore.create)
            .previewLayout(.sizeThatFits)
    }
}
