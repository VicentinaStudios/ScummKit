//
//  SOUNView.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 22/08/2023.
//

import SwiftUI

struct SOUNView: View {
    
    @EnvironmentObject var scummStore: ScummStore
    @Binding var buffer: [UInt8]
    @State private var soun = SOUN.empty
    @State private var midi: [UInt8] = []
    
    var body: some View {
        
        VStack {
            
            HStack {
                
                InputFieldView(
                    title: "Block Name",
                    placeholder: "value",
                    value: $soun.blockName2,
                    titleWidth: Constants.labelWidth,
                    type: .string
                )
                
                InputFieldView(
                    title: "Block Size",
                    placeholder: "value",
                    value: $soun.blockSize2,
                    titleWidth: Constants.labelWidth,
                    type: .decimal
                )
            }
            
            ForEach($soun.music, id: \.blockName) { block in
                
                HStack {
                    
                    InputFieldView(
                        title: "Music Block Name",
                        placeholder: "value",
                        value: block.blockName,
                        titleWidth: Constants.labelWidth,
                        type: .string
                    )
                    
                    InputFieldView(
                        title: "Music Block Size",
                        placeholder: "value",
                        value: block.blockSize,
                        titleWidth: Constants.labelWidth,
                        type: .decimal
                    )
                    
                    Button(action: { export(data: block.midi.wrappedValue) }) {
                        Text("Exort")
                    }
                }
            }
            
            VStack {
                
                Text("MIDI Conversion")
                    .padding()
                
                ScrollView {
                    HexEditorView(buffer: $midi)
                }
                .frame(height: 300)
            }
            
        }.onAppear {
            if let version = try? scummStore.scummVersion, version == .v4 {
                soun = SOUN.create_v4(from: $buffer.wrappedValue)
                debugPrint(soun.blockName2)
            } else {
                soun = SOUN.create(from: $buffer.wrappedValue)
            }
            
            midi = MIDI(with: buffer).midi
        }
    }
    
    private func export(data: [UInt8]) {
        
        let data = Data(midi.dropFirst(24))
        
        let path = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Desktop")
        let fileURL = path.appendingPathComponent("music.mid")
        
        do {
            try data.write(to: fileURL)
        } catch {
            print("Error exporting MIDI: \(error.localizedDescription)")
        }
    }
}

struct SOUNView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        let block = Block(for: .SOUN, with: 5170, at: 0x687ab)
        let buffer = ScummStore.buffer(at: ScummStore.dataFileURL, for: block)
        
        SOUNView(buffer: .constant(buffer))
    }
}

extension SOUNView {
    struct Constants {
        static let labelWidth: CGFloat = 127
    }
}
