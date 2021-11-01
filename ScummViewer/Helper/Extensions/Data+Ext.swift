//
//  Data+Ext.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 17.10.21.
//

import Foundation

extension Data {
    
    var byteBuffer: [UInt8] {
        [UInt8](self)
    }
    
    var wordBuffer: [UInt16] {
        withUnsafeBytes { pointer in
            pointer.bindMemory(to: UInt16.self).map { $0 }
        }
    }
    
    var doubleWordBuffer: [UInt32] {
        withUnsafeBytes { pointer in
            pointer.bindMemory(to: UInt32.self).map { $0 }
        }
    }
    
    var hex8beBuffer: [String] {
        [UInt8](self).map { String(format: "%02hhx", $0) }
    }
    
    var hex16beBuffer: [String] {
        self.withUnsafeBytes { pointer in
            pointer.bindMemory(to: UInt16.self).map { String(format: "%04x", $0.bigEndian) }
        }
    }
    
    var hexString: String {
        map { String(format: "%02hhx", $0) }.joined()
    }

    func xor(with xor: UInt8) -> Data {
        Data(byteBuffer.map { $0.xor(with: xor) })
    }
    
    func dump(with value: UInt8 = 0x69) throws {
        
        let decoded = xor(with: value)
        let data = Data(decoded)
        
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as NSURL
        
        guard let fileUrl = documentsUrl.appendingPathComponent("scumm_dump.txt") else {
            throw FileError.urlFailure
        }
        
        do {
            try data.write(to: fileUrl)
        } catch {
            throw FileError.saveFailure
        }
    }
    
    func savePng() throws {
        
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as NSURL
        
        guard let fileUrl = documentsUrl.appendingPathComponent("image.png") else {
            throw FileError.urlFailure
        }
        
        do {
            try self.write(to: fileUrl)
        } catch {
            throw FileError.saveFailure
        }
    }
}

