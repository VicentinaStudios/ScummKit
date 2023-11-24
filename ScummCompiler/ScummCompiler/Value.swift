//
//  Value.swift
//  ScummCompiler
//
//  Created by Michael Borgmann on 24/11/2023.
//

import Foundation

typealias Value = Double

struct ValueArray {
    var values: [Value] = []
    
    mutating func write(value: Value) {
        values.append(value)
    }
}
