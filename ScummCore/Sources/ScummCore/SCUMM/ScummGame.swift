//
//  ScummGame.swift
//
//
//  Created by Michael Borgmann on 18/09/2023.
//

import Foundation

/// An enumeration representing various Scumm games.
public enum ScummGame: String {
    
    /// Maniac Mansion
    case maniac
    
    /// Zak McKracken and the Alien Mindbenders
    case zak
    
    /// Indiana Jones and the Last Crusade
    case indy3
    
    /// Loom
    case loom
    
    /// The Secret of Monkey Island
    case monkey
    
    /// Monkey Island 2: LeChuck's Revenge
    case monkey2
    
    /// Indiana Jones and the Fate of Atlantis
    case indy4
    
    /// Day of the Tentacle
    case tentacle
    
    /// Sam & Max Hit the Road
    case samnmax
    
    /// Full Throttle
    case ft
    
    /// The Dig
    case dig
    
    /// The Curse of Monkey Island
    case cmi
    
    /// A textual description of the Scumm game.
    var description: String {
        switch self {
        
        case .maniac:
            return "Maniac Mansion"
        case .zak:
            return "Zak McKracken and the Alien Mindbenders"
        case .indy3:
            return "Indiana Jones and the Last Crusade"
        case .loom:
            return "Loom"
        case .monkey:
            return "The Secret of Monkey Island"
        case .monkey2:
            return "Monkey Island 2: LeChuck's Revenge"
        case .indy4:
            return "Indiana Jones and the Fate of Atlantis"
        case .tentacle:
            return "Day of the Tentacle"
        case .samnmax:
            return "Sam & Max Hit the Road"
        case .ft:
            return "Full Throttle"
        case .dig:
            return "The Dig"
        case .cmi:
            return "The Curse of Monkey Island"
        }
    }
}
