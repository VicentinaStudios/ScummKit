//
//  SCRPView.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 10/07/2023.
//

import SwiftUI

struct SCRPView: View {
    
    @Binding var buffer: [UInt8]
    @State private var scrp = SCRP.empty {
        didSet {
            bytecode = scrp.code.map { $0.hex }.joined()
        }
    }
    
    @State var bytecode = ""
    
    @StateObject var vm = VirtualMachine()
    
    @State private var value: String? = nil
    
    var body: some View {
        
        VStack {
            
            Text("Byte Code")
            
            if let opcodes = vm.opcodes {
                
                List {
                    
                    Section(
                        header: HStack {
                            
                            Text("#")
                                .frame(width: Constants.indexLabelWidth, alignment: .trailing)
                            
                            Text("Offset")
                                .frame(width: Constants.offsetLabelWidth)
                            
                            Text("Opcode")
                                .frame(width: Constants.opcodeLabelWidth)

                            Text("Instruction")
                                .frame(width: Constants.instructionLabelWidth)
                            
                            Text("Command")
                        }
                    ) {
                        
                        ForEach(Array(opcodes.enumerated()), id: \.offset) { index, opcode in
                            
                            HStack {
                                
                                Text("\(index + 1)")
                                    .frame(width: Constants.indexLabelWidth,
                                           alignment: .trailing)
                                
                                Text("0x\(opcode.offset.hex)")
                                    .frame(width: Constants.offsetLabelWidth)
                                Text("0x\(opcode.opcode.hex)")
                                    .frame(width: Constants.opcodeLabelWidth)
                                
                                Text("\(opcode.instruction ?? "-")")
                                    .frame(width: Constants.instructionLabelWidth)
                                
                                Text("\(opcode.command ?? "unkown")")
                            }
                        }
                        
                    }
                
                }
             
                Button("Export") {
                    exportBytecode()
                }
            } else {
                Text("No bytecode loaded")
            }
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .onAppear {
            scrp = SCRP.create(from: $buffer.wrappedValue)
            
            vm.loadBytecode(with: scrp.code)
            vm.decompile()
            
            self.value = "Loaded Value"
        }
    }
    
    func exportBytecode() {
        
        let data = Data(buffer)
        
        let path = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Desktop")

        let fileURL = path.appendingPathComponent("bytecode.scumm")

        do {
            try data.write(to: fileURL)
        } catch {
            print("Error saving text: \(error.localizedDescription)")
        }
    }
}

struct SCRPView_Previews: PreviewProvider {
    static var previews: some View {
        
        let block = Block(for: .CDHD, with: 5416, at: 0x65a14)
        let buffer = ScummStore.buffer(at: ScummStore.dataFileURL, for: block)
        
        SCRPView(buffer: .constant(buffer))
    }
}

// MARK: - Enums & Constants

extension SCRPView {
    
    struct Constants {
        static let indexLabelWidth: CGFloat = 40
        static let offsetLabelWidth: CGFloat = 70
        static let opcodeLabelWidth: CGFloat = 50
        static let instructionLabelWidth: CGFloat = 120
    }
}
