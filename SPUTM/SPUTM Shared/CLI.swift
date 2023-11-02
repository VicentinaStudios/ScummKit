//
//  CLI.swift
//  SPUTM
//
//  Created by Michael Borgmann on 28/08/2023.
//

import Foundation

class CLI {
    
    let args = CommandLine.arguments.dropFirst()
    
    var shouldShowVersion: Bool {
        
        let search = /--version/
        
        for arg in args {
            if let _ = try? search.wholeMatch(in: arg) {
                return true
            }
        }
        
        return false
    }

    var shouldShowHelp: Bool {
        
        let search = /--help/
        
        for arg in args {
            if let _ = try? search.wholeMatch(in: arg) {
                return true
            }
        }
        
        return false
    }
    
    var extractTargetVersion: Int? {
        
        let search = /-v(\d+)/
        
        for arg in args {
            if let match = try? search.wholeMatch(in: arg) {
                return Int(match.1)
            }
        }
        
        return nil
    }
    
    var extractFilenames: String? {
        
        let optionWithParameter = /-[d]|--(directory)/
        let optionWithoutParamter = /-.*|--.*/
        
        var isDirectory = false
        
        for arg in args {
            
            if isDirectory {
                return arg
            } else if let _ = try? optionWithParameter.wholeMatch(in: arg) {
                isDirectory = true
            }
        }
        
        return nil
    }
}
