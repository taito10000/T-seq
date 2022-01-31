//
//  TRecorder.swift
//  TStepSeq_0.02
//
//  Created by Taito Kantomaa on 18.3.2021.
//

import Foundation
import AudioKit
import CoreMIDI
import AudioKitUI

protocol recStepDelegate {
    
    func recStep(note: MIDINoteNumber, vel: MIDIVelocity)
    
}

class TRecorder: AKMIDIListener, recStepDelegate {
    
    var delegate: stepViewDelegate?
    var playerdelegate: recorderDelegate?
    var midi: AKMIDI!
    var softKey: AKKeyboardView!
    var listener: AKMIDIListener!
    var playlist: TPlaylist!
    
    init(plylist: TPlaylist) {
        
        midi = AKMIDI()
        playlist = plylist
        midi.openInput()
        midi.addListener(self)
    }
    
    
    func playIfMidiThru(noteNumber:MIDINoteNumber, velocity:MIDIVelocity) {
        
        if playlist.midiThru {
            let chn = MIDIChannel(playlist.recTrack)
            playerdelegate?.playNote(note: noteNumber, vel: velocity, chan: chn)
            
            
        }
        
        
    }
    
    func recStep(note: MIDINoteNumber, vel: MIDIVelocity) {
        
        let trak = playlist.recTrack
        let step = playlist.recStep
        let page = playlist.viewPage
        let tstep = playlist.tracks[trak].patterns[page].stps[step]
        
        if playlist.recording {
            print("Playlist = recording")
            tstep.note = note
            tstep.vel = vel
            tstep.dur = 0.24
        }
        DispatchQueue.main.async {
            self.playlist.updateTracks()
          
            self.delegate?.nextRecStep()
           // self.delegate?.updateTracks(page: page)
        }
        
    }
    
    
    
    func receivedMIDINoteOn(noteNumber: MIDINoteNumber, velocity: MIDIVelocity, channel: MIDIChannel, portID: MIDIUniqueID?, offset: MIDITimeStamp) {
        
       recStep(note: noteNumber, vel: velocity)
        playIfMidiThru(noteNumber: noteNumber, velocity: velocity)
        
    }
    
    func receivedMIDINoteOff(noteNumber: MIDINoteNumber, velocity: MIDIVelocity, channel: MIDIChannel, portID: MIDIUniqueID?, offset: MIDITimeStamp) {
        if !playlist.midiThru {
            let ch = MIDIChannel(playlist.recTrack)
            playerdelegate?.stopNote(note: noteNumber, vel: velocity, chan: ch)
            
        }
    }
    
    
}
