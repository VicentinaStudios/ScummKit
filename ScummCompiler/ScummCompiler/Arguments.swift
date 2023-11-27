//
//  Arguments.swift
//  ScummCompiler
//
//  Created by Michael Borgmann on 27/11/2023.
//

import Foundation

class Arguments {
    
    // MARK: Properties
    
    private let args: [String]?
    
    // MARK: Lifecycles
    
    init(args: [String]?) {
        self.args = args
    }
}

// MARK: - Arguments

extension Arguments {
    
    var isEmpty: Bool {
        args?.isEmpty ?? true
    }

    var shouldShowVersion: Bool {
        
        guard let args = args else {
            return false
        }
        
        let search = /--version/
        
        for arg in args {
            if let _ = try? search.wholeMatch(in: arg) {
                return true
            }
        }
        
        return false
    }

    var shouldShowHelp: Bool {
        
        guard let args = args else {
            return false
        }
        
        let search = /--help/
        
        for arg in args {
            if let _ = try? search.wholeMatch(in: arg) {
                return true
            }
        }
        
        return false
    }

    var extractTargetVersion: Int? {
        
        guard let args = args else {
            return nil
        }
        
        let search = /-v(\d+)/
        
        for arg in args {
            if let match = try? search.wholeMatch(in: arg) {
                return Int(match.1)
            }
        }
        
        return nil
    }

    var extractFilenames: [String]? {
        
        guard let args = args else {
            return nil
        }
        
        let optionWithParameter = /-[o]|--(output)/
        let optionWithoutParamter = /-.*|--.*/
        
        var filenames: [String]?
        var skipArgument = false
        
        for arg in args {
            
            if skipArgument {
                skipArgument = false
                continue
            } else if let _ = try? optionWithParameter.wholeMatch(in: arg) {
                skipArgument = true
                continue
            } else if let _ = try? optionWithoutParamter.wholeMatch(in: arg) {
                continue
            } else {
                if filenames?.append(arg) == nil {
                    filenames = [arg]
                }
            }
        }
        
        return filenames
    }
}
