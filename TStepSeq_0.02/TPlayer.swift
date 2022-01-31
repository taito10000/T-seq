//
//  TPlayer.swift
//  TStepSeq_0.02
//
//  Created by Taito Kantomaa on 18.3.2021.
//

import Foundation
import AudioKit

protocol mixerDelegate {
    
    func updateMixer(forTrack: Int)
    
}

protocol recorderDelegate {
    
    func playNote(note: MIDINoteNumber, vel: MIDIVelocity, chan: MIDIChannel)
    func stopNote(note: MIDINoteNumber, vel: MIDIVelocity, chan: MIDIChannel)
    
}

protocol playerDelegate {
    
    func playNote(note: MIDINoteNumber, vel: MIDIVelocity, chan: MIDIChannel)
    func stopNote(note: MIDINoteNumber, vel: MIDIVelocity, chan: MIDIChannel)
    
}


class TPlayer: mixerDelegate, recorderDelegate, playerDelegate {
    
    
    let seq: AKSequencer!
    let midi : AKMIDI!
    let mixer: AKMixer!
    var playlist:TPlaylist!
    let instr: AKFlute!
    let filter: AKLowPassFilter!
    
    init(pllist: TPlaylist) {
        
        playlist = pllist
        seq = AKSequencer()
        midi = AKMIDI()
        mixer = AKMixer()
        midi.openOutput()
        instr = AKFlute()
        filter = AKLowPassFilter(instr!, cutoffFrequency: 2000, resonance: -2.0)
        playlist.mxrDelegate = self
        
        
       
        filter.dryWetMix = 100
        
        filter >>> mixer
        //instr >>> mixer
        // instr >>> filter
        filter.start()
        instr.play()
        
        
        AKManager.output = mixer
    }
    
    func setup() {
    
        playlist.tracks.forEach { (trc) in
            seq.tracks.append(trc.sequencerTrack)
            trc.delegate = self
            
            trc.sequencerTrack >>> mixer
            trc.sequencerInst >>> mixer
        }

    }
    
    
    func updateMixer(forTrack: Int) {
        playlist.tracks[forTrack].delegate = self
        playlist.tracks[forTrack].sequencerTrack >>> mixer
        playlist.tracks[forTrack].sequencerInst >>> mixer
        
        
    }
    
    
    
    
    
    func startManager() {
        
        do {try AKManager.start()} catch {print("ERROR - AudioManager ei käynnisty")}
        
    }
    
    
    
    func playNote(note: MIDINoteNumber, vel: MIDIVelocity, chan: MIDIChannel) {
        
        midi.sendNoteOnMessage(noteNumber: note, velocity: vel, channel: chan)
       // instr.trigger(frequency: note.midiNoteToFrequency(), amplitude: 0.2)
   
    }
    func stopNote(note: MIDINoteNumber, vel: MIDIVelocity, chan: MIDIChannel) {
        
        midi.sendNoteOffMessage(noteNumber: note, velocity: vel, channel: chan)
       // instr.stop()
    }
    
    
    func stopAllNotes() {
        
       /*
        for i in 0...127 {
            
            midi.sendNoteOffMessage(noteNumber: MIDINoteNumber(i), velocity: MIDIVelocity(100), channel: MIDIChannel(1))
            midi.sendNoteOffMessage(noteNumber: MIDINoteNumber(i), velocity: MIDIVelocity(100), channel: MIDIChannel(2))
            midi.sendNoteOffMessage(noteNumber: MIDINoteNumber(i), velocity: MIDIVelocity(100), channel: MIDIChannel(3))
            
        }
       // instr.stop()
        */
        midi.sendControllerMessage(MIDIByte(120), value: MIDIByte(0), channel: MIDIChannel(0))
        midi.sendControllerMessage(MIDIByte(120), value: MIDIByte(0), channel: MIDIChannel(1))
        midi.sendControllerMessage(MIDIByte(120), value: MIDIByte(0), channel: MIDIChannel(2))
        
    }
}
