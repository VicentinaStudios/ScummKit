//
//  Extensions.swift
//  scumm
//
//  Created by Michael Borgmann on 17/07/2023.
//

import Foundation

extension String {
    var escape: EscapeSequence {
        EscapeSequence(for : self)
    }
}

extension Equatable {
    
    func isEqual(_ other: any Equatable) -> Bool {
        
        guard let other = other as? Self else {
            return other.isExactlyEqual(self)
        }
        
        return self == other
    }
    
    private func isExactlyEqual(_ other: any Equatable) -> Bool {
        
        guard let other = other as? Self else {
            return false
        }
        
        return self == other
    }
}
