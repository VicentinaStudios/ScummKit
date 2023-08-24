//
//  RNView.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 23/08/2023.
//

import SwiftUI

struct RNView: View {
    
    @Binding var buffer: [UInt8]
    @State private var rn = RN.empty
    @State private var order: Order = .unsorted
    
    var body: some View {
        List {
            
            Section(
                header: Button { order = order.next }
                label: {
                    Text("#")
                        .frame(width: Constants.indexLabelWidth)
                    Text("Room")
                        .frame(width: Constants.numberOfRoomsLabelWidth)
                    Text("Name")
                    Spacer()
                    order.image
                }.font(.system(.headline)).buttonStyle(PlainButtonStyle())
            ) {
                
                let ordered = $rn.wrappedValue.rooms
                    .sorted {
                        switch order {
                        case .unsorted:
                            return false
                        case .down:
                            return $0.number < $1.number
                        case .up:
                            return $0.number > $1.number
                        }
                    }
                
                ForEach(ordered.indices, id: \.self) { index in
                    HStack {
                        
                        Text("\(index + 1)")
                            .frame(width: Constants.indexLabelWidth)
                            .foregroundColor(.secondary)
                        
                        Text("#\(ordered[index].number)")
                            .frame(width: Constants.numberOfRoomsLabelWidth)
                        
                        Text(ordered[index].name.string)
                    }
                }
            }
        }.onAppear {
            rn = RN.create(from: $buffer.wrappedValue)
        }
    }
}

struct RNView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        let block = Block(for: .RNAM, with: 859, at: 0)
        let buffer = ScummStore.buffer(at: ScummStore.indexFileURL, for: block)
        
        RNAMView(buffer: .constant(buffer))
    }
}


// MARK: - Enums & Constants

extension RNView {
    
    enum Order {
        case unsorted, down, up
        
        var image: Image {
            switch self {
            case .unsorted:
                return Image(systemName: "arrow.up.arrow.down")
            case .down:
                return Image(systemName: "arrow.down")
            case .up:
                return Image(systemName: "arrow.up")
            }
        }
        
        var next: Order {
            switch self {
            case .unsorted:
                return .down
            case .down:
                return .up
            case .up:
                return .unsorted
            }
        }
    }
    
    struct Constants {
        static let indexLabelWidth: CGFloat = 20
        static let numberOfRoomsLabelWidth: CGFloat = 40
    }
}
