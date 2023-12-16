//
//  File.swift
//  
//
//  Created by Michael Borgmann on 14/12/2023.
//

import Foundation

enum Opcode: UInt8, CaseIterable {
    
    case breakHere = 0x80
    
    var name: String {
        return "OP_" + String(describing: self).lowercased()
    }
}
