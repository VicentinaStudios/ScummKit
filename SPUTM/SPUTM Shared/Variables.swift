//
//  Variables.swift
//  SPUTM
//
//  Created by Michael Borgmann on 27/08/2023.
//

import Foundation
import ScummCore

struct Variables {
    
    static var VAR_KEYPRESS = 0xFF
    static var VAR_SYNC = 0xFF
    static var VAR_EGO = 0xFF
    static var VAR_CAMERA_POS_X = 0xFF
    static var VAR_HAVE_MSG = 0xFF
    static var VAR_ROOM = 0xFF
    static var VAR_OVERRIDE = 0xFF
    static var VAR_MACHINE_SPEED = 0xFF
    static var VAR_ME = 0xFF
    static var VAR_NUM_ACTOR = 0xFF
    static var VAR_CURRENT_LIGHTS = 0xFF
    static var VAR_CURRENTDRIVE = 0xFF          // How about merging this with VAR_CURRENTDISK?
    static var VAR_CURRENTDISK = 0xFF
    static var VAR_TMR_1 = 0xFF
    static var VAR_TMR_2 = 0xFF
    static var VAR_TMR_3 = 0xFF
    static var VAR_MUSIC_TIMER = 0xFF
    static var VAR_ACTOR_RANGE_MIN = 0xFF
    static var VAR_ACTOR_RANGE_MAX = 0xFF
    static var VAR_CAMERA_MIN_X = 0xFF
    static var VAR_CAMERA_MAX_X = 0xFF
    static var VAR_TIMER_NEXT = 0xFF
    static var VAR_VIRT_MOUSE_X = 0xFF
    static var VAR_VIRT_MOUSE_Y = 0xFF
    static var VAR_ROOM_RESOURCE = 0xFF
    static var VAR_LAST_SOUND = 0xFF
    static var VAR_CUTSCENEEXIT_KEY = 0xFF
    static var VAR_OPTIONS_KEY = 0xFF
    static var VAR_TALK_ACTOR = 0xFF
    static var VAR_CAMERA_FAST_X = 0xFF
    static var VAR_SCROLL_SCRIPT = 0xFF
    static var VAR_ENTRY_SCRIPT = 0xFF
    static var VAR_ENTRY_SCRIPT2 = 0xFF
    static var VAR_EXIT_SCRIPT = 0xFF
    static var VAR_EXIT_SCRIPT2 = 0xFF
    static var VAR_VERB_SCRIPT = 0xFF
    static var VAR_SENTENCE_SCRIPT = 0xFF
    static var VAR_INVENTORY_SCRIPT = 0xFF
    static var VAR_CUTSCENE_START_SCRIPT = 0xFF
    static var VAR_CUTSCENE_END_SCRIPT = 0xFF
    static var VAR_CHARINC = 0xFF
    static var VAR_WALKTO_OBJ = 0xFF
    static var VAR_DEBUGMODE = 0xFF
    static var VAR_HEAPSPACE = 0xFF
    static var VAR_RESTART_KEY = 0xFF
    static var VAR_PAUSE_KEY = 0xFF
    static var VAR_MOUSE_X = 0xFF
    static var VAR_MOUSE_Y = 0xFF
    static var VAR_TIMER = 0xFF
    static var VAR_TIMER_TOTAL = 0xFF
    static var VAR_SOUNDCARD = 0xFF
    static var VAR_VIDEOMODE = 0xFF
    static var VAR_MAINMENU_KEY = 0xFF
    static var VAR_FIXEDDISK = 0xFF
    static var VAR_CURSORSTATE = 0xFF
    static var VAR_USERPUT = 0xFF
    static var VAR_SOUNDRESULT = 0xFF
    static var VAR_TALKSTOP_KEY = 0xFF
    static var VAR_FADE_DELAY = 0xFF
    static var VAR_NOSUBTITLES = 0xFF
    
    // MARK: V5+
    static var VAR_SOUNDPARAM = 0xFF
    static var VAR_SOUNDPARAM2 = 0xFF
    static var VAR_SOUNDPARAM3 = 0xFF
    static var VAR_INPUTMODE = 0xFF
    static var VAR_MEMORY_PERFORMANCE = 0xFF
    static var VAR_VIDEO_PERFORMANCE = 0xFF
    static var VAR_ROOM_FLAG = 0xFF
    static var VAR_GAME_LOADED = 0xFF
    static var VAR_NEW_ROOM = 0xFF

    // MARK: V4/V5
    static var VAR_V5_TALK_STRING_Y = 0xFF
    
    init(_ version: ScummVersion) throws {
        
        guard version == .v4 || version == .v5 else {
            throw EngineError.scummVersionNotSupported(version)
        }
        
        Variables.VAR_KEYPRESS = 0
        Variables.VAR_EGO = 1
        Variables.VAR_CAMERA_POS_X = 2
        Variables.VAR_HAVE_MSG = 3
        Variables.VAR_ROOM = 4
        Variables.VAR_OVERRIDE = 5
        Variables.VAR_MACHINE_SPEED = 6
        Variables.VAR_ME = 7
        Variables.VAR_NUM_ACTOR = 8
        Variables.VAR_CURRENTDRIVE = 10
        Variables.VAR_TMR_1 = 11
        Variables.VAR_TMR_2 = 12
        Variables.VAR_TMR_3 = 13
        Variables.VAR_MUSIC_TIMER = 14
        Variables.VAR_ACTOR_RANGE_MIN = 15
        Variables.VAR_ACTOR_RANGE_MAX = 16
        Variables.VAR_CAMERA_MIN_X = 17
        Variables.VAR_CAMERA_MAX_X = 18
        Variables.VAR_TIMER_NEXT = 19
        Variables.VAR_VIRT_MOUSE_X = 20
        Variables.VAR_VIRT_MOUSE_Y = 21
        Variables.VAR_ROOM_RESOURCE = 22
        Variables.VAR_LAST_SOUND = 23
        Variables.VAR_CUTSCENEEXIT_KEY = 24
        Variables.VAR_TALK_ACTOR = 25
        Variables.VAR_CAMERA_FAST_X = 26
        Variables.VAR_ENTRY_SCRIPT = 28
        Variables.VAR_ENTRY_SCRIPT2 = 29
        Variables.VAR_EXIT_SCRIPT = 30
        Variables.VAR_EXIT_SCRIPT2 = 31
        Variables.VAR_VERB_SCRIPT = 32
        Variables.VAR_SENTENCE_SCRIPT = 33
        Variables.VAR_INVENTORY_SCRIPT = 34
        Variables.VAR_CUTSCENE_START_SCRIPT = 35
        Variables.VAR_CUTSCENE_END_SCRIPT = 36
        Variables.VAR_CHARINC = 37
        Variables.VAR_WALKTO_OBJ = 38
        Variables.VAR_HEAPSPACE = 40
        Variables.VAR_RESTART_KEY = 42
        Variables.VAR_PAUSE_KEY = 43
        Variables.VAR_MOUSE_X = 44
        Variables.VAR_MOUSE_Y = 45
        Variables.VAR_TIMER = 46
        Variables.VAR_TIMER_TOTAL = 47
        Variables.VAR_SOUNDCARD = 48
        Variables.VAR_VIDEOMODE = 49
        
        if version >= .v4 {
            minV4()
        }
        
        if version >= .v5 {
            minV5()
        }
        
        if version == .v5 {
            setupV5()
        }
    }
    
    private func minV4() {
        
        Variables.VAR_SCROLL_SCRIPT = 27
        Variables.VAR_DEBUGMODE = 39
        Variables.VAR_MAINMENU_KEY = 50
        Variables.VAR_FIXEDDISK = 51
        Variables.VAR_CURSORSTATE = 52
        Variables.VAR_USERPUT = 53
    }
    
    private func minV5() {
        
        Variables.VAR_SOUNDRESULT = 56
        Variables.VAR_TALKSTOP_KEY = 57
        Variables.VAR_FADE_DELAY = 59
        Variables.VAR_SOUNDPARAM = 64
        Variables.VAR_SOUNDPARAM2 = 65
        Variables.VAR_SOUNDPARAM3 = 66
        Variables.VAR_INPUTMODE = 67                  // 1 is keyboard, 2 is joystick, 3 is mouse
        Variables.VAR_MEMORY_PERFORMANCE = 68
        Variables.VAR_VIDEO_PERFORMANCE = 69
        Variables.VAR_ROOM_FLAG = 70
        Variables.VAR_GAME_LOADED = 71
        Variables.VAR_NEW_ROOM = 72
    }
    
    private func setupV5() {
        
        Variables.VAR_CURRENT_LIGHTS = 9
        Variables.VAR_V5_TALK_STRING_Y = 54
        Variables.VAR_NOSUBTITLES = 60
    }
}
