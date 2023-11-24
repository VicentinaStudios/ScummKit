//
//  ConsoleIO.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 16/07/2023.
//

import Foundation

class CLI {
    
    let args: Arguments
    
    init(args: [String]? = nil) {
        self.args = Arguments(args: args)
    }
    
    static func writeMessage(_ message: String, at line: Int? = nil, to: OutputType = .standard) {
        switch to {
        case .standard:
            print("\(message)")
            
        case .compilerError:
            
            let position = {
                line != nil ? "line \(line!):" : "line ?:"
            }().escape.whiteBold
            
            let error = "error:".escape.redBold
            let message = message.escape.whiteBold
            
            print("\(position) \(error) \(message)")
            
        case .compilerWarning:
            
            let position = {
                line != nil ? "line \(line!):" : "line ?:"
            }().escape.whiteBold
            
            let warning = "warning:".escape.magentaBold
            let message = message.escape.whiteBold
            
            print("\(position) \(warning) \(message)")
            
        case .error:
            let error = "Error:".escape.red
            fputs("\(error) \(message)\n", stderr)
        }
    }
    
    func printUsage() {

        let executableName = (CommandLine.arguments[0] as NSString).lastPathComponent
            
        CLI.writeMessage("Syntax:\n\t\t\(executableName) [OPTIONS] FILENAME")
        CLI.writeMessage("Options:\n\t\t-v5     Input Script is v5")
    }
}

// MARK: - Constants, Structure, Types

extension CLI {
    
    enum OutputType {
        case error
        case standard
        case compilerError
        case compilerWarning
    }
}
