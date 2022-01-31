//
//  AKSoftKeys.swift
//  TStepSeq_0.02
//
//  Created by Taito Kantomaa on 4.4.2021.
//

import Foundation
import UIKit
import AudioKitUI
import AudioKit

class AKSoftKeys: UIView, AKKeyboardDelegate {
    
    
    var keys = AKKeyboardView()
    var playlist: TPlaylist!
    var player: TPlayer!
    var midiChan:MIDIChannel!
    var widthConst = NSLayoutConstraint()
    var heightConst = NSLayoutConstraint()
    var xConst = NSLayoutConstraint()
    var yConst = NSLayoutConstraint()
    var keysImg = UIImage(named: "keys_light")
    var midiOnImg = UIImage(named: "midi_on")
    var midiOffImg = UIImage(named: "midi_off")
    var spaceImg = UIImage(named: "space")
    var verticalStack: UIStackView!
    var btnStack: UIStackView!
    var edgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    var guiDelegate: GUIDelegate?
    var stepDelegate: stepViewDelegate?
    var recDelegate:recStepDelegate?
    
    init(plylist: TPlaylist, playa: TPlayer) {
        
        super.init(frame: .zero)
        playlist = plylist
        player = playa
        
        self.translatesAutoresizingMaskIntoConstraints = false
        // self.addSubview(keys)
        keys.delegate = self
        keys.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        verticalStack = UIStackView(frame: self.bounds)
        verticalStack.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        verticalStack.axis = .vertical
        verticalStack.alignment = .center
        verticalStack.distribution = .fillProportionally
        verticalStack.spacing = 20
        btnStack = UIStackView(frame: .zero)
        btnStack.alignment = .center
        btnStack.distribution = .equalSpacing
        
        setupStacks()
        
        
        
        
        verticalStack.addArrangedSubview(btnStack)
        verticalStack.addArrangedSubview(keys)
        
        self.addSubview(verticalStack)
        
        
        
        keys.octaveCount = 2
        keys.firstOctave = 1
        keys.whiteKeyOff = #colorLiteral(red: 0.9803921569, green: 0.9215686275, blue: 0.8392156863, alpha: 1)
        keys.keyOnColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        keys.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        keys.layer.shadowOffset = CGSize(width: 4.0, height: 4.0)
        keys.layer.shadowRadius = 10
        keys.layer.shadowOpacity = 0.8
        
        
        
        self.isHidden = true
        midiChan = MIDIChannel(1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func noteOn(note: MIDINoteNumber) {
        
        if playlist.midiThru {
            
            player.playNote(note: note, vel: MIDIVelocity(100), chan: midiChan)
        }
        if playlist.recording {
        
            recDelegate?.recStep(note: note, vel: MIDIVelocity(100))
        }
        
    }
    func noteOff(note: MIDINoteNumber) {
        if playlist.midiThru {
            
            player.stopNote(note: note, vel: MIDIVelocity(100), chan: midiChan)
            
        }
    }
    
    
    
    func setupStacks() {
        
        btnStack.heightAnchor.constraint(equalToConstant: 60).isActive = true
        btnStack.spacing = 80
       
        let keysBtn = CTRLButton()
        keysBtn.addTarget(self, action: #selector(keysBtnPressed(sender:)), for: .touchUpInside)
        keysBtn.setImage(keysImg, for: .normal)
        keysBtn.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        keysBtn.widthAnchor.constraint(equalToConstant: 60).isActive = true
       
        let midiThruBtn = CTRLButton()
        midiThruBtn.addTarget(self, action: #selector(midiThruBtnPressed(sender:)), for: .touchUpInside)
        midiThruBtn.widthAnchor.constraint(equalToConstant: 60).isActive = true
        midiThruBtn.backgroundColor = UIColor(named: "SeqBtnColor")
        midiThruBtn.setImage(midiOffImg, for: .normal)
        midiThruBtn.imageEdgeInsets = edgeInsets
        
        let spaceBtn = CTRLButton()
        spaceBtn.widthAnchor.constraint(equalToConstant: 60).isActive = true
        spaceBtn.heightAnchor.constraint(equalToConstant: 60).isActive = true
        spaceBtn.addTarget(self, action: #selector(spaceBtnPressed(sender:)), for: .touchUpInside)
        spaceBtn.setImage(spaceImg, for: .normal)
        spaceBtn.imageEdgeInsets = edgeInsets
        
        let octaveDownBtn = CTRLButton()
        let octaveUpBtn = CTRLButton()
        octaveDownBtn.setTitle("-8", for: .normal)
        octaveUpBtn.setTitle("+8", for: .normal)
        octaveDownBtn.CTRLButtonState = 0
        octaveUpBtn.CTRLButtonState = 1
        octaveDownBtn.addTarget(self, action: #selector(octaveBtnPressed(sender:)), for: .touchUpInside)
        octaveUpBtn.addTarget(self, action: #selector(octaveBtnPressed(sender:)), for: .touchUpInside)
        
        btnStack.addArrangedSubview(octaveDownBtn)
        btnStack.addArrangedSubview(keysBtn)
        btnStack.addArrangedSubview(spaceBtn)
        btnStack.addArrangedSubview(midiThruBtn)
        btnStack.addArrangedSubview(octaveUpBtn)
    }
    
    @objc func octaveBtnPressed(sender: CTRLButton) {
        
        switch sender.CTRLButtonState {
        
        case 0: if keys.firstOctave > 2 { keys.firstOctave -= 1 }
        case 1: if keys.firstOctave < 9 { keys.firstOctave += 1 }
        default: print("OctaveBtn ERROR!")
        
        
        
        }
        
        
        
        
    }
    
    @objc func keysBtnPressed(sender: CTRLButton) {
        
        guiDelegate?.hideKeyboard()
        
    }
    @objc func midiThruBtnPressed(sender: CTRLButton) {
        
        switch playlist.midiThru {
        
            case true: sender.CTRLButtonState = 1
            case false: sender.CTRLButtonState = 0
        
            }
        switch sender.CTRLButtonState {
            
        case 1: playlist.midiThru = false
            sender.CTRLButtonState = 0
            sender.backgroundColor = #colorLiteral(red: 0.1067029908, green: 0.2628778219, blue: 0.2801513374, alpha: 1)
            sender.setImage(midiOffImg, for: .normal)
        case 0: playlist.midiThru = true
            sender.CTRLButtonState = 1
            sender.backgroundColor = UIColor(named: "Color3")
            sender.setImage(midiOnImg, for: .normal)
            
        default: print("MIDITHRUBTN ERROR!")
        }
       
        
    }
    @objc func spaceBtnPressed(sender: CTRLButton) {
        
        stepDelegate?.nextRecStep()
        
    }
    
    
}
