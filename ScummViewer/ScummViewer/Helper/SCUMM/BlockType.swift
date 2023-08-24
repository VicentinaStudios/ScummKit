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
    
    // v4
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
    
    // v4
    // https://osiegmar.github.io/jmonkey/file-formats/data-files/
    case LE
    case FO
    case LF
    
    case RO
    
    case HD
    case CC
    case SP
    case BX
    case PA
    case SA
    case BM
    case OI
    case NL
    case SL
    case OC
    case EX
    case EN
    case LC
    case LS
    
    case SC
    case WA
    case AD
    case ROL
    
    case CO
    
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
            
        // SCUMM v4
            
        case .LE:
            return "LucasArts Entertainment"
        case .FO:
            return "Info"
        case .LF:
            return "Lucas File"
            
        case .RO:
            return "Room"
            
        case .HD:
            return "Room Header"
        case .CC:
            return "Color Cycling"
        case .SP:
            return "EGA color palette"
        case .BX:
            return "Walking Boxes"
        case .PA:
            return "VGA color palette"
        case .SA:
            return "Scale slots"
        case .BM:
            return "Background Image"
        case .OI:
            return "Object Image"
        case .NL:
            return "List of sounds"
        case .SL:
            return "List of unknown"
        case .OC:
            return "Object Code"
        case .EX:
            return "Room exit script"
        case .EN:
            return "Room entry script"
        case .LC:
            return "Local script count"
        case .LS:
            return "Local script"
        
        case .SC:
            return "Global Script"
        case .WA:
            return "Tandy"
        case .AD:
            return "Adlib"
        case .ROL:
            return "Roland MT-32"
        
        case .CO:
            return "Costume"
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
