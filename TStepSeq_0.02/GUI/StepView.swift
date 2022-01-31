//
//  StepView.swift
//  TStepSeq_0.02
//
//  Created by Taito Kantomaa on 25.3.2021.
//

import Foundation
import UIKit


protocol stepViewDelegate {
    
    func updateTracks(page: Int)
    func nextRecStep()
    
}


class StepView: UIView, stepViewDelegate {
    
    
    var seqButtons:[[SeqButton]] = []
    var tracks:[UIStackView] = []
    var verticalStack = UIStackView(frame: .zero)
    var playlist:TPlaylist!
    var pattern: TPattern!
    var paage:Int!
    
   
    
    
    init(plylist: TPlaylist) {
        
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(verticalStack)
       //  self.backgroundColor = UIColor(named: "Color3")
        
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        verticalStack.axis = .vertical
        verticalStack.alignment = .center
        verticalStack.distribution = .equalSpacing
        verticalStack.spacing = 5
        
        verticalStack.widthAnchor.constraint(equalTo: self.widthAnchor, constant: 0).isActive = true
        // verticalStack.heightAnchor.constraint(equalTo: self.heightAnchor, constant: 0).isActive = true
        
        playlist = plylist
        paage = playlist.viewPage
        createTracks(page: paage)
        
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Create TRACKS
    
    func createTracks(page: Int) {
        
        print("CreateTracks!  Track Count: \(playlist.tracks.count)")
        playlist.recTrack = -1
        playlist.recStep = -1
        playlist.tracks.forEach { trc in
            
            print("Create GUI track: \(trc.trackNo)")
            print("patterns: \(trc.patterns.count)")
            
            if trc.trackNo != 0 {
                if trc.patterns.count > page {
                   
                    createSteps(pat: trc.patterns[page])
                
            } else  {
                
                createDumpSteps()
                
                }
            }
        }
    
        verticalStack.setNeedsUpdateConstraints()
        verticalStack.setNeedsLayout()
        
    }
        
    
    
    // MARK: Create STEPS
    
    func createSteps(pat: TPattern) {
        
        var btns:[SeqButton] = []
        let trackStack = UIStackView(frame: .zero)
        trackStack.translatesAutoresizingMaskIntoConstraints = false
        
        
        trackStack.alignment = .center
        trackStack.distribution = .fillEqually
        trackStack.spacing = 3
        
        
        if pat.resolution != nil {
        for i in 0..<pat.resolution! {
            
            let btn = SeqButton(frame: .zero)
            btn.tStep = pat.stps[i]
            btn.stepNro = i
            
        
            if pat.stps[i].note != nil {
                
                if pat.stps[i].bind == true {
                    
                    btn.SEQBtnState = 4
                    btn.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1) }
                else {
                btn.SEQBtnState = 1
                btn.backgroundColor = UIColor(named: "Color3")
                }
            } else {
                btn.SEQBtnState = 0
                btn.backgroundColor = UIColor(named: "SeqBtnColor")
            }
            
            
            btn.addTarget(self, action: #selector(seqBtnPressed(sender:)), for: .touchDown)
            btns.append(btn)
            
            trackStack.addArrangedSubview(btn)
            tracks.append(trackStack)
        
            }
            
            seqButtons.append(btns)
            
        verticalStack.addArrangedSubview(trackStack)
            trackStack.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -2).isActive = true
            trackStack.heightAnchor.constraint(equalToConstant: 45).isActive = true
            
            
        }
        
    }
    
   
    
    // MARK: SeqBTNPressed Func
    
    @objc func seqBtnPressed(sender: SeqButton) {
        
        
        switch sender.SEQBtnState {
        
        case 0:
            
            if playlist.selectedTrack == sender.tStep.trackNum! {
            
            playlist.tracks.forEach { trc in
            
            if trc.trackNo != 0 {
            
            let trNo = trc.trackNo
            
           
                seqButtons[trNo-1].forEach { seqBtn in
            
                if seqBtn.SEQBtnState == 2 {
                  
                    seqBtn.SEQBtnState = 0
                    seqBtn.tStep.rec = false
                    seqBtn.backgroundColor = UIColor(named: "SeqBtnColor")
                    }
                }
         
            }
            
        }
                sender.backgroundColor = UIColor(named: "Color4")
                sender.SEQBtnState = 2
                sender.tStep.rec = true
                playlist.recording = true
                playlist.recTrack = sender.tStep.trackNum!
                playlist.recStep = sender.tStep.stpNum!
                unSelectTrack()
                selectTrack(track: sender.tStep.trackNum!)
                print("REcTrack & Step : \(playlist.recTrack), \(playlist.recStep)")
            } else {
                
                unSelectTrack()
                selectTrack(track: sender.tStep.trackNum!)
                
            }
    
        case 1:
           // BIND TRUE
            if playlist.selectedTrack == sender.tStep.trackNum! {
            
                sender.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
                sender.SEQBtnState = 4
                sender.tStep.bind = true
                
                
            playlist.updateTracks()
            } else {
                unSelectTrack()
                selectTrack(track: sender.tStep.trackNum!)
                
            }
            
            
        case 2:
            
            if sender.tStep.note == nil {
            
            sender.SEQBtnState = 0
            sender.backgroundColor = UIColor(named: "SeqBtnColor")
            sender.tStep.rec = false
            playlist.recording = false
            unSelectTrack()
            } else {
                
                if sender.tStep.bind == true {
                    sender.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
                    sender.SEQBtnState = 4
                    sender.tStep.rec = false
                    playlist.recording = false
                    unSelectTrack()
                    }
                else {
                    
                    sender.tStep.rec = false
                    playlist.recording = false
                    unSelectTrack()
                    sender.SEQBtnState = 1
                    sender.backgroundColor = UIColor(named:"Color3")
                    
                    
                }
                
            }
            
        case 3: print("Tyhjää on")
       
        case 4:
            if playlist.selectedTrack == sender.tStep.trackNum! {
                
                
                sender.backgroundColor = UIColor(named: "SeqBtnColor")
                sender.SEQBtnState = 0
                sender.tStep.note = nil
                sender.tStep.vel = nil
                sender.tStep.dur = nil
                sender.tStep.long = false
                sender.tStep.bind = false
                playlist.updateTracks()
                
            } else {
                
                unSelectTrack()
                selectTrack(track: sender.tStep.trackNum!)
                
            }
            
            
        default: print("Dumpstep")
        
        
        
        }
       
    }
    
    
    // MARK: DumpSteps
    
    func createDumpSteps() {
        
        let trackStack = UIStackView(frame: .zero)
        var btns:[SeqButton] = []
        trackStack.translatesAutoresizingMaskIntoConstraints = false
        trackStack.alignment = .center
        trackStack.distribution = .fillEqually
        trackStack.spacing = 3
        
        for i in 0..<32 {
            
            let btn = SeqButton(frame: .zero)
            btn.stepNro = i
            btn.SEQBtnState = 1
            btn.backgroundColor = UIColor(named: "BackgroundColor")
            btn.layer.borderWidth = 2
            btn.layer.borderColor = CGColor(red: 0.1067029908, green: 0.2628778219, blue: 0.2801513374, alpha: 1)
           
            btn.addTarget(self, action: #selector(dumpBtnPressed(sender:)), for: .touchDown)
            btns.append(btn)
            
            trackStack.addArrangedSubview(btn)
            tracks.append(trackStack)
        }
            seqButtons.append(btns)
             verticalStack.addArrangedSubview(trackStack)
            trackStack.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -2).isActive = true
            trackStack.heightAnchor.constraint(equalToConstant: 45).isActive = true
            
            
        }
    
    
    @objc func dumpBtnPressed(sender: SeqButton) {
        
        
        
        print("dumpBtnPressed")
        if playlist.recStep != -1 && playlist.recTrack != -1 {
        nextRecStep()
        }
    }
    
    
    // MARK: NEXT REC STEP FUNC
    
    func nextRecStep() {
        
        if !playlist.recording {return}
        
        var next = TStep()
        var nextBtn = SeqButton()
        let current = playlist.tracks[playlist.recTrack].patterns[playlist.viewPage].stps[playlist.recStep]
        
        if playlist.recStep + 1 < 32 {
        
            next = playlist.tracks[playlist.recTrack].patterns[playlist.viewPage].stps[playlist.recStep+1]
            nextBtn = seqButtons[playlist.recTrack-1][current.stpNum!+1]
        
        } else {
            
            next = playlist.tracks[playlist.recTrack].patterns[playlist.viewPage].stps[0]
            nextBtn = seqButtons[playlist.recTrack-1][0]
        }
        
        seqButtons[playlist.recTrack-1].forEach {btn in
            
            btn.tStep.rec = false
             if btn.tStep.note != nil {
                
                btn.SEQBtnState = 1
                btn.backgroundColor = UIColor(named: "Color3")
            } else {
                btn.SEQBtnState = 0
                btn.backgroundColor = UIColor(named: "SeqBtnColor")
                
            }
            
            
         /*   if btn.SEQBtnState == 2 {
                btn.tStep.rec = false
                btn.SEQBtnState = 0
                btn.backgroundColor = UIColor(named: "SeqBtnColor")
                
            }*/
        }
        
        
        
        next.rec = true
        nextBtn.SEQBtnState = 2
        nextBtn.backgroundColor = UIColor(named: "Color4")
        if playlist.recStep + 1 < 32 {playlist.recStep += 1} else {playlist.recStep = 0}
    
    }
    
    
    
    
    func prevRecStep() {}
    

    func unSelectTrack() {
        
        playlist.selectedTrack = -1
        
        seqButtons.forEach { trc in
            trc.forEach { btn in
                
                btn.layer.borderWidth = 2
                btn.layer.borderColor = #colorLiteral(red: 0.1067029908, green: 0.2628778219, blue: 0.2801513374, alpha: 1)
                btn.layer.shadowOffset = CGSize(width: 0, height: 0)
                btn.layer.shadowRadius = 0
            }
        }
        print("Selected TRACK: \(playlist.selectedTrack)")
    }
    
    func selectTrack(track: Int) {
        
        playlist.selectedTrack = track
        seqButtons[track-1].forEach { btn in
            
            btn.layer.borderWidth = 2
            btn.layer.borderColor = #colorLiteral(red: 0.9803921569, green: 0.9215686275, blue: 0.8392156863, alpha: 1)
            btn.layer.shadowColor = #colorLiteral(red: 0.9803921569, green: 0.9215686275, blue: 0.8392156863, alpha: 1)
            btn.layer.shadowRadius = 4
            btn.layer.shadowOffset = CGSize(width: 4, height: 4)
            
            
        }
        print("Selected Track: \(playlist.selectedTrack)")
    }
    
    
    // MARK: Update Tracks
    
    func updateTracks(page: Int) {
        paage = page
        seqButtons = []
        
        tracks.forEach { trc in
            trc.removeFromSuperview()
            }
        tracks = []
        
        createTracks(page: page)
        
        playlist.updateTracks()
        
        if playlist.selectedTrack != -1 {
            
            selectTrack(track: playlist.selectedTrack)
            
            
        }
        
    }
        
        
    
    
    
    
    
    
    
    
}
