//
//  File.swift
//  
//
//  Created by Michael Borgmann on 17/09/2023.
//

import Foundation

/// Represents different platforms that SCUMM games have been released on.
enum ScummPlatform: String {
    
    /// 3DO
    case threeDO
    
    /// Amiga
    case amiga
    
    /// Apple II
    case appleII
    
    /// Atari ST
    case atariST
    
    /// CDTV
    case cdtv
    
    /// Commodore 64
    case c64
    
    /// Fujitsu FM Towns & Marty
    case fmtowns
    
    /// Apple Macintosh
    case macintosh
    
    /// Nintendo Entertainment System
    case nes
    
    /// DOS
    case dos
    
    /// Microsoft Windows
    case windows
    
    /// Sega CD (Mega-CD)
    case segaCD
    
    /// TurboGrafx-16/PC Engine
    case pcengine
    
    /// A textual description of the platform.
    var description: String {
        switch self {
            
        case .threeDO:
            return "3DO"
        case .amiga:
            return "Amiga"
        case .appleII:
            return "Apple II"
        case .atariST:
            return "Atari ST"
        case .cdtv:
            return "CDTV"
        case .c64:
            return "Commodore 64"
        case .fmtowns:
            return "Fujitsu FM Towns & Marty"
        case .macintosh:
            return "Apple Macintosh"
        case .nes:
            return "Nintendo Entertainment System"
        case .dos:
            return "DOS"
        case .windows:
            return "Microsoft Windows"
        case .segaCD:
            return "Sega CD (Mega-CD)"
        case .pcengine:
            return "TurboGrafx-16/PC Engine"
        }
    }
}
