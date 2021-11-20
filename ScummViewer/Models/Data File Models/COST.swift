//
//  COST.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 09.11.21.
//

import Foundation
import SwiftUI

struct COST {
    
    struct Animation {
        
        struct Definition {
            let index: UInt16
            let length: UInt8?
        }
        
        let limbMask: UInt16
        let definition: [Definition]
    }
    
    struct Image {
        let width: UInt16
        let height: UInt16
        let relX: UInt16
        let relY: UInt16
        let moveX: UInt16
        let moveY: UInt16
        let rle: [UInt8]
    }
    
    let blockName: UInt32
    let blockSize: UInt32
    var numberOfAnimations: UInt8
    let format: UInt8
    let colors: [UInt8]
    let animationComandsOffset: UInt16
    let limbsOffsets: [UInt16]
    let animationOffsets: [UInt16]
    let animations: [Animation]
    let commands: [UInt8]
    let limbs: [UInt16]
    let images: [Image]
}


extension COST {
    
    static func create(from buffer: [UInt8]) -> COST {
        
        self.buffer = buffer
        
        let numberOfAnimations = numberOfAnimations()
        
        let format = format()
        
        let colors = colors(for: format)
        
        let animationComandsOffset = animationComandsOffset()
        
        let limbOffsets = limbOffsets()
        
        let animationOffsets = animationOffsets(for: numberOfAnimations)
        
        let animations = animations(for: animationOffsets)
        
        let size = Int(limbOffsets[0] - animationComandsOffset)
        let animationCommands = animationCommands(at: animationComandsOffset, with: size)
        
        let numberOfPictures = numberOfPictures(for: animationCommands)
        let limbs = limbs(for: limbOffsets, pictureCount: numberOfPictures)
        
        let images = images(for: limbs)
        
        offset = 8
        
        return COST(
            blockName: buffer.dwordLE(0),
            blockSize: buffer.dwordBE(4),
            numberOfAnimations: numberOfAnimations,
            format: format,
            colors: colors,
            animationComandsOffset: animationComandsOffset,
            limbsOffsets: limbOffsets,
            animationOffsets: animationOffsets,
            animations: animations,
            commands: animationCommands,
            limbs: limbs,
            images: images
        )
    }
    
    static var empty: COST {
        COST(
            blockName: 0,
            blockSize: 0,
            numberOfAnimations: 0,
            format: 0,
            colors: [],
            animationComandsOffset: 0,
            limbsOffsets: [],
            animationOffsets: [],
            animations: [],
            commands: [],
            limbs: [],
            images: []
        )
    }
}

// MARK: - Decode Costume Header

extension COST {
    
    private static var offset = 8
    
    private static var _buffer: [UInt8] = []
    private static var buffer: [UInt8] {
        get { _buffer }
        set { _buffer = newValue }
    }
}

// MARK: General Information

extension COST {
    
    private static func numberOfColors(from format: UInt8) -> Int {
        format & 0x1 == 0 ? 16 : 32
    }
    
    static private func numberOfAnimations() -> UInt8 {
        
        // NOTE: Is SCUMM 5 numberOfAnimations + 1?
        
        let numberOfAnimations = buffer.byte(offset)
        offset += 1
        return numberOfAnimations + 1
    }
    
    static private func format() -> UInt8 {
        
        let format = buffer.byte(offset)
        offset += 1
        return format
    }
    
    static private func colors(for format: UInt8) -> [UInt8] {
        
        let colors = buffer.slice(offset, size: numberOfColors(from: format))
        offset += colors.count
        return colors
    }
}

// MARK: Offsets

extension COST {
    
    static private func animationComandsOffset() -> UInt16 {
        
        // NOTE: Is SCUMM 5 anim cmd offs - 6?
        
        let animationComandsOffset = buffer.wordLE(offset)
        offset += 2
        return animationComandsOffset
    }
    
    static private func limbOffsets() -> [UInt16] {
        
        // NOTE: Is SCUMM 5 limb offset - 6?
        
        (0..<16).map { _ -> UInt16 in
            let limbOffset = buffer.wordLE(offset)
            offset += 2
            return limbOffset - 6
        }
    }
    
    static private func animationOffsets(for numberOfAnimations: UInt8) -> [UInt16] {
        
        // NOTE: Is SCUMM 5 anim offset - 6?
        
        (0..<numberOfAnimations).map { _ -> UInt16 in
            let animationOffset = buffer.wordLE(offset)
            offset += 2
            return animationOffset
        }
        .filter { $0 > 0 }
        .map { $0 - 6 }
    }
}

// MARK: Animations

extension COST {
    
    static private func limbMask() -> UInt16 {
    
        let limbMask = buffer.wordLE(offset)
        offset += 2
        return limbMask
    }
    
    static func numberOfLimbs(for limbMask: UInt16) -> UInt16 {
        
        var numberOfLimbs = limbMask
        
        numberOfLimbs = (numberOfLimbs & 0x5555) + ((numberOfLimbs >> 1) & 0x5555)
        numberOfLimbs = (numberOfLimbs & 0x3333) + ((numberOfLimbs >> 2) & 0x3333)
        numberOfLimbs = (numberOfLimbs & 0x0f0f) + ((numberOfLimbs >> 4) & 0x0f0f)
        numberOfLimbs = (numberOfLimbs & 0x00ff) + ((numberOfLimbs >> 8) & 0x00ff)
        
        return numberOfLimbs
    }
    
    static private func startIndex() -> UInt16 {
    
        let startIndex = buffer.wordLE(offset)
        offset += 2
        return startIndex
    }
    
    static private func endIndex() -> UInt8 {
    
        let endIndex = buffer.byte(offset)
        offset += 1
        return endIndex
    }
    
    static private func animations(for animationOffsets: [UInt16]) -> [Animation] {
        
        // NOTE: Is SCUMM 5 anim cmd offs + 8?
        
        let animations = animationOffsets.filter { $0 > 0 }.map { animationOffsets -> Animation in
            
            let limbMask = limbMask()
            let numberOfLimbs = numberOfLimbs(for: limbMask)
            
            var definitions: [Animation.Definition] = []
            
            for limb in 0..<numberOfLimbs {
                
                let startIndex = startIndex()
                let endIndex = startIndex == 0xffff ? nil : endIndex()
                
                let definition = Animation.Definition(index: startIndex, length: endIndex)
                definitions.append(definition)
            }
            
            return Animation(limbMask: limbMask, definition: definitions)
        }
        
        return animations
    }
    
    static private func animationCommands(at animationCommandsOffset: UInt16, with size: Int) -> [UInt8] {
    
        let commands = buffer.slice(Int(animationCommandsOffset + 8), size: size)
        offset += size
        return commands
    }
}

// MARK: Images

extension COST {
    
    static private func numberOfPictures(for commands: [UInt8]) -> Int {
        
        var count = 0
        
        commands.enumerated().forEach { index, command in
            if index < 0x71 && index > count {
                count = index
            }
        }
        
        return count
    }
    
    static private func limbs(for limbOffsets: [UInt16], pictureCount: Int) -> [UInt16] {
        
        offset = Int(limbOffsets[0])
        
        let limbs = (0..<pictureCount).map { index -> UInt16 in
            
            let pictureOffset = buffer.wordLE(offset + 8)
            offset += 2
            return pictureOffset
        }
        .filter { $0 > 6 }
        .filter { $0 < buffer.count }
        .map { $0 - 6 }
        
        return limbs
    }
    
    static private func images(for limbs: [UInt16]) -> [Image] {
        
        var images: [Image] = []
        
        var previousOffset = 0
        
        limbs.enumerated().forEach { index, imageOffset in
            
            offset = Int(imageOffset) + 8
            
            let width = buffer.wordLE(offset)
            offset += 2
            
            let height = buffer.wordLE(offset)
            offset += 2
            
            let relX = buffer.wordLE(offset)
            offset += 2
            
            let relY = buffer.wordLE(offset)
            offset += 2
            
            let moveX = buffer.wordLE(offset)
            offset += 2
            
            let moveY = buffer.wordLE(offset)
            offset += 2
            
            var end = buffer.count - 1
            if index < limbs.count - 1 {
                end = Int(limbs[index + 1] + 8)
            }
            
            if offset < end {
                
                let rle = buffer.slice(offset, size: end - offset)
                
                let image = Image(width: width, height: height, relX: relX, relY: relY, moveX: moveX, moveY: moveY, rle: rle)
                images.append(image)
            }
        }
        
        return images
    }
}
