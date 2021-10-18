//
//  ScummData.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 13.10.21.
//

import Foundation

enum FileError: Error {
    case loadFailure
    case saveFailure
    case urlFailure
}

class ScummStore: ObservableObject {
    
    @Published var scummFiles: [TreeNode<ScummFile>] = []
    @Published var scummVersion: ScummVersion?
    
    init() {}
        
    init(witchChecking: Bool) throws {
        
        #if DEBUG
        do {
            try createDevData()
        } catch {
            throw error
        }
        #endif
    }
    
    func readDirectory(at url: URL) throws {
        
        do {            
            let urls = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
            
            guard !urls.isEmpty else {
                throw FileError.urlFailure
            }
            
            let sorted = urls.sorted { a, b in
                a.lastPathComponent.localizedStandardCompare(b.lastPathComponent) == ComparisonResult.orderedAscending
            }
            
            scummFiles.removeAll()
            
            try sorted.forEach { fileURL in
        
                let type: ScummFile.FileType?
                
                switch fileURL.suffix {
                case "000":
                    type = .indexFile
                case "001":
                    type = .dataFile
                default:
                    type = nil
                }
                
                let tree: TreeNode<Block>
                
                switch type {
                    
                case .indexFile:
                    tree = try analyzeIndexFile(url: fileURL)
                case .dataFile:
                    tree = try analyzeDataFile(url: fileURL)
                default:
                    return
                }
                
                let file = TreeNode<ScummFile>(with: ScummFile(fileURL: fileURL, tree: tree, type: type))
                scummFiles.append(file)
            }
            
        } catch {
            throw error
        }
    }
    
    static var create: ScummStore {
        do {
            return try ScummStore(witchChecking: true)
        } catch {
            return ScummStore()
        }
    }
}

// MARK: - Index & Data File

extension ScummStore {
    
    func analyzeIndexFile(url indexFile: URL) throws -> TreeNode<Block> {
        
        do {
            
            let fileSize = try fileSize(from: indexFile)
            
            let root = Block(
                for: indexFile.lastPathComponent,
                with: UInt32(fileSize),
                at: 0
            )
            
            let tree = TreeNode<Block>(with: root)
            
            var offset: UInt64 = 0
            
            while offset < fileSize {
                
                let blockInfo = try readBlockInfo(from: indexFile, at: offset)
                let node = TreeNode<Block>(with: blockInfo)
                tree.add(node)
                offset += UInt64(blockInfo.size)
            }
            
            return tree
            
        } catch {
            throw error
        }
    }
    
    private func analyzeDataFile(url dataFile: URL) throws -> TreeNode<Block> {
        
        do {
            
            let fileSize = try fileSize(from: dataFile)
            
            let root = Block(
                for: dataFile.lastPathComponent,
                with: UInt32(fileSize),
                at: 0
            )
            
            let tree = TreeNode<Block>(with: root)
            
            try analyzeTreeLevel(node: tree, for: dataFile)
            
            return tree
        } catch {
            throw error
        }
    }
    
    private func analyzeTreeLevel(node: TreeNode<Block>, for url: URL, at position: UInt64 = 0) throws {
        
        var offset = position
        
        do {
            
            while offset < node.value.size + node.value.offset {
                
                let blockInfo = try readBlockInfo(from: url, at: offset)
                let child = TreeNode<Block>(with: blockInfo)
                node.add(child)
                
                switch blockInfo.name {
                case "RMHD", "CYCL", "TRNS", "EPAL", "BOXD", "BOXM", "CLUT", "SCAL", "RMIH", "SMAP", "ZP01", "ZP02", "ZP03", "IMHD", "CDHD", "VERB", "OBNA", "EXCD", "ENCD", "NLSC", "LSCR", "SCRP", "SOUN", "COST", "CHAR", "LOFF":
                    break
                    
                // NOTE: Analyze is here just to test matching unknown blocks, and can actually be in the default case.
                case "LECF", "LFLF", "ROOM", "RMIM", "IM00", "OBIM", "OBCD",
                    "IM01", "IM02", "IM03", "IM04", "IM05", "IM06", "IM07", "IM08", "IM09", "IM0A", "IM0B", "IM0C", "IM0D", "IM0E", "IM0F":
                    try analyzeTreeLevel(node: child, for: url, at: offset + 8)
                default:
                    break
                }
                
                offset += UInt64(blockInfo.size)
            }
        } catch {
            throw FileError.loadFailure
        }
    }
    
    private func readBlockInfo(from url: URL, at offset: UInt64) throws -> Block {
        
        do {
            
            let blockName = try readData(from: url, at: offset, with: 4)
                .xor(with: 0x69)
                .map { $0.char }
                .joined()
            
            let blockSize = try readData(from: url, at: offset + 4, with: 4)
                .xor(with: 0x69)
                .doubleWordBuffer[0]
                .bigEndian
            
            return Block(for: blockName, with: blockSize, at: UInt32(offset))
            
        } catch {
            throw FileError.loadFailure
        }
    }
    
    private func fileSize(from url: URL) throws -> UInt64 {
        
        var size: UInt64 = 0
        
        do {
            
            let fileHandle = try FileHandle.init(forReadingFrom: url)
            size = UInt64(fileHandle.availableData.count)
            fileHandle.closeFile()
            
        } catch {
            throw FileError.urlFailure
        }
        
        return size
    }
    
    private func readData(from file: URL, at offset: UInt64, with length: Int) throws -> Data {
        
        do {
            
            let fileHandle = try FileHandle(forReadingFrom: file)
            fileHandle.seek(toFileOffset: offset)
            let data = fileHandle.readData(ofLength: length)
            
            fileHandle.closeFile()
            
            return data
            
        } catch {
            throw FileError.loadFailure
        }
    }
}
