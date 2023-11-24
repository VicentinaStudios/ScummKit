//
//  File.swift
//  
//
//  Created by Michael Borgmann on 24/11/2023.
//

import Foundation

public protocol ResourceProtocol {
    
    static func load(from file: ScummFile, at offset: Int) throws -> ResourceProtocol
}
