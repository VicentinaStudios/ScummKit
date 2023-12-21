//
//  Compiler.swift
//
//
//  Created by Michael Borgmann on 21/12/2023.
//

import Foundation

class Compiler {
    
    func compile(source: String) {
        
        let scanner = Scanner(source: source)
        
        let line = -1
        
        while true {
            
            let token = try? scanner.scanToken()
        }
    }
}
