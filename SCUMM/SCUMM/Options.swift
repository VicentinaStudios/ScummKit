//
//  Options.swift
//  SCUMM
//
//  Created by Michael Borgmann on 05/01/2024.
//

import Foundation

struct CompilerOptions {
    
    var isAnsiEnabled: Bool
    var isDebugEnabled: Bool
    var isAstPrinter: Bool
    var version = 5
    var frontend: String?
    var backend: String?
    var runtime: String?
    
    init() {
        isAnsiEnabled = !CommandLine.hasOption("--noansi")
        isDebugEnabled = CommandLine.hasOption("--debug")
        isAstPrinter = CommandLine.hasOption("--pretty")
        frontend = CommandLine.extractValue(for: "--frontend", prefix: "=")
        backend = CommandLine.extractValue(for: "--backend", prefix: "=")
        runtime = CommandLine.extractValue(for: "--runtime", prefix: "=")
    }
        
}

enum ExitStatusCodes: Int32 {
    
    case successfulTermination = 0
    case terminateApp = 1
    case commandLineUsageError = 64
    case dataFormatError = 65
    case cannotOpenInput = 66
    case addresseeUnknown = 67
    case hostNameUnknown = 68
    case serviceUnavailable = 69
    case internalSoftwareError = 70
    case systemError = 71
    case criticalOperatingSystemFileMissing = 72
    case cantCreateUserOutputFile = 73
    case inputOutputError = 74
    case tempFailureUserInvitedToRetry = 75
    case remoteErrorInOrotocol = 76
    case permissionDenied = 77
    case configurationError = 78
}
