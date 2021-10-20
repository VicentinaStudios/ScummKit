//
//  InspectView.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 20.10.21.
//

import SwiftUI

struct InspectView: View {
    
    @Binding var buffer: [UInt8]
    @State private var rnam: RNAM? = nil
    @State private var order: Order = .unsorted
    
    var body: some View {
        VStack {
            
            if buffer.isEmpty {
                
            } else {
                
                List {
                    
                    Section(
                        header: Button { order = order.next }
                        label: {
                            Text("No.")
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
    
                            ForEach(ordered, id: \.self) { room in
                                HStack {
                                    Text("#\(room.number)")
                                        .frame(width: Constants.numberOfRoomsLabelWidth)
                                    Text(room.name.map { $0.char }.joined())
                                }
                            }
                        }
                    }
                }
            }
        }.onAppear {
            rnam = RNAM.create(from: $buffer.wrappedValue)
        }
    }
}

struct InspectView_Previews: PreviewProvider {
    static var previews: some View {
        
        let block = Block(for: "RNAM", with: 859, at: 0)
        let path = "\(ScummStore.gamePath!)/\(ScummStore.indexFile!)"
        let url = URL(fileURLWithPath: path, isDirectory: true)
        let buffer = try! block.read(from: url).byteBuffer.map { $0.xor(with: 0x69) }
        
        InspectView(buffer: .constant(buffer))
    }
}

// MARK: - Enums & Constants

extension InspectView {
    
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
        static let numberOfRoomsLabelWidth: CGFloat = 30
    }
}
