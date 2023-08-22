//
//  InputFieldView.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 21.10.21.
//

import SwiftUI

class HexFormatter: Formatter, ObservableObject {
    @Published var hexValue: Int = 0
    
    override func string(for obj: Any?) -> String? {
        if let value = obj as? Int {
            return String(format: "0x%X", value)
        }
        return nil
    }
    
    override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?,
                        for string: String,
                        errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        if let intValue = Int(string, radix: 16) {
            obj?.pointee = NSNumber(value: intValue)
            return true
        }
        return false
    }
}

class StringFormatter: Formatter, ObservableObject {
    @Published var hexValue: Int = 0
    
    override func string(for obj: Any?) -> String? {
        if let value = obj as? UInt32 {
            return String("\(value.bigEndian.string)")
        }
        return nil
    }
    
    override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?,
                        for string: String,
                        errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        if let intValue = Int(string, radix: 16) {
            obj?.pointee = NSNumber(value: intValue)
            return true
        }
        return false
    }
}

struct InputFieldView<T>: View where T: BinaryInteger {
    
    enum FieldType {
        case decimal
        case hexadecimal
        case string
        
        var formatter: Formatter {
            switch self {
            case .decimal:
                return NumberFormatter()
            case .hexadecimal:
                return HexFormatter()
            case .string:
                return StringFormatter()
            }
        }
    }
    
    let title: String
    let placeholder: String
    @Binding var value: T
    let titleWidth: CGFloat
    let type: FieldType?
    
    @State private var showHex = false
    
    var body: some View {
        HStack {
            
            HStack {
                
                Spacer()
                Text("\(title):")
                
            }.frame(width: titleWidth)
            
            TextField(
                "\(placeholder)",
                value: $value,
                formatter: type?.formatter ?? NumberFormatter()
            )
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .frame(width: 80)
            
            /*
            Toggle("Dec|Hex", isOn: $showHex)
                .toggleStyle(.switch)
            */
        }
    }
}


struct InputFieldView_Previews: PreviewProvider {
    static var previews: some View {
        
        let value: UInt16 = 23
        
        InputFieldView(
            title: "Title",
            placeholder: "Placeholder",
            value: .constant(value),
            titleWidth: 200,
            type: .decimal
        )
    }
}
