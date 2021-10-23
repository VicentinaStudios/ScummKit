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
        
        let block = Block(for: .DROO, with: 510, at: 0x375)
        //let block = Block(for: .DSCR, with: 1005, at: 0x573)
        //let block = Block(for: .DSOU, with: 760, at: 0x960)
        //let block = Block(for: .DCOS, with: 760, at: 0xc58)
        //let block = Block(for: .DCHR, with: 45, at: 0xf50)
        
        let buffer = ScummStore.buffer(at: ScummStore.indexFileURL, for: block)
        
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
