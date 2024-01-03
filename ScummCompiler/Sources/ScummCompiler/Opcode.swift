//
//  File.swift
//  
//
//  Created by Michael Borgmann on 14/12/2023.
//

import Foundation

public enum Opcode: UInt8, CaseIterable {
    
    case breakHere  = 0x80
    
    case add        = 0xf0
    case subtract   = 0xf1
    case multiply   = 0xf2
    case divide     = 0xf3
    case `return`   = 0xf4
    case constant   = 0xf5
    case negate     = 0xf6
    
    var name: String {
        return "OP_" + String(describing: self).lowercased()
    }
}
