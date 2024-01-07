//
//  EscapeSequences.swift
//  SCUMM
//
//  Created by Michael Borgmann on 05/01/2024.
//

import Foundation

extension String {
    var escape: EscapeSequence {
        EscapeSequence(for : self)
    }
}

struct EscapeSequence {
    
    private let string: String
    private let options: CompilerOptions
    
    init(for string: String) {
        self.string = string
        self.options = CompilerOptions()
    }
    
    var greenBold: String {
        options.isAnsiEnabled ? "\u{1b}[32;1m\(string)\u{1b}[m" : string
    }
    
    var red: String {
        options.isAnsiEnabled ? "\u{1b}[31m\(string)\u{1b}[m" : string
    }
    
    var redBold: String {
        options.isAnsiEnabled ? "\u{1b}[31;1m\(string)\u{1b}[m" : string
    }
    
    var whiteBold: String {
        options.isAnsiEnabled ? "\u{1b}[97;1m\(string)\u{1b}[m" : string
    }

    var magenta: String {
        options.isAnsiEnabled ? "\u{1b}[35m\(string)\u{1b}[m" : string
    }
    
    var magentaBold: String {
        options.isAnsiEnabled ? "\u{1b}[35;1m\(string)\u{1b}[m" : string
    }
    
    var yellow: String {
        options.isAnsiEnabled ? "\u{1b}[33m\(string)\u{1b}[m" : string
    }
    
    var yellowBold: String {
        options.isAnsiEnabled ? "\u{1b}[33;1m\(string)\u{1b}[m" : string
    }
}
