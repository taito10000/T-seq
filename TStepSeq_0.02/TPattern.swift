//
//  TPattern.swift
//  TStepSeq_0.02
//
//  Created by Taito Kantomaa on 18.3.2021.
//

import Foundation
import AudioKit



class TPattern {
    
    var resolution: Int?
    var stps: [TStep] = []
    var inited = false
   
    
    init(resoltn: Int) {
        
        resolution = resoltn
        
        if resolution != nil {
            for i in 0..<resolution! {
            
            let stp = TStep()
                stp.stpNum = i
            stps.append(stp)
            }
        inited = true
            } else {print("EI RESOLUTIOTA ASETETTU UUDELLE PATTERNILLE")}
       
        
    }
    
    
    func replaceStep(stp: Int, note: Int, vel: Int, dur: Double) {
        
        stps[stp].note = MIDINoteNumber(note)
        stps[stp].vel = MIDIVelocity(vel)
        stps[stp].dur = dur
        stps[stp].bind = false
        stps[stp].long = false
        
    }
    
    func clearStep(stp: Int) {
        
        stps[stp].note = nil
        stps[stp].vel = nil
        stps[stp].dur = nil
        stps[stp].bind = false
        stps[stp].long = false
        
    }
    
    func bindStep(stp: Int) {
        
        // poista nuotin NOTE_OFF viesti.
        stps[stp].toggleBindNote()
    }
    
    func longStep(stp: Int) {
        
        stps[stp].toggleLongNote()
    }


    func clearPattern() {
        
        if resolution != nil && inited {
            
            stps.forEach { (stp) in
               
                if stp.stpNum != nil {
                clearStep(stp: stp.stpNum!)
                    }
                }
            
            }
        }
    
    func testPattern() {
        
        var rand = 60 // Int.random(in: 60...80)
        
        if resolution != nil && inited {
            
            for i in 0..<resolution! {
                
                rand = Int.random(in: 60...80)
                stps[i].note = MIDINoteNumber(rand)
                stps[i].vel = MIDIVelocity(100)
                stps[i].dur = 0.24
    
            }
        }
    }
    
    
    
    
    
    
    
    func allNotesOctaveUp() {self.stps.forEach{stp in stp.octaveUp()}}
    func allNotesOctaveDown() {self.stps.forEach{stp in stp.octaveDown()}}
    
    
    
    }











