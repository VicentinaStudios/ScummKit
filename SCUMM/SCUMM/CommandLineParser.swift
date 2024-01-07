//
//  CommandLineParser.swift
//  SCUMM
//
//  Created by Michael Borgmann on 06/01/2024.
//

import Foundation
import ScummCompiler

class CommandLineParser {
    
    private var options = CompilerOptions()

    func parseOptions() -> CompilerOptions {
        
        if options.isDebugEnabled {
            configureDebugOptions()
        }

        if CommandLine.hasOption("--help") {
            Console.showHelpAndExit()
        }
        
        if CommandLine.hasOption("--version") {
            Console.showVersionAndExit()
        }
        
        configureCompiler()
        
        return options
    }
}

// MARK: - Parse Configuration

extension CommandLineParser {

    private func configureDebugOptions() {
        Configuration.DEBUG_TRACE_EXECUTION = true
    }
    
    private func configureCompiler() {
        
        do {
            
            try validateFrontend(options: options)
            try validateBackend(options: options)
            try validateRuntime(options: options)
            
        } catch CLIError.missingFrontend {
            
            if options.backend == nil, options.runtime == nil {
                setupInterpreter()
            } else if options.backend != nil, options.runtime == nil, loadSources() == nil {
                setupREPL()
            } else {
                Console.showWarning(error: CLIError.missingFrontend)
                setupDefaultParser()
            }
            
        } catch CLIError.missingRuntime {
            
            if options.backend == nil, loadSources() != nil {
                setupInterpreter()
            } else if loadSources() != nil, CommandLineParser.isOptionOutputActive {
                return
            } else {
                Console.showErrorAndExit(error: CLIError.missingRuntime)
            }
            
        } catch {
            Console.showErrorAndExit(error: error)
        }
    }
}

// MARK: - Validation

extension CommandLineParser {
    
    private func validateFrontend(options: CompilerOptions) throws {
        
        guard let frontend = options.frontend else {
            throw CLIError.missingFrontend
        }

        guard ["decent", "pratt"].contains(frontend) else {
            throw CLIError.unknownFrontend(frontend)
        }
    }
    
    private func validateBackend(options: CompilerOptions) throws {
        
        guard let backend = options.backend else {
            return
        }
        
        guard ["mojo", "scumm"].contains(backend) else {
            throw CLIError.unknownBackend(backend)
        }
    }
    
    private func validateRuntime(options: CompilerOptions) throws {
        
        guard let runtime = options.runtime else {
            throw CLIError.missingRuntime
        }
        
        if CommandLineParser.isOptionOutputActive {
            let output = try CommandLineParser.outputValue
            throw CLIError.noRuntimeNeeded(runtime, output)
        }
        
        guard options.backend != nil else {
            throw CLIError.missingBackend(runtime)
        }
        
        guard ["mojo", "scumm", "xray"].contains(runtime) else {
            throw CLIError.unknownRuntime(runtime)
        }
    }
}

// MARK: - Helper

extension CommandLineParser {
    
    private static var isOptionOutputActive: Bool {
        CommandLine.hasOption("-o") || CommandLine.hasOption("--output")
    }
    
    private static var outputValue: String {
        
        get throws {
            
            guard let result = CommandLine.extractValuesForOption(with: "-o") else {
                throw CLIError.missingOutput
            }
            
            guard result.count == 1, let output = result.first else {
                throw CLIError.tooManyValues(result)
            }
            
            return output
        }
    }
}

// MARK: - Error Handling

extension CommandLineParser {
    
    private func setupInterpreter() {
        options.frontend = "decent"
        options.runtime = options.isAstPrinter ? "ast" : "interpreter"
    }
    
    private func setupREPL() {
        options.frontend = "decent"
        options.runtime = "interpreter"
    }
    
    private func setupDefaultParser() {
        options.frontend = "decent"
    }
}
