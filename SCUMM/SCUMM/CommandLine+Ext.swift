//
//  CommandLineArguments.swift
//  SCUMM
//
//  Created by Michael Borgmann on 05/01/2024.
//

import Foundation

extension CommandLine {
    
    static var isEmpty: Bool {
        CommandLine.arguments.count == 1
    }
    
    static var shouldShowVersion: Bool {
        
        guard CommandLine.arguments.count > 0 else {
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
    
    static var shouldDisableANSI: Bool {
        
        guard CommandLine.arguments.count > 0 else {
            return false
        }
        
        let search = /--noansi/
        
        for arg in args {
            if let _ = try? search.wholeMatch(in: arg) {
                return true
            }
        }
        
        return false
    }
    
    static var shouldEnableDebug: Bool {
        
        guard CommandLine.arguments.count > 0 else {
            return false
        }
        
        let search = /--debug/
        
        for arg in args {
            if let _ = try? search.wholeMatch(in: arg) {
                return true
            }
        }
        
        return false
    }
    
    static var shouldShowHelp: Bool {
        
        guard CommandLine.arguments.count > 0 else {
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
    
    static var extractTargetVersion: Int? {
        
        guard CommandLine.arguments.count > 0 else {
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
    
    static var extractFilenames: [String]? {
        
        guard CommandLine.arguments.count > 1 else {
            return nil
        }
        
        let optionWithParameter = /-[o]|--(output)/
        let optionWithoutParamter = /-.*|--.*/
        
        var filenames: [String]?
        var skipArgument = false
        
        for arg in CommandLine.arguments.dropFirst() {
            
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
    
    static var extractFrontend: String? {
        
        for arg in CommandLine.arguments {
            if arg.hasPrefix("--frontend=") {
                let components = arg.split(separator: "=", maxSplits: 1)
                if components.count == 2 {
                    return String(components[1])
                }
            }
        }
        
        return nil
    }
    
    static var extractBackend: String? {
        
        for arg in CommandLine.arguments {
            if arg.hasPrefix("--backend=") {
                let components = arg.split(separator: "=", maxSplits: 1)
                if components.count == 2 {
                    return String(components[1])
                }
            }
        }
        
        return nil
    }
    
    static var extractRuntime: String? {
        
        for arg in CommandLine.arguments {
            if arg.hasPrefix("--runtime=") {
                let components = arg.split(separator: "=", maxSplits: 1)
                if components.count == 2 {
                    return String(components[1])
                }
            }
        }
        
        return nil
    }
}
