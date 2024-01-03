//
//  File.swift
//  
//
//  Created by Michael Borgmann on 03/01/2024.
//

import Foundation

public typealias Value = Int

public class ValueArray {
    
    private(set) var values: [Value]
    
    public var count: Int {
        values.count
    }
    
    public init() {
        values = []
    }
    
    public func write(value: Value) {
        values.append(value)
    }
}
