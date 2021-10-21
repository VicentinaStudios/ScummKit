//
//  DirectoryView.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 21.10.21.
//

import SwiftUI

struct DirectoryView: View {
    
    @Binding var buffer: [UInt8]
    
    var body: some View {
        //Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        Text(buffer.dwordLE.string)
    }
}

struct DirectoryView_Previews: PreviewProvider {
    static var previews: some View {
        
        let buffer = ScummStore.buffer(
            at: ScummStore.indexFileURL,
            for: ScummStore.block(),
            xor: 0x69
        )
        
        DirectoryView(buffer: .constant(buffer))
    }
}
