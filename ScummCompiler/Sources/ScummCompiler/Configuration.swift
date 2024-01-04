//
//  Configuration.swift
//  
//
//  Created by Michael Borgmann on 03/01/2024.
//

import Foundation

public struct Configuration {
    
    public enum Backend {
        case scumm
        case lox
    }
    
    public enum ParserType {
        case decent
        case pratt
    }
    
    public static var DEBUG_TRACE_EXECUTION = false
    public static var BACKEND = Backend.scumm
    public static var PARSER = ParserType.pratt
}
