//
//  MIDI.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 24/08/2023.
//

/*
 Debug as Hex value:
 expr printf("0x%x\n", (unsigned int)*(ptr - 4))
 */

import Foundation

class MIDI {
    
    private let buffer: [UInt8]
    private let ppqn = 480          // pulse per quarter?
    
    private var trackData: [UInt8] = []
    private var trackTime: [Int] = []
    private var currentNote: [Int] = []
    private var instrument: [UInt8] = []
    private var delay = 0
    private var delay2 = 0
    private var oldDelay = 0
    private var adlib: [UInt8] = []
    
    private var offset = 0
    
    init(with buffer: [UInt8]) {
        self.buffer = buffer
    }
    
    private var trimmedBuffer: [UInt8] {
        Array(buffer.dropFirst(6))
    }
    
    private var totalSize: Int {
        Constants.MIDIHeaderSize + 7 + 8 * Constants.ADLIB_INSTR_MIDI_HACK.count + trimmedBuffer.count + Constants.sysexAddition
    }
    
    private var tempoChangeMetaEvent: [UInt8] {
        
        // Write a tempo change Meta event
        // 473 / 4 Hz, convert to micro seconds.
        let dw = 1000000 * ppqn * 4 / 473;
        
        var event: [UInt8] = [0x00, 0xFF, 0x51, 0x03]
        
        event.append(contentsOf: [
            UInt8((dw >> 16) & 0xFF),
            UInt8((dw >> 8) & 0xFF),
            UInt8(dw & 0xFF)
        ])
        
        // NOTE: I think my code is buggy... too tired, check later with scummvm
        //
        // dw = 1000000 * ppqn * 4 / 473;
        // memcpy(ptr, "\x00\xFF\x51\x03", 4); ptr += 4;
        // *ptr++ = (byte)((dw >> 16) & 0xFF);
        // *ptr++ = (byte)((dw >> 8) & 0xFF);
        // *ptr++ = (byte)(dw & 0xFF);
        
        return event
    }
        
    var midi: [UInt8] {
        
        let midi = trimmedBuffer
        var header: [UInt8] = []
        
        offset = 2
        
        if midi.byte(offset) == 0x80 {
            let header = createMIDIHeader(type: .adl)
        } else {
            
            header = createMIDIHeader(type: .asfx)
            
            let dw = 1000000 * ppqn * 4 / 473
            header.append(contentsOf: [0x00, 0xff, 0x51, 0x03])
            header.append(UInt8((dw >> 16) & 0xff))
            header.append(UInt8((dw >> 8) & 0xff))
            header.append(UInt8(dw & 0xff))
            
            processMIDITrackData()
            
            ///
            
            var currentTime = 0
            
            while true {
                
                var minTime = -1
                var channel: Int?
                
                for (index, trackTime) in trackTime.enumerated() {
                    
                    if trackTime >= 0 && (minTime == -1 || minTime > trackTime) {
                        minTime = trackTime
                        channel = index
                    }
                }
                
                guard
                    minTime != -1,
                    let channel = channel
                else {
                    break
                }
                
                offset = Int(trackData[channel])
                let chunkType = trimmedBuffer[offset]
                
                if !currentNote.isEmpty, currentNote[channel] >= 0 {
                    
                    delay = minTime - currentTime
                    currentTime = minTime
                    variableLengthQuantity(for: delay)
                    adlib.append(UInt8(0x80 + channel))        // key off channel
                    adlib.append(UInt8(currentNote[channel]))
                    adlib.append(0)
                    currentNote[channel] = -1
                }
                
                switch ChunkType(rawValue: chunkType) {
                    
                // Instrument definition
                case .type1:
                    
                    instrument = trimmedBuffer.slice(offset + 1, size: 14)
                    offset += 15
                
                // Play Note?
                case .type2:
                    
                    //header.append(contentsOf: Constants.ADLIB_INSTR_MIDI_HACK)
                    adlib = Constants.ADLIB_INSTR_MIDI_HACK
                    
                    adlib[5] += UInt8(channel)
                    adlib[28] += UInt8(channel)
                    adlib[92] += UInt8(channel)
                    
                    /* mod_characteristic */
                    adlib[30 + 0] = (instrument[3] >> 4) & 0xf
                    adlib[30 + 1] = instrument[3] & 0xf
                    
                    /* mod_scalingOutputLevel */
                    adlib[30 + 2] = (instrument[4] >> 4) & 0xf
                    adlib[30 + 3] = instrument[4] & 0xf
                    
                    /* mod_attackDecay */
                    adlib[30 + 4] = (~instrument[5] >> 4) & 0xf
                    adlib[30 + 5] = ~instrument[5] & 0xf

                    /* mod_sustainRelease */
                    adlib[30 + 6] = (~instrument[6] >> 4) & 0xf
                    adlib[30 + 7] = ~instrument[6] & 0xf
                    
                    /* mod_waveformSelect */
                    adlib[30 + 8] = (instrument[7] >> 4) & 0xf
                    adlib[30 + 9] = instrument[7] & 0xf
                    
                    /* car_characteristic */
                    adlib[30 + 10] = (instrument[8] >> 4) & 0xf
                    adlib[30 + 11] = instrument[8] & 0xf
                    
                    /* car_scalingOutputLevel */
                    adlib[30 + 12] = (instrument[9] >> 4) & 0xf
                    adlib[30 + 13] = instrument[9] & 0xf
                    
                    /* car_attackDecay */
                    adlib[30 + 14] = (~instrument[10] >> 4) & 0xf
                    adlib[30 + 15] = ~instrument[10] & 0xf
                    
                    /* car_sustainRelease */
                    adlib[30 + 16] = (~instrument[11] >> 4) & 0xf
                    adlib[30 + 17] = ~instrument[11] & 0xf
                    
                    /* car_waveFormSelect */
                    adlib[30 + 18] = (instrument[12] >> 4) & 0xf
                    adlib[30 + 19] = instrument[12] & 0xf
                    
                    /* feedback */
                    adlib[30 + 20] = (instrument[2] >> 4) & 0xf
                    adlib[30 + 21] = instrument[2] & 0xf
                    
                    delay = minTime - currentTime
                    currentTime = minTime
                    
                    delay = Int(convertExtraFlags(target: 30 + 22, source: offset + 1))
                    delay2 = Int(convertExtraFlags(target: 30 + 40, source: offset + 6))
                    
                    if delay2 >= 0 && delay2 < delay {
                        delay = delay2
                    }
                    
                    if delay == -1 {
                        delay = 0
                    }
                    
                    /* duration */
                    adlib[30 + 58] = 0
                    adlib[30 + 59] = 0
                    
                    oldDelay = minTime - currentTime
                    currentTime = minTime
                    
                    variableLengthQuantity(for: oldDelay)
                    
                    var freq = ((Int(instrument[1] & 3)) << 8) | Int(instrument[0])
                    
                    if freq == 0 {
                        freq = 0x80
                    }
                    
                    freq <<= ((Int(instrument[1]) >> 2) + 1) & 7
                    
                    var note = -11
                    
                    while freq >= 0x100 {
                        note += 12
                        freq >>= 1
                    }
                    
                    if freq < 0x80 {
                        note = 0
                    } else {
                        note += Int(Constants.freq2Note[freq - 0x80])
                    }
                    
                    if note <= 0 {
                        note = 1
                    } else if note > 127 {
                        note = 127
                    }
                    
                    // Insert a note on event
                    adlib.append(UInt8(0x90 + channel))            // key on channel
                    adlib.append(UInt8(note))
                    adlib.append(63)
                    currentNote.append(note)
                    trackTime[channel] = currentTime + delay
                    
                    offset += 11
                    
                case .endOfTrack:
                    
                    // FIXME: This is incorrect. The original uses 0x80 for
                    // looping a single channel. We currently interpret it as stop
                    // thus we won't get looping for sound effects. It should
                    // always jump to the start of the channel.
                    //
                    // Since we convert the data to MIDI and we cannot only loop a
                    // single channel via MIDI fixing this will require some more
                    // thought.
                    
                    trackTime[channel] = -1
                    offset += 1
                
                default:
                    trackTime[channel] = -1
                }
                
                trackData[channel] = UInt8(offset)
            }
        }
        
        adlib.append(contentsOf: [0x00, 0xff, 0x2f, 0x00, 0x00])
        
        offset = 0
        
        return header + adlib
    }
    
    private func createMIDIHeader(type: MIDIType) -> [UInt8] {
        
        let swappedSize = CFSwapInt32(UInt32(totalSize))
        
        var header: [UInt8] = []
        
        header.append(contentsOf: Array(type.rawValue.utf8))                    // 41 53 46 58
        withUnsafeBytes(of: swappedSize) { header.append(contentsOf: $0) }      // 00 00 03 62
        
        header.append(contentsOf: Array("MDhd".utf8))                           // 4d 44 68 64
        header.append(contentsOf: [0, 0, 0, 8])                                 // 00 00 00 08
        header.append(contentsOf: [0, 0, 0, 0, 0, 0, 0, 0])                     // 00 00 00 00 00 00 00 00
        
        header.append(contentsOf: Array("MThd".utf8))                           // 4d 54 68 64
        header.append(contentsOf: [0, 0, 0, 6])                                 // 00 00 00 06
        header.append(contentsOf: [0, 0, 0, 1]) // MIDI format 0 with 1 track   // 00 00 00 01
        
        header.append(UInt8(ppqn >> 8))                                         // 01
        header.append(UInt8(ppqn & 0xff))                                       // e0
        
        header.append(contentsOf: Array("MTrk".utf8))                           // 4d 54 72 6b
        withUnsafeBytes(of: swappedSize) { header.append(contentsOf: $0) }      // 00 00 03 62
        
        return header
    }
    
    private func processChunk(type: ChunkType) -> Int {
        switch type {
        case .type1:
            return 15
        case .type2:
            return 11
        case .endOfTrack:
            return 1
        }
    }
    
    private func processMIDITrackData() {
        
        trackData = []
        trackTime = []
     
        var size = trimmedBuffer.count - 2
        
        while size > 0 {
            
            trackData.append(UInt8(offset))
            trackTime.append(0)
            
            while size > 0 {
                
                guard let chunkType = ChunkType(rawValue: trimmedBuffer[offset])
                else {
                    break
                }
                
                let chunkSize = chunkType.size
                
                offset += chunkSize
                size -= chunkSize
            }
            
            guard trimmedBuffer[offset] != Constants.endOfTrack else {
                break
            }
            
            offset += 1
        }
    }
    
    private func convertExtraFlags(target: Int, source offset: Int) -> Int16 {
        
        let midi = trimmedBuffer
        
        let flags = midi[offset]
        
        guard flags & 0x80 != 0 else {
            return -1
        }

        let t1 = (midi[offset + 1] & 0xf0) >> 3
        let t2 = (midi[offset + 2] & 0xf0) >> 3
        let t3 = (midi[offset + 3] & 0xf0) >> 3 | ((flags & 0x40) != 0 ? 0x80 : 0)
        let t4 = (midi[offset + 3] & 0x0f) << 1
        
        var v1 = midi[offset + 1] & 0x0f
        var v2 = midi[offset + 2] & 0x0f
        let v3 = UInt8(31)
        
        if (flags & 0x7) == 0 {
            v1 = v1 + 31 + 8
            v2 = v2 + 31 + 8
        } else {
            v1 = v1 * 2 + 31
            v2 = v2 * 2 + 31
        }
        
        /* flags a */
        
        if (flags & 0x7) == 6 {
            adlib[target + 0] = 0
        } else {
            adlib[target + 0] = (flags >> 4) & 0xb
            adlib[target + 1] = Constants.mapParam[Int(flags) & 0x7]
        }
        
        /* extra a */
        
        adlib[target + 2] = 0
        adlib[target + 3] = 0
        adlib[target + 4] = t1 >> 4
        adlib[target + 5] = t1 & 0xf
        adlib[target + 6] = v1 >> 4
        adlib[target + 7] = v1 & 0xf
        adlib[target + 8] = t2 >> 4
        adlib[target + 9] = t2 & 0xf
        adlib[target + 10] = v2 >> 4
        adlib[target + 11] = v2 & 0xf
        adlib[target + 12] = t3 >> 4
        adlib[target + 13] = t3 & 0xf
        adlib[target + 14] = t4 >> 4
        adlib[target + 15] = t4 & 0xf
        adlib[target + 16] = v3 >> 4
        adlib[target + 17] = v3 & 0xf
        
        var time = Constants.numStepsTable[Int(t1)] + Constants.numStepsTable[Int(t2)] + Constants.numStepsTable[Int(t3) & 0x7f] + Constants.numStepsTable[Int(t4)]
        
        if (flags & 0x20) != 0 {
            
            let playtime = ((midi[offset + 4] >> 4) & 0xf) * 118  + (midi[offset + 4] & 0xf) * 8
            
            if playtime > time {
                time = UInt16(playtime)
            }
        }
        
        return Int16(time)
    }
    
    private func variableLengthQuantity(for value: Int) {
        
        var value = value
        
        if value > 0x7f {
            
            if value > 0x3fff {
                
                let mask = (value >> 14) | 0x80
                adlib.append(UInt8(mask))
                
                value &= 0x3fff
            }
            
            let mask = (value >> 7) | 0x80
            adlib.append(UInt8(mask))
            
            value &= 0x7f
        }
        
        adlib.append(UInt8(value))
    }
}

extension MIDI {
    
    enum MIDIType: String {
        case adl = "ADL "
        case asfx = "ASFX"
    }
    
    enum ChunkType: UInt8 {
        
        case type1 = 1
        case type2 = 2
        case endOfTrack = 0x80
        
        var size: Int {
            
            switch self {
            case .type1:
                return 15
            case .type2:
                return 11
            case .endOfTrack:
                return 1
            }
        }
    }
    
    struct Constants {
        
        static let labelWidth: CGFloat = 127
        
        static let MIDIHeaderSize = 46
        
        // AdLib MIDI-SYSEX to set MIDI instruments for small header games.
        static let ADLIB_INSTR_MIDI_HACK: [UInt8] = [
            0x00, 0xf0, 0x14, 0x7d, 0x00,  // sysex 00: part on/off
            0x00, 0x00, 0x03,              // part/channel  (offset  5)
            0x00, 0x00, 0x07, 0x0f, 0x00, 0x00, 0x08, 0x00,
            0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0xf7,
            0x00, 0xf0, 0x41, 0x7d, 0x10,  // sysex 16: set instrument
            0x00, 0x01,                    // part/channel  (offset 28)
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0xf7,
            0x00, 0xb0, 0x07, 0x64        // Controller 7 = 100 (offset 92)
        ]
        
        static let sysexAddition = 24       // Up to 24 additional bytes are needed for the jump sysex
        
        static let endOfTrack = 0xff        // status type
        
        static let mapParam: [UInt8] = [0, 2, 3, 4, 8, 9, 0]
        
        static let numStepsTable: [UInt16] = [
            1, 2, 4, 5,
            6, 7, 8, 9,
            10, 12, 14, 16,
            18, 21, 24, 30,
            36, 50, 64, 82,
            100, 136, 160, 192,
            240, 276, 340, 460,
            600, 860, 1200, 1600
        ]
        
        static let freq2Note: [UInt8] = [
            /*128*/    6, 6, 6, 6,
            /*132*/ 7, 7, 7, 7, 7, 7, 7,
            /*139*/ 8, 8, 8, 8, 8, 8, 8, 8, 8,
            /*148*/ 9, 9, 9, 9, 9, 9, 9, 9, 9,
            /*157*/ 10, 10, 10, 10, 10, 10, 10, 10, 10,
            /*166*/ 11, 11, 11, 11, 11, 11, 11, 11, 11, 11,
            /*176*/ 12, 12, 12, 12, 12, 12, 12, 12, 12, 12,
            /*186*/ 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13,
            /*197*/ 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14,
            /*209*/ 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15,
            /*222*/ 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16,
            /*235*/ 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17,
            /*249*/ 18, 18, 18, 18, 18, 18, 18
        ]
    }
}
