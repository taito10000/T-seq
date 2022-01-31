//
//  EditView.swift
//  TStepSeq_0.02
//
//  Created by Taito Kantomaa on 25.3.2021.
//

import Foundation
import UIKit



protocol editViewDelegate {
    
    func updatePlayAreaView()
        
}





class EditView: UIView, editViewDelegate {
    
    
    var playlist: TPlaylist!
    var delegate: stepViewDelegate?
    var labelDele: labelDelegate?
    var guiDelegate: GUIDelegate?
    var playa: TPlayer!
    
    var mainStack: UIStackView!
    var leftSubStack: UIStackView!
    var centerSubStack: UIStackView!
    var rightSubStack: UIStackView!
    var upDownArrowStack: UIStackView!
    var upDownArrowStack2: UIStackView!
   
    let playPageLabelStack = UIStackView(frame: .zero)
    let playLengthLabelStack = UIStackView(frame: .zero)
    let playPageBtnStack = UIStackView(frame: .zero)
    let playLengthBtnStack = UIStackView(frame: .zero)
    
    var playPageNumLabel = UILabel()
    var playLengthNumLabel = UILabel()
    var rightCtrlBtns = UIStackView(frame: .zero)
    var leftCtrlBtns = UIStackView(frame: .zero)
    let keysImg = UIImage(named: "keys_light")
    let settingsImg = UIImage(named: "settings_blc")
    let upImg = UIImage(named: "arrow_up")
    let downImg = UIImage(named: "arrow_down")
    let rewImg = UIImage(named: "prev")
    let ffdImg = UIImage(named: "next")
    let imgEgdes = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    let textColor = UIColor(named: "SeqBtnBorderSelected")
    //let textColor = UIColor(named: "Color3")
    
    let editBtnColor = UIColor(named: "SeqBtnColor")
    
    init(plylist: TPlaylist, player: TPlayer) {
        
        super.init(frame: .zero)
        
        playlist = plylist
        playa = player
        
        
        self.translatesAutoresizingMaskIntoConstraints = false
       // self.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        mainStack = UIStackView(frame: .zero)
        leftSubStack = UIStackView(frame: .zero)
        centerSubStack = UIStackView(frame: .zero)
        rightSubStack = UIStackView(frame: .zero)
        self.addSubview(mainStack)
        
        mainStack.alignment = .center
        mainStack.distribution = .equalSpacing
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        mainStack.widthAnchor.constraint(equalTo: self.widthAnchor , multiplier: 1).isActive = true
        mainStack.addArrangedSubview(leftSubStack)
        mainStack.addArrangedSubview(centerSubStack)
        mainStack.addArrangedSubview(rightSubStack)
        setupCenterStack()
        setupRightStack()
        setupLeftStack()
        self.setNeedsLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: SETUP CENTER Func
    func setupCenterStack() {
        
        
        let strt = playlist.playArea[0]
        let len = playlist.playArea[1]
        
        centerSubStack.alignment = .center
        centerSubStack.distribution = .equalCentering
        centerSubStack.frame = CGRect(width: 200, height: 100)
        centerSubStack.spacing = 25
        
        
        centerSubStack.addArrangedSubview(playPageBtnStack)
        centerSubStack.addArrangedSubview(playPageLabelStack)
        centerSubStack.addArrangedSubview(playLengthLabelStack)
        centerSubStack.addArrangedSubview(playLengthBtnStack)
        
        playLengthLabelStack.axis = .vertical
        playLengthLabelStack.alignment = .center
        playLengthLabelStack.distribution = .fillProportionally
        playLengthLabelStack.spacing = 10
        
        playPageLabelStack.axis = .vertical
        playPageLabelStack.alignment = .center
        playPageLabelStack.distribution = .fillProportionally
        playPageLabelStack.spacing = 10
        
        playPageBtnStack.axis = .vertical
        playPageBtnStack.alignment = .center
        playPageBtnStack.distribution = .equalCentering
        playPageBtnStack.spacing = 5
        
        playLengthBtnStack.axis = .vertical
        playLengthBtnStack.alignment = .center
        playLengthBtnStack.distribution = .equalCentering
        playLengthBtnStack.spacing = 5
        
        let playPageUpBtn = CTRLButton(frame: .zero)
        playPageUpBtn.setImage(upImg, for: .normal)
        playPageUpBtn.imageEdgeInsets = imgEgdes
        playPageUpBtn.backgroundColor = editBtnColor
        playPageUpBtn.CTRLButtonState = 0
        playPageUpBtn.addTarget(self, action: #selector(playPageBtnPressed(sender:)), for: .touchUpInside)
        
        let playPageDownBtn = CTRLButton(frame: .zero)
        playPageDownBtn.setImage(downImg, for: .normal)
        playPageDownBtn.imageEdgeInsets = imgEgdes
        playPageDownBtn.backgroundColor = editBtnColor
        playPageDownBtn.CTRLButtonState = 1
        playPageDownBtn.addTarget(self, action: #selector(playPageBtnPressed(sender:)), for: .touchUpInside)
        
        let playPageLabel = UILabel(frame: CGRect(width: 100, height: 50))
        playPageLabel.text = "START"
        playPageLabel.textAlignment = .center
        playPageLabel.font = UIFont(name: "Avenir", size: 30)
        playPageLabel.textColor = textColor
        
        playPageNumLabel = UILabel(frame: .zero)
        playPageNumLabel.text = "\(strt)"
        playPageNumLabel.textAlignment = .center
        playPageNumLabel.font = UIFont(name: "Times", size: 80)
        playPageNumLabel.textColor = textColor
        
        let playLengthLabel = UILabel(frame: CGRect(width: 100, height: 50))
        playLengthLabel.text = "LENGTH"
        playLengthLabel.textAlignment = .center
        playLengthLabel.font = UIFont(name: "Avenir", size: 30)
        playLengthLabel.textColor = textColor
        
        playLengthNumLabel = UILabel(frame: .zero)
        playLengthNumLabel.text = "\(len)"
        playLengthNumLabel.textAlignment = .center
        playLengthNumLabel.font = UIFont(name: "Times", size: 80)
        playLengthNumLabel.textColor = textColor
        
        let playLengthUpBtn = CTRLButton(frame: .zero)
        playLengthUpBtn.setImage(upImg, for: .normal)
        playLengthUpBtn.imageEdgeInsets = imgEgdes
        playLengthUpBtn.backgroundColor = editBtnColor
        playLengthUpBtn.CTRLButtonState = 0  // State 0 ylös, 1 alas
        playLengthUpBtn.addTarget(self, action: #selector(playLengthBtnPressed(sender:)), for: .touchUpInside)
        
        let playLengthDownBtn = CTRLButton(frame: .zero)
        playLengthDownBtn.setImage(downImg, for: .normal)
        playLengthDownBtn.imageEdgeInsets = imgEgdes
        playLengthDownBtn.backgroundColor = editBtnColor
        playLengthDownBtn.CTRLButtonState = 1
        playLengthDownBtn.addTarget(self, action: #selector(playLengthBtnPressed(sender:)), for: .touchUpInside)
        
        playPageBtnStack.addArrangedSubview(playPageUpBtn)
        playPageBtnStack.addArrangedSubview(playPageDownBtn)
        playPageLabelStack.addArrangedSubview(playPageLabel)
        playPageLabelStack.addArrangedSubview(playPageNumLabel)
        playLengthLabelStack.addArrangedSubview(playLengthLabel)
        playLengthLabelStack.addArrangedSubview(playLengthNumLabel)
        playLengthBtnStack.addArrangedSubview(playLengthUpBtn)
        playLengthBtnStack.addArrangedSubview(playLengthDownBtn)
        
        
        self.needsUpdateConstraints()
        self.setNeedsLayout()
        
        
    }
    
    
    
    
    // MARK: UPDATE Center labels
    func updatePlayAreaView() {
        
        DispatchQueue.main.async {
            
            self.playPageNumLabel.text = "\(self.playlist.playArea[0])"
            self.playLengthNumLabel.text = "\(self.playlist.playArea[1])"
        }
        
    }
    

    // MARK: PlayPageBtnPressed
    @objc func playPageBtnPressed(sender: CTRLButton) {
        
        print("PlayPageBtn STATE : \(sender.CTRLButtonState)")
        let current = playlist.playArea[0]
        let length = playlist.playArea[1]
        let next = current + 1
        let previous = current - 1
        
        switch sender.CTRLButtonState {
        
        case 0: playlist.changePlayArea(start: next, length: length)
                updatePlayAreaView()
               
        case 1: playlist.changePlayArea(start: previous, length: length)
                updatePlayAreaView()
            
        
        default: print("EditView / playPageBtnPressed ERROR")
    
        }
    }
    
    // MARK: PlayLengthBtnPressed
    @objc func playLengthBtnPressed(sender: CTRLButton) {
        
        print("playLength  STATE : \(sender.CTRLButtonState)")
        let current = playlist.playArea[1]
        let page = playlist.playArea[0]
        let next = current + 1
        let previous = current - 1
        
        switch sender.CTRLButtonState {
        case 0: playlist.changePlayArea(start: page, length: next)
            updatePlayAreaView()
        case 1: playlist.changePlayArea(start: page, length: previous)
            updatePlayAreaView()
       
        default: print("EditView / playLengthBtnPressed ERROR")
        
        }
    }

    
    // MARK: SETUP RIGHT stack
    func setupRightStack() {
        
        let edge = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        rightSubStack.alignment = .center
        rightSubStack.distribution = .equalCentering
        rightSubStack.translatesAutoresizingMaskIntoConstraints = false
        rightSubStack.spacing = 5
        rightSubStack.isLayoutMarginsRelativeArrangement = true
        rightSubStack.layoutMargins = edge
       
        rightCtrlBtns.axis = .vertical
        rightCtrlBtns.alignment = .leading
        rightCtrlBtns.distribution = .equalSpacing
        rightCtrlBtns.spacing = 5
        rightSubStack.addArrangedSubview(rightCtrlBtns)
        rightCtrlBtns.translatesAutoresizingMaskIntoConstraints = false
         
        let ffdBtn = CTRLButton(frame: .zero)
        ffdBtn.addTarget(self, action: #selector(ffdButtonPressed(sender:)), for: .touchUpInside)
        ffdBtn.setImage(ffdImg, for: .normal)
        ffdBtn.imageEdgeInsets = UIEdgeInsets(top: 20, left: 25, bottom: 20, right: 10)

        
        let newPatternBtn = CTRLButton(frame: .zero)
        let clearPatternBtn = CTRLButton(frame: .zero)
        newPatternBtn.setTitle("✦", for: .normal)
        newPatternBtn.titleLabel?.font = UIFont(name: "Menlo", size: 55)
        newPatternBtn.addTarget(self, action: #selector(newPatternBtnPressed(sender:)), for: .touchUpInside)
        clearPatternBtn.addTarget(self, action: #selector(clearPatternBtnPressed(sender:)), for: .touchUpInside)
        clearPatternBtn.setTitle("✗", for: .normal)
        clearPatternBtn.titleLabel?.font = UIFont(name: "Arial", size: 40)
        
        let label = UILabel(frame: CGRect(width: 40, height: 15))
        
        
        rightCtrlBtns.addArrangedSubview(ffdBtn)
        rightCtrlBtns.addArrangedSubview(label)
        rightCtrlBtns.addArrangedSubview(newPatternBtn)
        rightCtrlBtns.addArrangedSubview(clearPatternBtn)
        
        
        
    }
    
    // MARK: newPatternBtnPressed
    @objc func newPatternBtnPressed(sender: CTRLButton) {
        
        let trc = playlist.selectedTrack
        var page = playlist.viewPage
        
        if trc > 0 {
        
        playlist.tracks[trc].newPattern(res: playlist.res)
        page = playlist.tracks[trc].patterns.count - 1
        playlist.viewPage = page
        delegate?.updateTracks(page: page)
        } else {
            var longest = 0
            
            playlist.tracks.forEach { trc in
                if trc.patterns.count > longest {
                    longest = trc.patterns.count
                }
            }
            
            for i in 1..<playlist.tracks.count {
                
                while playlist.tracks[i].patterns.count < longest {
                    
                    playlist.tracks[i].newPattern(res: playlist.res)
                    
                }
                
                
            }
            
            for i in 1..<playlist.tracks.count {
                
                playlist.tracks[i].newPattern(res: playlist.res)
                
            }
        }
    }
    
    
    // MARK: clearPatternBtnPressed
    @objc func clearPatternBtnPressed(sender: CTRLButton) {
        
      
    
        let trc = playlist.selectedTrack
        let page = playlist.viewPage
        
        if playlist.selectedTrack > 0 {
        playlist.tracks[trc].patterns[page].clearPattern()
        delegate?.updateTracks(page: page)
        }
        
        else {print("clearPatternBTN: No Pattern selected")}
        
    }
    
    
    
    // MARK: SETUP Left Stack
    func setupLeftStack() {
        
        let edge = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        let imgInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        leftSubStack.alignment = .center
        leftSubStack.distribution = .equalCentering
        leftSubStack.translatesAutoresizingMaskIntoConstraints = false
        leftSubStack.spacing = 5
        leftSubStack.isLayoutMarginsRelativeArrangement = true
        leftSubStack.layoutMargins = edge
       
        leftCtrlBtns.axis = .vertical
        leftCtrlBtns.alignment = .leading
        leftCtrlBtns.distribution = .equalSpacing
        leftCtrlBtns.spacing = 5
        leftSubStack.addArrangedSubview(leftCtrlBtns)
        leftCtrlBtns.translatesAutoresizingMaskIntoConstraints = false
        
        let rewBtn = CTRLButton(frame: .zero)
         rewBtn.addTarget(self, action: #selector(rewButtonPressed(sender:)), for: .touchUpInside)
         rewBtn.setImage(rewImg, for: .normal)
         rewBtn.imageEdgeInsets = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 25)
        
        let keysBtn = CTRLButton(frame: .zero)
        let settingsBtn = CTRLButton(frame: .zero)
        
        keysBtn.setImage(keysImg, for: .normal)
        keysBtn.imageEdgeInsets = imgInsets
        keysBtn.addTarget(self, action: #selector(keysBtnPressed(sender:)), for: .touchUpInside)
        settingsBtn.setImage(settingsImg, for: .normal)
        settingsBtn.imageEdgeInsets = imgInsets
        settingsBtn.addTarget(self, action: #selector(settingsBtnPressed(sender:)), for: .touchUpInside)
        
        
        let label = UILabel(frame: CGRect(width: 40, height: 15))
        
        leftCtrlBtns.addArrangedSubview(rewBtn)
        leftCtrlBtns.addArrangedSubview(label)
        leftCtrlBtns.addArrangedSubview(settingsBtn)
        leftCtrlBtns.addArrangedSubview(keysBtn)
        
        
    }
    
    @objc func keysBtnPressed(sender: CTRLButton) {
        
        guiDelegate?.showKeyboard()
        
        
    }
    @objc func settingsBtnPressed(sender: CTRLButton) {}
    
    
    
    
    // MARK: REWBtn Pressed
    @objc func rewButtonPressed(sender: CTRLButton){
        
        var currentView = playlist.viewPage
        if currentView - 1 >= 0 {
            
            currentView -= 1
    
        }
    
        print("REW view: \(currentView)")
        playlist.viewPage = currentView
        delegate?.updateTracks(page: currentView)
        labelDele?.updateLabel()
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
        labelDele?.updateLabel()
    }
    
}

 
 
 
