//
//  TTrack.swift
//  TStepSeq_0.02
//
//  Created by Taito Kantomaa on 18.3.2021.
//

import Foundation
import AudioKit

class TTrack {
    
    
    var trackNo: Int = 0      // Toimii CHAN numerona paitsi että 0 -> Runner
    var patterns:[TPattern] = []
    var res: Int = 0
    var sequencerTrack: AKSequencerTrack!
    var sequencerInst: AKCallbackInstrument!
    var playArea = [0, 1]
    var delegate: playerDelegate?
    
    init(trackNumber: Int, resolution: Int, plArea: [Int]) {
        
        sequencerTrack = AKSequencerTrack()
        sequencerTrack.length = 0.0
        sequencerInst = AKCallbackInstrument()
        trackNo = trackNumber
        newPattern(res:resolution)
        res = resolution
        playArea = plArea
        setInstCallback()
        sequencerTrack.setTarget(node: sequencerInst)
    }
    
// MARK: Inst Callback Function
    func  setInstCallback() {
        if trackNo != 0 {
        sequencerInst.callback = {status, note, vel in
            
            
            switch status {
            case 144:
               // print("Track: \(self.trackNo)" )
               // print("Note ON: \(note)")
                
                self.delegate?.playNote(note: note, vel: vel, chan: MIDIChannel(self.trackNo))
            
            case 128:
              //  print("Note Off: \(note)")
                self.delegate?.stopNote(note: note, vel: vel, chan: MIDIChannel(self.trackNo))
                
                
            default:
                print("Ei kumpikaan - 144 tai 128")
            }
            
            
            
            }
        
        } else {
            
            sequencerInst.callback = {status, note, vel in
                
                print("Tämä on RunnerTrack CallBack")
            }
            
        }
        print("Instrument callback luotu")
    }
    
    
    
    
    
    // MARK: TRACK FUNCTIONS
    
    func newPattern(res: Int) {
        
        let pat = TPattern(resoltn: res)
        patterns.append(pat)
        
        pat.stps.forEach { stp in
            
            stp.patternNum = patterns.count-1
            stp.trackNum = trackNo
        }
        print("NewPattern. Track length: \(self.patterns.count)")
      //  sequencerTrack.length += 8.0
        updateAKTrack()
        
    }
    
    func insertPattern(pat: TPattern, toPage: Int) {
        
        patterns.insert(pat, at: toPage)
       // sequencerTrack.length += 8.0
        updateAKTrack()
    }
    
    func copyPattern(fromPage: Int, toPage: Int) {
        
        if patterns.count < fromPage {
        
            let pat = patterns[fromPage]
            let newPat = TPattern(resoltn: res)
                
            for i in 0..<res {
                
                let note = pat.stps[i].note
                let vel = pat.stps[i].vel
                let dur = pat.stps[i].dur
                let bind = pat.stps[i].bind
                let long = pat.stps[i].long
                
                newPat.stps[i].note = note
                newPat.stps[i].vel = vel
                newPat.stps[i].dur = dur
                newPat.stps[i].bind = bind
                newPat.stps[i].long = long
            
            }
            
            insertPattern(pat: newPat, toPage: toPage)
             updateAKTrack()
        }
        
    }
    
    
    func movePattern(fromPage: Int, toPage: Int) {
        
        var pat:TPattern
        if patterns.count < fromPage {
            
            pat = patterns[fromPage]
            deletePattern(fromPage: fromPage)
            insertPattern(pat: pat, toPage: toPage)
            updateAKTrack()
        }
    }
    
    
    func deletePattern(fromPage: Int) {
        
        if patterns.count < fromPage {
            patterns.remove(at: fromPage)
           // sequencerTrack.length -= 8.0
            updateAKTrack()
        }
    }
    

    
    
    // MARK: Update AKTrack
    
    func updateAKTrack() {
        
        let start = playArea[0]
        let end = start + playArea[1]
        
        sequencerTrack.clear()
        sequencerTrack.length = Double(playArea[1]) * 8.0
        
        print("SEQTRACK LENGTH: \(sequencerTrack.length)")
        
        var p = 0.0
        
        for i in start..<end {
           
            
            let stpRes = 8.0/Double(res)
            
            print("AK UPDATE. TRACK Nro: \(self.trackNo)")
            print("AK UPDATE. P Count: \(patterns.count)")
            print("AK UPDATE. i  =  \(i)")
            print("AK UPDATE. Bool  \(patterns.count > i)")
           
            if patterns.count > i {
            patterns[i].stps.forEach { stp in
               
                if stp.note != nil {
                    let pos = (stpRes * Double(stp.stpNum!))+(p*8.0)
                    print("add noute: \(pos)")
                    sequencerTrack.add(noteNumber: stp.note!, velocity: stp.vel!, channel: MIDIChannel(trackNo), position: pos, duration: getDur(step: stp))
                    
                    if pos+getDur(step: stp) > sequencerTrack.length {
                        
                        makeNoteOff(step: stp)
                        
                    }
                    
                }
                else {//print("Ei nuottia???")}
                    }
                
                }
            }
            
            p += 1.0
            
        }
    }
    
    func makeNoteOff(step: TStep) {
       
        let nte = step.note!
        let ve = step.vel!
        //let noteDur = 8.0 / res
        let thisNote = step.stpNum!
        let pat = patterns[step.patternNum!]
        var patternCount = 0
        var nextNote = 0
        if thisNote < 31 {nextNote = pat.stps[thisNote+1].stpNum!}
        
             else {nextNote = 0; patternCount += 1}
    
        while pat.stps[nextNote].note == nil {
            
            if nextNote < res - 1 {
            nextNote += 1
            
            } else {nextNote = 0}
            
        }
        
        let positionForOff =  pat.stps[nextNote].stpNum! * 0.25 + 0.1
        
        
        let event = AKMIDIEvent(noteOff: nte, velocity: ve, channel: MIDIChannel(0))
        sequencerTrack.add(event: event, position: positionForOff)
        print(event)
    }
    
    
    // MARK: GET DURATION Func
    func getDur(step: TStep) -> Double {
        
        let thisNote = step.stpNum!
        var dur = 0.0
        var patternCount = 0
        let pat = patterns[step.patternNum!]
        
        switch step.bind {
        
        case true:
            var nextNote = 0
            if thisNote < 31 {nextNote = step.stpNum! + 1}
            else { nextNote = 0; patternCount += 1 }
            
            while pat.stps[nextNote].note == nil {
                if nextNote < res-1 {
              nextNote += 1
                } else { nextNote = 0; patternCount += 1 }
            }
            
            dur = (((patternCount * 32 + nextNote) - thisNote) * 0.25) + 0.2
            

        
        case false: dur = step.dur!
        
        
        }
        return dur
    }
    
    
    
    
    
}
