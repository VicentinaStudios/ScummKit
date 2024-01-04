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
    
    func dump(with value: UInt8 = 0x69, filename: String? = "scumm_dump.txt") throws {
        
        let decoded = xor(with: value)
        let data = Data(decoded)
        
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as NSURL
        
        guard let fileUrl = documentsUrl.appendingPathComponent(filename!) else {
            throw FileError.urlFailure
        }
        
        do {
            try data.write(to: fileUrl)
        } catch {
            throw FileError.saveFailure
        }
    }
    
    func saveScript(with value: UInt8 = 0x69, fileName: String = "script.o", to path: URL) throws {
        
        var isDirectory: ObjCBool = false
        
        if !FileManager.default.fileExists(atPath: path.absoluteString, isDirectory: &isDirectory) {
            try? FileManager.default.createDirectory(at: path, withIntermediateDirectories: true, attributes: nil)
        }
        
        let fileURL = path.appendingPathComponent(fileName)
        
//        let decoded = xor(with: value)
//        let data = Data(decoded)
        
        do {
            try write(to: fileURL)
        } catch {
            throw FileError.saveFailure
        }
    }
    
    func savePng(fileName: String = "image.png") throws {
        
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as NSURL
        
        guard let fileUrl = documentsUrl.appendingPathComponent(fileName) else {
            throw FileError.urlFailure
        }
        
        do {
            try self.write(to: fileUrl)
        } catch {
            throw FileError.saveFailure
        }
    }
    
    func savePng(fileName: String = "image.png", to path: URL? = nil) throws {
        
        guard let path = path else {
            try? savePng(fileName: fileName)
            return
        }
        
        //if !FileManager.default.fileExists(atPath: path.path, isDirectory: &isDirectory)
        var isDirectory: ObjCBool = false
        
        if !FileManager.default.fileExists(atPath: path.absoluteString, isDirectory: &isDirectory) {
            try? FileManager.default.createDirectory(at: path, withIntermediateDirectories: true, attributes: nil)
        }
        
        // Create the directory if it doesn't exist
//                    do {
//                        try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
//                    } catch {
//                        print("Failed to create directory: \(error)")
//                        return
//                    }
        
        let exportURL = path.appendingPathComponent(fileName)
        
        do {
            try self.write(to: exportURL)
        } catch {
            throw FileError.saveFailure
        }
    }
        
}

