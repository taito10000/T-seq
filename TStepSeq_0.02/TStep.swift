//
//  TStep.swift
//  TStepSeq_0.02
//
//  Created by Taito Kantomaa on 18.3.2021.
//

import Foundation
import AudioKit

class TStep {
    
    var note:MIDINoteNumber?
    var vel:MIDIVelocity?
    var dur: Double?
    var stpNum: Int?
    var patternNum: Int?
    var trackNum: Int?
    
    var long = false
    var bind = false
    var rec = false
    
    
    
    func toggleBindNote() {if !self.bind {self.bind = true} else {self.bind = false}}
    func toggleLongNote() {if !self.long {self.long = true} else {self.long = false}}
    
    
    
    func octaveDown() {if self.note!-12 > 0 {self.note = self.note! - 12 } else {print("EI VOI LASKEA SÄVELTÄ")}}
    func octaveUp() {if self.note!+12 < 128 {self.note = self.note! + 12 } else {print("EI VOI NOSTAA SÄVELTÄ")}}
    
    
    
    
    
}
