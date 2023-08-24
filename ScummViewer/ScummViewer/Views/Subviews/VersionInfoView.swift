//
//  VersionInfoView.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 23/08/2023.
//

import SwiftUI

struct VersionInfoView: View {
    
    @Binding var version: ScummVersion

    var body: some View {
        HStack {
            Text("SCUMM Version: \(String(describing: version))")
                .padding(.horizontal)
            
            if let xor = version.xor {
                Text("XOR Value: 0x\(xor.hex)")
                    .padding(.horizontal)
            }
        }
    }
}

struct VersionInfoView_Previews: PreviewProvider {
    static var previews: some View {
        VersionInfoView(version: .constant(.v4))
            .previewLayout(.sizeThatFits)
    }
}
