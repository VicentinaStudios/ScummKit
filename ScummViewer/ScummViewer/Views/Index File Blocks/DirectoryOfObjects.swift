//
//  DirectoryOfObjects.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 21.10.21.
//

import SwiftUI

//
//  DirectoryView.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 21.10.21.
//

import SwiftUI

struct DirectoryOfObjectView: View {
    
    @Binding var buffer: [UInt8]
    @State private var directory = Directory.empty
    
    var body: some View {
        List {
            
            Section(
                header: HStack {
                    
                    Text("#")
                        .frame(width: Constants.indexLabelWidth, alignment: .trailing)
                    
                    VStack {
                        
                        Text("Owner")
                            .frame(width: Constants.ownerStateLabelWidth)
                        
                        Text("4 bits")
                            .font(.system(size: 8))
                    }
                    
                    VStack {
                        
                        Text("State")
                            .frame(width: Constants.ownerStateLabelWidth)
                        
                        Text("4 bits")
                            .font(.system(size: 8))
                    }
                    
                    VStack {
                        
                        Text("Class Data")
                        
                        Text("4 bytes")
                            .font(.system(size: 8))
                    }
                        
                    
                }.font(.system(.headline)).buttonStyle(PlainButtonStyle())
            ) {
            
//                if let directory = directory {
                    
                    ForEach(0..<directory.numberOfItems, id: \.self) { index in
                            
                        HStack {
                                
                            Text("\(index + 1)")
                                .foregroundColor(.secondary)
                                .frame(width: Constants.indexLabelWidth, alignment: .trailing)
                            
                            let value = directory.itemNumbers[Int(index)]
                            let owner = (value & 0xf0) >> 4
                            let state = value & 0xf
                            
                            Text("\(owner)")
                                .frame(width: Constants.ownerStateLabelWidth)
                            
                            Text("\(state)")
                                .frame(width: Constants.ownerStateLabelWidth)
                            
                            let classData = directory.offsets[Int(index)].hex
                            Text("0x\(classData)")
                        }
                    }
//                }
            }
        }.onAppear {
            directory = Directory.create(from: $buffer.wrappedValue)
        }
    }
}

struct DirectoryOfObjectView_Previews: PreviewProvider {
    static var previews: some View {
        
        let block = Block(for: .DOBJ, with: 5960, at: 0xf50)
        let buffer = ScummStore.buffer(at: ScummStore.indexFileURL, for: block)
        
        DirectoryOfObjectView(buffer: .constant(buffer))
    }
}

// MARK: - Enums & Constants

extension DirectoryOfObjectView {
    
    struct Constants {
        static let indexLabelWidth: CGFloat = 40
        static let ownerStateLabelWidth: CGFloat = 50
    }
}
