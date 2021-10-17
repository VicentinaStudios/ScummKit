//
//  ScummVersion.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 17.10.21.
//

import Foundation

enum ScummVersion: CustomStringConvertible {
    
    case v1, v2, v3, v4, v5, v6, v7, v8
    
    var description: String {
        switch self {
            
        case .v1:
            return "1"
        case .v2:
            return "2"
        case .v3:
            return "3"
        case .v4:
            return "4"
        case .v5:
            return "5"
        case .v6:
            return "6"
        case .v7:
            return "7"
        case .v8:
            return "8"
        }
    }
}

extension ScummVersion {
    
    static private func detectBytes(for file: URL, offset: UInt64 = 0, length: Int = 2) -> UInt16? {
        
        do {
            
            let fileHandle = try FileHandle(forReadingFrom: file)
            fileHandle.seek(toFileOffset: offset)
            let data = fileHandle.readData(ofLength: length)
            
            let word = data.withUnsafeBytes {
                $0.load(as: UInt16.self)
            }
            
            fileHandle.closeFile()
            
            return word
            
        } catch {
            return nil
        }
    }
    
    static func dectect(files: [URL]) -> ScummVersion? {
        
        var version: ScummVersion?
        
        files.forEach { file in
            
            // Version 1-3
            if file.prefix == "00" && file.suffix.uppercased() == "LFL" {
                
                switch detectBytes(for: file)?.bigEndian {
                case 0xcef5:
                    version = .v1
                case 0xfffe:
                    
                    switch detectBytes(for: file, offset: 2)?.bigEndian {
                    case 0xf3fc:
                        version = .v2
                    case 0x17fc:
                        version = .v3
                    default:
                        break
                    }
                    
                case 0xf701:
                    version = .v3
                default:
                    break
                }
            }
            
            // Version 4
            if file.prefix == "000" && file.suffix.uppercased() == "LFL" {
                version = .v4
            }
            
            // Version 5, 6
            if file.suffix == "000" {
                
                if file.prefix == "TENTACLE" {
                    version = .v6
                } else {
                    version = .v5
                }
            }
            
            // Version 6
            if file.suffix == "SM0" {
                version = .v6
            }
            
            // Version 7, 8
            if file.suffix == "LA0" {
                
            }
        }
        
        return version
    }
}
