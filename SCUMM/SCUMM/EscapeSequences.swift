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
    
    init(for string: String) {
        self.string = string
    }
    
    var greenBold: String {
        Options.isAnsiEnabled ? "\u{1b}[32;1m\(string)\u{1b}[m" : string
    }
    
    var red: String {
        Options.isAnsiEnabled ? "\u{1b}[31m\(string)\u{1b}[m" : string
    }
    
    var redBold: String {
        Options.isAnsiEnabled ? "\u{1b}[31;1m\(string)\u{1b}[m" : string
    }
    
    var whiteBold: String {
        Options.isAnsiEnabled ? "\u{1b}[97;1m\(string)\u{1b}[m" : string
    }
    
    var magentaBold: String {
        Options.isAnsiEnabled ? "\u{1b}[35;1m\(string)\u{1b}[m" : string
    }
}
