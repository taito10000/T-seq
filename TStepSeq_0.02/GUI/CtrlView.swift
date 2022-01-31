//
//  CtrlView.swift
//  TStepSeq_0.02
//
//  Created by Taito Kantomaa on 25.3.2021.
//

import Foundation
import UIKit



class CtrlView: UIView {
    
    
    var playa:TPlayer!
    var playlist:TPlaylist!
    let playImg = UIImage(named: "play_blc")
    let stopImg = UIImage(named: "stop_blc")
    let pauseImg = UIImage(named: "toStart")
    let rewImg = UIImage(named: "rew_blc")
    let ffwdImg = UIImage(named: "ffwd_blc")
    let loopImg = UIImage(named: "loop_light")
    let playBtn = CTRLButton(frame: .zero)
    let stopBtn = CTRLButton(frame: .zero)
    let rewBtn = CTRLButton(frame: .zero)
    let ffdBtn = CTRLButton(frame: .zero)
    let loopBtn = CTRLButton(frame: .zero)
    var delegate:stepViewDelegate?
    let tempoView = UILabel(frame: .zero)
    let ctrlsStack = UIStackView(frame: .zero)
    
    init(plylist: TPlaylist, player: TPlayer) {
        
        super.init(frame: .zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
       // self.backgroundColor = #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)
        playlist = plylist
        playa = player
        setupCtrlButtons()
        setupTempo()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK:  SETUP Ctrl Btns Func
    
    func setupCtrlButtons() {
        
        
        ctrlsStack.translatesAutoresizingMaskIntoConstraints = false
        ctrlsStack.alignment = .center
        ctrlsStack.distribution = .fillEqually
        ctrlsStack.spacing = 15
        self.addSubview(ctrlsStack)
        
        ctrlsStack.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        ctrlsStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 40).isActive = true
        ctrlsStack.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.85).isActive = true
        
        
        
       // ctrlsStack.addArrangedSubview(rewBtn)
        ctrlsStack.addArrangedSubview(playBtn)
        ctrlsStack.addArrangedSubview(stopBtn)
        //ctrlsStack.addArrangedSubview(ffdBtn)
        ctrlsStack.addArrangedSubview(loopBtn)
        
        playBtn.addTarget(self, action: #selector(playButtonPressed(sender:)), for: .touchUpInside)
        playBtn.setImage(playImg, for: .normal)
        
        playBtn.imageEdgeInsets = UIEdgeInsets(top: 7, left: 15, bottom: 7, right: 7)
        
        stopBtn.addTarget(self, action: #selector(stopButtonPressed(sender:)), for: .touchUpInside)
        stopBtn.setImage(stopImg, for: .normal)
        stopBtn.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        
       /* rewBtn.addTarget(self, action: #selector(rewButtonPressed(sender:)), for: .touchUpInside)
        rewBtn.setImage(rewImg, for: .normal)
        rewBtn.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        
        
        ffdBtn.addTarget(self, action: #selector(ffdButtonPressed(sender:)), for: .touchUpInside)
        ffdBtn.setImage(ffwdImg, for: .normal)
        ffdBtn.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        */
        
        loopBtn.addTarget(self, action: #selector(loopButtonPressed(sender:)), for: .touchUpInside)
        loopBtn.setImage(loopImg, for: .normal)
        loopBtn.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        loopBtn.layer.borderWidth = 7
        loopBtn.layer.borderColor = #colorLiteral(red: 0.9529411793, green: 0.9180997803, blue: 0.2443921599, alpha: 0.3826200978)
        
        self.setNeedsUpdateConstraints()
        self.setNeedsLayout()
    }
    
    func setupTempo() {
        
        let stepper = UIStepper(frame: .zero)
        
        
        stepper.minimumValue = 1
        stepper.maximumValue = 240
        stepper.value = 120
        stepper.stepValue = 1
        stepper.addTarget(self, action: #selector(tempoBtnsPressed(sender:)), for: .valueChanged)
        
        
        tempoView.font = UIFont(name: "Avenir", size: 35)
        tempoView.textAlignment = .center
        tempoView.textColor = UIColor(named: "SeqBtnBorderSelected")
        tempoView.text = String(format: "%.0f", playa.seq.tempo)
        ctrlsStack.addArrangedSubview(tempoView)
        ctrlsStack.addArrangedSubview(stepper)
        tempoView.translatesAutoresizingMaskIntoConstraints = false
        tempoView.widthAnchor.constraint(equalToConstant: 140).isActive = true
        tempoView.heightAnchor.constraint(equalToConstant: 60).isActive = true
       /* stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.widthAnchor.constraint(equalToConstant: 70).isActive = true
        stepper.heightAnchor.constraint(equalToConstant: 70).isActive = true*/
        stepper.layer.setAffineTransform(CGAffineTransform(scaleX: 1.3, y: 1.6))
        stepper.backgroundColor = UIColor(named: "SeqBtnColor")
        stepper.layer.cornerRadius = 10
    }
    
    @objc func tempoBtnsPressed(sender: UIStepper) {
        
        print("Tempo BTNS: \(sender.value)")
        playa.seq.tempo = sender.value
        let str = String(format: "%.0f", playa.seq.tempo)
        //playa.seq.tempo = sender.value
        tempoView.text = str
        
        
        
    }
    
    
    
    // MARK: PLAY Btn pressed
    
    @objc func playButtonPressed(sender: CTRLButton){
        
        switch sender.CTRLButtonState {
        
        case 0 : sender.CTRLButtonState = 1
            playlist.playing = true
            // playBtn.backgroundColor =
            playBtn.layer.borderWidth = 5
            playBtn.layer.borderColor = #colorLiteral(red: 0.9529411793, green: 0.9243353828, blue: 0.4248665955, alpha: 0.5047807504)
            playBtn.layer.shadowColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            playBtn.layer.shadowOffset = CGSize(width: 5, height: 5)
            playBtn.layer.shadowRadius = 9
            stopBtn.CTRLButtonState = 0
            stopBtn.setImage(stopImg, for: .normal)
            playa.seq.play()
            
        case 1 : print("Allreafy playing")
            
        default: print("Nyt jotain kummaa !!!")
        
        
        }
        
        
    }
    
    
    // MARK: STOP btn pressed
    
    @objc func stopButtonPressed(sender: CTRLButton){
        
       
        switch sender.CTRLButtonState {
        
        case 0:
            playBtn.CTRLButtonState = 0
            playlist.playing = false
            playBtn.layer.borderWidth = 1
            playBtn.backgroundColor = UIColor(named: "Color3")
            playBtn.layer.shadowOffset = CGSize(width: 0, height: 0)
            playBtn.layer.shadowRadius = 0
            playa.seq.pause()
            playa.stopAllNotes()
            stopBtn.setImage(pauseImg, for: .normal)
            stopBtn.CTRLButtonState = 1
            
        case 1:
            playBtn.CTRLButtonState = 0
            playlist.playing = false
            playBtn.layer.borderWidth = 0
            playa.seq.stop()
            playa.stopAllNotes()
            stopBtn.CTRLButtonState = 0
            stopBtn.setImage(stopImg, for: .normal)
            playa.seq.rewind()
       
            
        default: print("")
        }
   
    
    
    
    }
    
    // MARK:  REW btn pressed
    
    @objc func rewButtonPressed(sender: CTRLButton){
        
        var currentView = playlist.viewPage
        if currentView - 1 >= 0 {
            
            currentView -= 1
            
        }
        print("REW view: \(currentView)")
        playlist.viewPage = currentView
        delegate?.updateTracks(page: currentView)
        
    }
    
    
    // MARK: FFD Btn pressed
    
    @objc func ffdButtonPressed(sender: CTRLButton){
        
        var currentView = playlist.viewPage
        if currentView + 1 < playlist.longestTrack() {
            
            currentView += 1
            
        }
        print("FFD view: \(currentView)")
        playlist.viewPage = currentView
        delegate?.updateTracks(page: currentView)
        
    }
    
    // MARK:  Loop Btn pressed
    
    @objc func loopButtonPressed(sender: CTRLButton){
        
        switch sender.CTRLButtonState {
        
        case 0:
            sender.CTRLButtonState = 1
            playlist.looping = false
            loopBtn.layer.borderWidth = 0
            
        case 1:
            sender.CTRLButtonState = 0
            playlist.looping = true
            loopBtn.layer.borderWidth = 7
            loopBtn.layer.borderColor = #colorLiteral(red: 0.9529411793, green: 0.9180997803, blue: 0.2443921599, alpha: 0.3826200978)
            
            
        default: print("")
        }
        
        
    }
}

