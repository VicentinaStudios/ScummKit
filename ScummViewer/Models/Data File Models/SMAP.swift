//
//  SMAP.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 23.10.21.
//

import Foundation

struct SMAP {
    
    let blockName: UInt32
    let blockSize: UInt32
    let stripeOffsets: [UInt32]
    let stripes: [Stripe]
}

extension SMAP {
    
    static func create(from buffer: [UInt8], imageWidth width: UInt16) -> SMAP {
        
        var stripeOffsets: [UInt32] = []
        
        for column in 0..<width/8  {
            
            let offset = buffer.dwordLE(Int(column) * 4 + 8)
            stripeOffsets.append(offset)
        }
        
        try! Data(buffer).dump(with: 0)
        
        var stripes: [Stripe] = []
        
        for index in 0..<stripeOffsets.count {
            
            let start = stripeOffsets[index]
            let end = index < stripeOffsets.count - 1 ? stripeOffsets[index + 1] : UInt32(buffer.count)
            let size = end - start - 1
            
            let codec = buffer.byte(Int(start))
            let data = buffer.slice(Int(start + 1), size: Int(size))
            
            let stripe = Stripe(codec: codec, data: data)
            stripes.append(stripe)
        }
        
        return SMAP(
            blockName: buffer.dwordLE(0),
            blockSize: buffer.dwordBE(4),
            stripeOffsets: stripeOffsets,
            stripes: stripes
        )
    }
    
    static var empty: SMAP {
        SMAP(blockName: 0, blockSize: 0, stripeOffsets: [], stripes: [])
    }
}
