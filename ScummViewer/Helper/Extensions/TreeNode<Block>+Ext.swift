//
//  TreeNode<Block>+Ext.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 04.11.21.
//

import Foundation

extension TreeNode where T == Block {
    
    func find(blockType: BlockType) -> TreeNode<Block>? {
        
        let parent = findParent(of: .ROOM)
        
        let block = parent.children?.first { block in
            block.value.name == blockType.rawValue
        }
        
        return block
    }
    
    private func findParent(of type: BlockType) -> TreeNode<Block> {
        
        var parent = self
        
        while BlockType(rawValue: parent.value.name) != type {
            if let grandParent = parent.parent {
                parent = grandParent
            }
        }
        
        return parent
    }
    
    func read(in fileURL: URL?) throws -> [UInt8] {
            
        do {
            let buffer = try blockData(for: self.value, in: fileURL).byteBuffer.xor(
                with: 0x69
            )
            
            return buffer
            
        } catch {
            throw FileError.loadFailure
        }
    }
    
    private func blockData(for block: Block, in fileURL: URL?) throws -> Data {
            
        guard let url = fileURL else {
            throw FileError.urlFailure
        }
        
        do {
            
            return try readData(
                from: url,
                at: UInt64(block.offset),
                with: Int(block.size)
            )
            
        } catch {
            throw FileError.loadFailure
        }
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
