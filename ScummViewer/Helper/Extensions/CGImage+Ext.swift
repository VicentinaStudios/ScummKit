//
//  CGImage+Ext.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 30.10.21.
//

import Foundation
import ImageIO

extension CGImage {
    
    var pngData: Data? {
        
        guard
            let cfData = CFDataCreateMutable(nil, 0),
            let destination = CGImageDestinationCreateWithData(cfData, kUTTypePNG as CFString, 1, nil)
        else {
            return nil
        }
        
        CGImageDestinationAddImage(destination, self, nil)
        
        if CGImageDestinationFinalize(destination) {
            return cfData as Data
        }
        
        return nil
    }
}
