//
//  Engine.swift
//  SPUTM
//
//  Created by Michael Borgmann on 27/08/2023.
//

import Foundation
import ScummCore

class Engine {
    
    private let variables: Variables
    
    init() throws {
        
        variables = try Variables(ScummVersion.v4)
    }
}

struct Constants {
    
    let screenWidth = 320
    let screenHeight = 200
    
    let numberOfActors = 13
    
    let ofOwnerRoomer = 0x0f
    
    let minHeapThreshold = 400000
    let maxHeapThreshold = 550000
}
