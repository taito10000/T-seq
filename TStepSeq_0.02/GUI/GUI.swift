//
//  GUI.swift
//  TStepSeq_0.02
//
//  Created by Taito Kantomaa on 18.3.2021.
//

import Foundation
import UIKit

protocol GUIDelegate {
    
    func hideKeyboard()
    func showKeyboard()
    
}

class GUI: UIView, GUIDelegate {
    
    var playlist:TPlaylist!
    var player:TPlayer!
    var widthConst = NSLayoutConstraint()
    var heightConst = NSLayoutConstraint()
    var screen = UIScreen.main.bounds
    
    var stepViewXConst = NSLayoutConstraint()
    var stepViewYConst = NSLayoutConstraint()
    var stepViewWidthConst = NSLayoutConstraint()
    var stepViewHeigthConst = NSLayoutConstraint()
    
    var editViewXConst = NSLayoutConstraint()
    var editViewYConst = NSLayoutConstraint()
    var editViewWidthConst = NSLayoutConstraint()
    var editViewHeigthConst = NSLayoutConstraint()
    
    var ctrlViewXConst = NSLayoutConstraint()
    var ctrlViewYConst = NSLayoutConstraint()
    var ctrlViewWidthConst = NSLayoutConstraint()
    var ctrlViewHeigthConst = NSLayoutConstraint()
    
    var keysXconst = NSLayoutConstraint()
    var keysYconst = NSLayoutConstraint()
    var keysWidthConst = NSLayoutConstraint()
    var keysHeightConst = NSLayoutConstraint()
    
    
    var lab:PageLabel!
    var stepView:StepView!
    var editView:EditView!
    var ctrlView:CtrlView!
    var keyboard: AKSoftKeys!
   
    
    init(plylist: TPlaylist, playa: TPlayer) {
        
        super.init(frame: screen)
        
        playlist = plylist
        player = playa
        lab = PageLabel(plylist: playlist)
        stepView = StepView(plylist: plylist)
        editView = EditView(plylist: plylist, player: player)
        ctrlView = CtrlView(plylist: plylist, player: player)
        keyboard = AKSoftKeys(plylist: plylist, playa: player)
       
        // MARK: SET DELEGATES!
        ctrlView.delegate = stepView
        editView.delegate = stepView
        editView.labelDele = lab
        editView.guiDelegate = self
        keyboard.guiDelegate = self
        keyboard.stepDelegate = stepView
        
        self.addSubview(lab)
        self.addSubview(stepView)
        self.addSubview(editView)
        self.addSubview(ctrlView)
        self.addSubview(keyboard)
        
        // MARK: Set Constraints
        stepViewXConst = stepView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        stepViewYConst = stepView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 75)
        stepViewWidthConst = stepView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -30)
        stepViewHeigthConst = stepView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.3 )
        
        
        editViewXConst = editView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        editViewYConst = editView.topAnchor.constraint(equalTo: stepView.bottomAnchor, constant: 0)
        editViewWidthConst = editView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: 0)
        editViewHeigthConst = editView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.25)
        
        ctrlViewXConst = ctrlView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        ctrlViewYConst = ctrlView.topAnchor.constraint(equalTo: editView.bottomAnchor, constant: 0)
        ctrlViewWidthConst = ctrlView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.6)
        ctrlViewHeigthConst = ctrlView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.2)
        
        keysXconst = keyboard.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        keysYconst = keyboard.topAnchor.constraint(equalTo: ctrlView.bottomAnchor, constant: 0)
        keysWidthConst = keyboard.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.95)
        keysHeightConst = keyboard.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.35)
        
        
        
        
        
        // MARK: Activate Constraints
        stepViewXConst.isActive = true
        stepViewYConst.isActive = true
        stepViewWidthConst.isActive = true
        stepViewHeigthConst.isActive = true
        
        editViewXConst.isActive = true
        editViewYConst.isActive = true
        editViewWidthConst.isActive = true
        editViewHeigthConst.isActive = true
        
        ctrlViewXConst.isActive = true
        ctrlViewYConst.isActive = true
        ctrlViewWidthConst.isActive = true
        ctrlViewHeigthConst.isActive = true
        
        keysXconst.isActive = true
        keysYconst.isActive = true
        keysWidthConst.isActive = true
        keysHeightConst.isActive = true
        
        translatesAutoresizingMaskIntoConstraints = false
        
        heightConst = self.heightAnchor.constraint(equalToConstant: screen.height)
        widthConst = self.widthAnchor.constraint(equalToConstant: screen.width)
        
    
        heightConst.isActive = true
        widthConst.isActive = true
        self.backgroundColor = UIColor(named: "BackgroundColor")
    
        
        
        updateView()
        
    

    }
    
    
    
    
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
   
    
    }
    
    // MARK: HIDE & SHOW Stacks
    
    func hideKeyboard() {
        
        editView.isHidden = false
        ctrlViewYConst.isActive = false
        ctrlViewYConst = ctrlView.topAnchor.constraint(equalTo: editView.bottomAnchor, constant: 0)
        
        keyboard.isHidden = true
        ctrlViewYConst.isActive = true
        self.setNeedsUpdateConstraints()
        self.setNeedsLayout()
        
        
    }
    
    
    func showKeyboard() {
        
        // editView pois ja ctrl ylöspäin ja keys kiinni ctrl
        editView.isHidden = true
        ctrlViewYConst.isActive = false
        ctrlViewYConst = ctrlView.topAnchor.constraint(equalTo: stepView.bottomAnchor, constant: 0)
        
        keyboard.isHidden = false
        ctrlViewYConst.isActive = true
        self.setNeedsUpdateConstraints()
        self.setNeedsLayout()
        
    }
    
    
// MARK: UpdateView -  GUI
    
    func updateView() {
        
        let bounds = UIScreen.main.bounds
        widthConst.constant = bounds.width
        heightConst.constant = bounds.height
        self.lab.updateLabel()
        self.setNeedsUpdateConstraints()
        self.setNeedsLayout()
        
    }
    
    

}





