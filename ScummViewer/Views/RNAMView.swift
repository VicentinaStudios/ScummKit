//
//  RNAMView.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 20.10.21.
//

import SwiftUI

struct RNAMView: View {
    
    @Binding var buffer: [UInt8]
    @State private var rnam: RNAM? = nil
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
                
                if let rooms = $rnam.wrappedValue?.rooms {
                    
                    let ordered = rooms
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
            }
        }.onAppear {
            rnam = RNAM.create(from: $buffer.wrappedValue)
        }
    }
}

struct RNAMView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        let buffer = ScummStore.buffer(
            at: ScummStore.indexFileURL,
            for: ScummStore.block(name: BlockType.RNAM, with: 859, at: 0),
            xor: 0x69
        )
        
        RNAMView(buffer: .constant(buffer))
    }
}


// MARK: - Enums & Constants

extension RNAMView {
    
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
