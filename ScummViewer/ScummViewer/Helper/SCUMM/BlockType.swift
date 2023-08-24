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
    
    case RN
    case _0R = "0R"
    case _0S = "0S"
    case _0N = "0N"
    case _0C = "0C"
    case _0O = "0O"
    
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
        
        case .RNAM, .RN:
            return "Room Numbers"
        case .MAXS:
            return "Maximum Values"
        case .DROO, ._0R:
            return "Directory of Rooms"
        case .DSCR, ._0S:
            return "Directory of Scripts"
        case .DSOU, ._0N:
            return "Directory of Sounds"
        case .DCOS, ._0C:
            return "Directory of Costumes"
        case .DCHR:
            return "Directory of Charsets"
        case .DOBJ, ._0O:
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

    var directory: String {
        switch self {
        case .DROO:
            return "Room"
        case .DSCR:
            return "Script"
        case .DSOU:
            return "Sound"
        case .DCOS:
            return "Costume"
        case .DCHR:
            return "Charset"
        case .DOBJ:
            return "Owner + State"
        default:
            return "Unknown Directory Type"
        }
    }
    
}
