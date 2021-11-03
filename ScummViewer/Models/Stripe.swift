//
//  Stripe.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 01.11.21.
//

import Foundation

struct Stripe {
    
    let codec: UInt8
    let data: [UInt8]
    
    var decoded: [UInt8] {
        try! ImageCodec(stripe: self).decode
    }
}

// MARK: - Enums & Constants

extension Stripe {
    
    enum CompressionMethod {
        case uncompressed
        case method1
        case method2
    }
    
    enum ReneringDirection {
        case horizontal
        case vertical
    }
}

// MARK: - Codec Details

extension Stripe {
    
    var compressionMethod: CompressionMethod {
        
        get throws {
            switch codec {
                case 0x1:
                    return .uncompressed
                case 0x0e...0x12:
                    return .method1
                case 0x18...0x1c:
                    return .method1
                case 0x22...0x26:
                    return .method1
                case 0x2c...0x30:
                    return .method1
                case 0x40...0x44:
                    return .method2
                case 0x54...0x58:
                    return .method2
                case 0x68...0x6c:
                    return .method2
                case 0x70...0x80:
                    return .method2
                default:
                    throw CodecError.unknownCodec
            }
        }
    }
    
    var renderingDirection: ReneringDirection {
        
        get throws {
            
            switch codec {
            case 0x1:
                return .horizontal
            case 0x0e...0x12:
                return .vertical
            case 0x18...0x1c:
                return .horizontal
            case 0x22...0x26:
                return .vertical
            case 0x2c...0x30:
                return .horizontal
            case 0x40...0x44:
                return .horizontal
            case 0x54...0x58:
                return .horizontal
            case 0x68...0x6c:
                return .horizontal
            case 0x70...0x80:
                return .horizontal
            default:
                throw CodecError.unknownCodec
            }
        }
    }
    
    var transparent: Bool {
        
        get throws {
            
            switch codec {
            case 0x1:
                return false
            case 0x0e...0x12:
                return false
            case 0x18...0x1c:
                return false
            case 0x22...0x26:
                return true
            case 0x2c...0x30:
                return true
            case 0x40...0x44:
                return false
            case 0x54...0x58:
                return true
            case 0x68...0x6c:
                return true
            case 0x70...0x80:
                return false
            default:
                throw CodecError.unknownCodec
            }
        }
    }
    
    var paramSubtraction: UInt8? {
        
        get throws {
            
            switch codec {
            case 0x1:
                return nil
            case 0x0e...0x12:
                return 0x0a
            case 0x18...0x1c:
                return 0x14
            case 0x22...0x26:
                return 0x1e
            case 0x2c...0x30:
                return 0x28
            case 0x40...0x44:
                return 0x3c
            case 0x54...0x58:
                return 0x51
            case 0x68...0x6c:
                return 0x64
            case 0x70...0x80:
                return 0x78
            default:
                throw CodecError.unknownCodec
            }
        }
    }
    
    var numberOfBitsForPaletteIndex: UInt8? {
        
        guard let paramSubtraction = try! paramSubtraction else {
            return nil
        }
        
        return codec - paramSubtraction
    }
}

