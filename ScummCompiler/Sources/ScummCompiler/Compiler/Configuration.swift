//
//  Configuration.swift
//  
//
//  Created by Michael Borgmann on 03/01/2024.
//

import Foundation

public struct Configuration {
    
    public enum Backend: String {
        case scumm
        case mojo
    }
    
    public enum ParserType: String {
        case decent
        case pratt
    }
    
    public enum Runtime: String {
        case ast
        case interpreter
        case mojo
        case scumm
        case decompiler
    }
    
    public static var DEBUG_TRACE_EXECUTION = false
    public static var BACKEND = Backend.scumm
    public static var PARSER = ParserType.decent
}
