//
//  BlockType.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 21.10.21.
//

import Foundation

enum BlockType: String {
    
    // Index File
    
    case RNAM
    case MAXS
    case DROO
    case DSCR
    case DSOU
    case DCOS
    case DCHR
    case DOBJ
    
    // Data File
    
    case LECF
    case LOFF
    case LFLF
    case ROOM
    case RMHD
    case CYCL
    case TRNS
    case EPAL
    case CLUT
    case RMIM
    case RMIH
    case IM00, IM01, IM02, IM03, IM04, IM05, IM06, IM07, IM08, IM09, IM0A, IM0B, IM0C, IM0D, IM0E, IM0F
    case SMAP
    case ZP01, ZP02, ZP03
    case OBIM
    case IMHD
    case OBCD
    case CDHD
    case VERB
    case OBNA
    case EXCD
    case ENCD
    case NLSC
    case LSCR
    case BOXD
    case BOXM
    case SCAL
    case SCRP
    case SOUN
    case COST
    case CHAR
    
    var title: String {
        switch self {
            
        // Index File
        
        case .RNAM:
            return "Room Numbers"
        case .MAXS:
            return "Maximum Values"
        case .DROO:
            return "Directory of Rooms"
        case .DSCR:
            return "Directory of Scripts"
        case .DSOU:
            return "Directory of Sounds"
        case .DCOS:
            return "Directory of Costumes"
        case .DCHR:
            return "Directory of Charsets"
        case .DOBJ:
            return "Directory of Objects"
        
        // Data Files
        
        case .LECF:
            return "Main Container"
        case .LOFF:
            return "Room Offset Table"
        case .LFLF:
            return "Disk Block"
        case .ROOM:
            return "Room Block"
        case .RMHD:
            return "Room Header"
        case .CYCL:
            return "Color Cycle"
        case .TRNS:
            return "Transparent Color"
        case .EPAL:
            return "Palette Data 1"
        case .CLUT:
            return "Palette Data 2"
        case .RMIM:
            return "Room Image"
        case .RMIH:
            return "Number of Z-Buffers"
        case .IM00, .IM01, .IM02, .IM03, .IM04, .IM05, .IM06, .IM07, .IM08, .IM09, .IM0A, .IM0B, .IM0C, .IM0D, .IM0E, .IM0F:
            return "Image Data"
        case .SMAP:
            return "Stripe Table + Plane 0"
        case .ZP01, .ZP02, .ZP03:
            return "Stripe + Z Planes (nn >= 1)"
        case .OBIM:
            return "Object Image"
        case .IMHD:
            return "Image Header"
        case .OBCD:
            return "Object Scripts"
        case .CDHD:
            return "Code Header"
        case .VERB:
            return "Verb Entities"
        case .OBNA:
            return "Object Name"
        case .EXCD:
            return "Exit Script"
        case .ENCD:
            return "Entry Script"
        case .NLSC:
            return "Number of Local Scripts"
        case .LSCR:
            return "Local Script"
        case .BOXD:
            return "Box Data"
        case .BOXM:
            return "Box Matrix"
        case .SCAL:
            return "SCAL"
        case .SCRP:
            return "Script"
        case .SOUN:
            return "Sound"
        case .COST:
            return "Costume"
        case .CHAR:
            return "Charset"
        }
    }
}
