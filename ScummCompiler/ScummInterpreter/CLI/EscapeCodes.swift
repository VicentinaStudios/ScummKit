//
//  EscapeCodes.swift
//  scumm
//
//  Created by Michael Borgmann on 17/07/2023.
//

import Foundation

struct EscapeSequence {
    
    private let string: String
    
    init(for string: String) {
        self.string = string
    }
    
    var greenBold: String {
        "\u{1b}[32;1m\(string)\u{1b}[m"
    }
    
    var red: String {
        "\u{1b}[31m\(string)\u{1b}[m"
    }
    
    var redBold: String {
        "\u{1b}[31;1m\(string)\u{1b}[m"
    }
    
    var whiteBold: String {
        "\u{1b}[97;1m\(string)\u{1b}[m"
    }
    
    var magentaBold: String {
        "\u{1b}[35;1m\(string)\u{1b}[m"
    }
}
