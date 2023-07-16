//
//  ColorFieldView.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 05.11.21.
//

import SwiftUI

struct ColorFieldView: View {
    
    let index: UInt8
    let indexColor: CLUT.Color
    
    private var color: Color {
        Color(
            red: Double(indexColor.red) / 255,
            green: Double(indexColor.green) / 255,
            blue: Double(indexColor.blue) / 255
        )
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            Text("#\(index)")
                .font(.system(size: 8, design: .monospaced))
                .foregroundColor(.black)
                .background(Color.white)
                .frame(alignment: .topLeading)
            
            
            Spacer()
            
            ZStack {
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 40, height: 10)
                
                Text("#" +
                     "\(indexColor.red.hex)" +
                     "\(indexColor.green.hex)" +
                     "\(indexColor.blue.hex)"
                )
                    .foregroundColor(.black)
                    .font(.system(size: 8, design: .monospaced))
            }
        }
        .frame(width: 40, height: 40)
        .background(color)
        .overlay(RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.black, lineWidth: 1))
        .cornerRadius(5)
    }
}


struct ColorFieldView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        let indexColor = CLUT.Color(red: 10, green: 180, blue: 70)
        
        ColorFieldView(
            index: 5,
            indexColor: indexColor
        )
    }
}
