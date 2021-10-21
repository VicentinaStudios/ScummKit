//
//  DirectoryView.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 21.10.21.
//

import SwiftUI

struct DirectoryView: View {
    
    @Binding var buffer: [UInt8]
    @State private var directory: Directory? = nil
    
    var body: some View {
        List {
            
            Section(
                header: HStack {
                    
                    Text("#")
                        .frame(width: Constants.indexLabelWidth, alignment: .trailing)
                    
                    VStack {
                        
                        let itemNumberName = BlockType(rawValue: buffer.dwordLE.string)?.directory ?? "Unknown"

                        Text("\(itemNumberName) No.")
                            .frame(width: Constants.roomsLabelWidth)
                        
                        Text("1 byte")
                            .font(.system(size: 8))
                    }
                    
                    VStack {
                        
                        Text("Offset")
                        
                        Text("4 bytes")
                            .font(.system(size: 8))
                    }
                    
                }.font(.system(.headline)).buttonStyle(PlainButtonStyle())
            ) {
            
                if let directory = directory {
                    
                    ForEach(0..<directory.numberOfItems, id: \.self) { index in
                            
                        HStack {
                                
                            Text("\(index + 1)")
                                .foregroundColor(.secondary)
                                .frame(width: Constants.indexLabelWidth, alignment: .trailing)
                            
                            Text("\(directory.itemNumbers[Int(index)])")
                                .frame(width: Constants.roomsLabelWidth)
                            
                            Text("0x\(directory.offsets[Int(index)].hex)")
                        }
                    }
                }
            }
        }.onAppear {
            directory = Directory.create(from: $buffer.wrappedValue)
        }
    }
}

struct DirectoryView_Previews: PreviewProvider {
    static var previews: some View {
        
        let buffer = ScummStore.buffer(at: ScummStore.indexFileURL)
        
        DirectoryView(buffer: .constant(buffer))
    }
}

// MARK: - Enums & Constants

extension DirectoryView {
    
    struct Constants {
        static let indexLabelWidth: CGFloat = 30
        static let roomsLabelWidth: CGFloat = 90
    }
}
