//
//  TPlaylist.swift
//  TStepSeq_0.02
//
//  Created by Taito Kantomaa on 18.3.2021.
//

import Foundation
import AudioKit
import CoreMIDI


class TPlaylist {
    
    var tracks:[TTrack] = []
    let maxTracks = 4   // RunnerTrack vie 0-paikan !!!
    var playArea:[Int] = [0,1]
    var selectedTrack = -1
    var viewPage = 2
    var playPage = 0
    var playing = false
    var looping = true
    var recording = false
    var midiThru = false
    var pagesTotal = 0
    var res = 0
    var mxrDelegate: mixerDelegate?
    var recTrack = 1
    var recStep = 0
    
    
    
    // RUNNERTRACK tulee viemään Nollapaikan
   
    var sequencerInstruments:[AKCallbackInstrument] = []
    
    
    var grid:[[Int]] = []
    
    // var rec = false
    // var midiThru = false
    
    init(resolution: Int) {
        
        res = resolution
        
        
    }
    
    
    // MARK: Track Functions
    
    func addTrack(trcNum: Int) {
        
        if trcNum <= maxTracks {
        let trc = TTrack(trackNumber: trcNum, resolution: res, plArea: playArea)
           
            tracks.append(trc)
       
            tracks.forEach { (trc) in
                
                while trc.patterns.count < longestTrack() {
                    
                    trc.newPattern(res: res)
                   
                }
                
            }
            pagesTotal = longestTrack()
            mxrDelegate?.updateMixer(forTrack: trcNum)
        }
        
        else {print("MaxTrack tullut täyteen!!! Uutta träkkiä ei luoda")}
        
    }
    
    
    func removeTrack(trcNum: Int) {
        
        tracks.remove(at: trcNum)
        sequencerInstruments.remove(at: trcNum)
        
    }
    
    //MARK: Change PlayArea
    
    func changePlayArea(start: Int, length: Int) {
        if start >= 0 && length > 0 {
            if start + length <= longestTrack() {
        
                playArea = [start, length]
                tracks.forEach { trc in
                    trc.playArea = playArea
                    trc.updateAKTrack()
                }
            } else {print("Trackit lyhyempiä kuin tavoiteltu playArea")}
        } else {print("length tai track liian pieni!!!")}
    }
    
    
    
    
    
    
    // MARK: Create Instrument For Track
    
    
    
    func createInstrumentForTrack(trkNro: Int) {
        
        if trkNro == 0 {createRunnerInst()}
        
        if 0 < trkNro && trkNro <= 4 {
        let inst = AKCallbackInstrument()
        inst.callback = {status, note, vel in
        
            print("CallBack")
            
        }
        
        sequencerInstruments.append(inst)
            tracks[trkNro].sequencerTrack.setTarget(node: sequencerInstruments[trkNro])
            print("Instrumentti luotu trackille: \(trkNro)")
        
        }
    }
    
    func createRunnerInst() {
        
        let inst = AKCallbackInstrument()
        inst.callback = {status, note, vel in
            
            print("Runner. Run Runner Run")
            
           
        }
        tracks[0].sequencerTrack.setTarget(node: inst)
        print("Runner Instrumentti Luotu")
    }
    
    
    
    

    
    
    
    // MARK: Helper Functions
    
    
    func longestTrack() -> Int {
       
        var longest = 1
        tracks.forEach { trc in
            
            if trc.patterns.count > longest {
                
                longest = trc.patterns.count
                
            }
        }
        return longest
    }
    
    
    func updateTracks() {
        
        tracks.forEach { trc in
            trc.updateAKTrack()
        }
        
        
        
    }
    
    
    
}

