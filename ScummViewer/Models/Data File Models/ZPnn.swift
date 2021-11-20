//
//  ZPNN.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 07.11.21.
//

import Foundation

struct ZPnn {
    
    struct Stripe {
        
        let data: [UInt8]
        
//        var decoded: [UInt8] {
//            try! ImageCodec(stripe: self).decode
//        }
    }
    
    let blockName: UInt32
    let blockSize: UInt32
    let stripeOffsets: [UInt16]
    let stripes: [ZPnn.Stripe]
}
