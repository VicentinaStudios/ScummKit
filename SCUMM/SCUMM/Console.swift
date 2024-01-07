//
//  Console.swift
//  SCUMM
//
//  Created by Michael Borgmann on 06/01/2024.
//

import Foundation

struct Console {
    
    static func showHelpAndExit() {
        
        let executableName = (CommandLine.arguments[0] as NSString).lastPathComponent
        
        print("Syntax:\n\t\t\(executableName) [OPTIONS] FILENAME")
        
        print("""
        Options:
                 --help                  Show this help
                 --version               Show SCUMM compiler version
                 --frontend=[PARSER]     Parsing frontend [decent|pratt]
                 --backend=[BYTECODE]    Code generator [scumm|mojo]
                 --runtime-[VM]          Virtual machine [scumm|mojo|xray]
                 --pretty                Print Abastract Syntax Tree
                 -v[n]                   Script version (only v5)
                 -o | --output FILENAME  Compilation output file
        """)
        
        print("\nExamples:")
        
        print("\t\t", "Run REPL")
        print("% \(executableName)")
        
        print("\t\t", "Run SCUMM interpreter")
        print("% \(executableName)", "source.scu")
        print("% \(executableName)", "--frontend=decent source.scu")
        print("% \(executableName)", "--frontend=pratt source.scu")
        
        print("\t\t", "Compile SCUMM code")
        print("% \(executableName)", "--frontend=decent --backend=scumm source.scu -o bytecode.scumm")
        print("% \(executableName)", "--frontend=pratt --backend=scumm source.scu -o bytecode.scumm")
        
        print("\t\t", "Compile and run SCUMM code")
        print("% \(executableName)", "--frontend=decent --backend=scumm --runtime=scumm source.scu")
        print("% \(executableName)", "--frontend=pratt --backend=scumm --runtime=scumm source.scu")
        
        print("\t\t", "Decompile SCUMM code")
        print("% \(executableName)", "--frontend=decent --backend=scumm --runtime=xray source.scu")
        print("% \(executableName)", "--frontend=pratt --backend=scumm --runtime=xray source.scu")
        
        print("\t\t", "Show Abstract Syntax Tree")
        print("% \(executableName)", "--pretty source.scu")
        
        exit(ExitStatusCodes.successfulTermination.rawValue)
    }

    static func showVersionAndExit() {
        print("SCUMM Compiler v0.1".escape.greenBold)
        exit(ExitStatusCodes.successfulTermination.rawValue)
    }

    static func showWarning(error: Error) {
        
        let tag = "[W]".escape.yellowBold
        let message = error.localizedDescription.escape.whiteBold
        fputs("\n\(tag) \(message)\n", stderr)
        
        guard let error = error as? LocalizedError else { return }
        
        if let failureReason = error.failureReason {
            let message = failureReason.escape.magentaBold
            fputs("\n    \(message)\n", stderr)
        }
        
        if let recoverySuggestion = error.recoverySuggestion {
            let message = recoverySuggestion.escape.yellow
            fputs("\n    \(message)\n", stderr)
        }
    }

    static func showErrorAndExit(error: Error) {
        
        let tag = "[E]".escape.redBold
        let message = error.localizedDescription.escape.whiteBold
        fputs("\n\(tag) \(message)\n", stderr)
        
        guard let error = error as? LocalizedError else { return }
        
        if let failureReason = error.failureReason {
            let message = failureReason.escape.magentaBold
            fputs("\n    \(message)\n", stderr)
        }
        
        if let recoverySuggestion = error.recoverySuggestion {
            let message = recoverySuggestion.escape.yellow
            fputs("\n    \(message)\n", stderr)
        }
        
        exit(ExitStatusCodes.terminateApp.rawValue)
    }
}
