//
//  Opcode.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 13/07/2023.
//

import Foundation

struct Opcode {
    let offset: UInt16
    let opcode: UInt8
    let instruction: String?
    let command: String?
    let process: UInt8?
}
