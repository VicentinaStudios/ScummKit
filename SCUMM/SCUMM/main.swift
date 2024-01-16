//
//  main.swift
//  SCUMM
//
//  Created by Michael Borgmann on 14/12/2023.
//

import Foundation
import ScummCompiler

main()

func main() {
    
    let commandLineParser = CommandLineParser()
    let options = commandLineParser.parseOptions()
    
    do {
        
        try configureCompiler(with: options)
                
        switch Configuration.RUNTIME {
            
        case .interpreter:
            
            guard let _ = loadSources() else {
                repl(with: options)
                return
            }
            
            guard
                !CommandLine.hasOption("-o"),
                !CommandLine.hasOption("--o")
            else {
                throw CLIError.redundantOutput
            }
            
            print("Interpreter:", options.frontend ?? "-", options.backend ?? "-", options.runtime ?? "-")
            
            guard
                let filename = loadSources()?.first,
                let source = try? String(contentsOfFile: filename, encoding: .utf8)
            else {
                throw CLIError.missingSources
            }
            
            let compiler = Compiler()
            try compiler.interpret(source: source)
            
        case .ast:
            
            print("AST:", options.frontend ?? "-", options.backend ?? "-", options.runtime ?? "-")
            
            guard
                let filename = loadSources()?.first,
                let source = try? String(contentsOfFile: filename, encoding: .utf8)
            else {
                throw CLIError.missingSources
            }
            
            let compiler = Compiler()
            try compiler.ast(source: source)
            
        case .scumm, .mojo, .xray:
            
            print("BYTECODE:", options.frontend ?? "-", options.backend ?? "-", options.runtime ?? "-")
            
            guard let sources = loadSources() else {
                throw CLIError.missingSources
            }
            
            guard
                !CommandLine.hasOption("-o"),
                !CommandLine.hasOption("--o")
            else {
                print("* Compile to bytecode")
                return
            }
            
            try run(sources, with: options)
        }
        
    } catch CLIError.missingSources {
        Console.showWarning(error: CLIError.missingSources)
    } catch {
        Console.showErrorAndExit(error: error)
    }
}

func repl(with options: CompilerOptions) {
    
    print("REPL:", options.frontend ?? "-", options.backend ?? "-", options.runtime ?? "-")
    
    while true {
        
        print("> ", terminator: "")

        if let line = readLine() {
            let vm = MojoVM()
            try? vm.interpret(source: line)
        } else {
            break
        }
    }
}

func run(_ sources: [String], with options: CompilerOptions) throws {
    
    print("VM:", options.frontend ?? "-", options.backend ?? "-", options.runtime ?? "-")
    
    guard
        let filename = sources.first,
        let source = try? String(contentsOfFile: filename, encoding: .utf8)
    else {
        throw CLIError.missingSources
    }
    
    let compiler = Compiler()
    let chunk = try compiler.compile(source: source)
    
    switch Configuration.RUNTIME {
        
    case .mojo:
        
        print("Mojo VM")
        
        let vm = MojoVM()
        try vm.interpret(chunk: chunk)

    case .scumm:
        
        print("SCUMM VM")
        
        let vm = ScummVM()
        try vm.interpret(chunk: chunk)

    case .xray:
        
        print("Mojo Decompiler")
        
        let decompiler = BaseDecompiler()
        if let decompilation = try decompiler.decompile(chunk) {
            decompiler.prettyPrint(decompilation, name: "Demo Chunk")
        }
        
    default:
        throw CLIError.unsupportedRuntime(
            runtime: Configuration.RUNTIME.rawValue, 
            backend: Configuration.BACKEND.rawValue
        )
        
    }
}

func loadSources() -> [String]? {
    CommandLine.extractValuesForOption(subsequentOption: "-o")
}

func configureCompiler(with options: CompilerOptions) throws {
    
    do {
        
        try setupFrontend(options.frontend)
        try setupBackend(for: options)
        try setupRuntime(options.runtime)
        
    } catch CLIError.noBackendSelected(let runtime) {
        Console.showWarning(error: CLIError.noBackendSelected(runtime))
    }
}

func setupFrontend(_ frontend: String?) throws {
    
    guard
        let frontend = frontend,
        let parser = Configuration.ParserType(rawValue: frontend)
    else {
        throw CLIError.missingFrontend
    }
    
    Configuration.PARSER = parser
}

func setupBackend(for options: CompilerOptions) throws {
        
    guard
        let backend = options.backend,
        let codeGenerator = Configuration.Backend(rawValue: backend)
    else {
        
        if options.runtime == "interpreter" || options.runtime == "ast"{
            return
        }
        
        guard let runtime = options.runtime else {
            
            let runtime = CommandLine.hasOption("--pretty")
                ? "AST printer (enabled command line argument: '--pretty')"
                : "interpreter"
            
                throw CLIError.noBackendSelected(runtime)
        }
        
        throw CLIError.missingBackend(runtime)
    }
    
    Configuration.BACKEND = codeGenerator
}

func setupRuntime(_ runtime: String?) throws {
    
    guard
        let runtime = runtime,
        let virtualMachine = Configuration.Runtime(rawValue: runtime)
    else {
        return
    }
    
    Configuration.RUNTIME = virtualMachine
}

//

/*
if Options.backend == "scumm" {
    
    do {
        
    guard let extract = CommandLine.extractValue(for: "-v") else {
        throw CLIError.missingVersion(backend: "SCUMM")
    }
    
    guard let version = Int(extract) else {
        throw CLIError.invalidOption(option: "-v", value: extract)
    }
    
    Options.version = version
    
        guard (0...8).contains(Options.version) else {
            throw CLIError.invalidVersions(version: Options.version)
        }
        
        guard Options.version == 5 else {
            throw CLIError.unsupportedVersion(version: Options.version)
            
            
        }
    } catch {
        showErrorAndExit(error: error)
    }
}
*/
