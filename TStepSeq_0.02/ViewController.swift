//
//  ViewController.swift
//  TStepSeq_0.02
//
//  Created by Taito Kantomaa on 18.3.2021.
//

import UIKit

class ViewController: UIViewController {

    
    var playlist = TPlaylist(resolution: 32)
    var gui:GUI!
    // var apuVC = SettingsVC()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let player = TPlayer(pllist: playlist)
        let recorder = TRecorder(plylist: playlist)
        
        
        
        player.playlist.addTrack(trcNum: 0)
        player.playlist.addTrack(trcNum: 1)
        player.playlist.addTrack(trcNum: 2)
        player.playlist.tracks[0].newPattern(res: 32)
        player.playlist.tracks[1].newPattern(res: 32)
        player.playlist.tracks[2].newPattern(res: 32)
        
        
        player.playlist.tracks[0].patterns[0].testPattern()
        player.playlist.tracks[1].patterns[1].testPattern()
        player.playlist.tracks[1].newPattern(res: 32)
        
        //player.playlist.tracks[2].newPattern(res: 32)
        player.setup()
        playlist.changePlayArea(start: 1, length: 1)
        player.updateMixer(forTrack: 0)
        player.updateMixer(forTrack: 1)
        player.updateMixer(forTrack: 2)
        gui = GUI(plylist: playlist, playa: player)
        
        recorder.delegate = gui.stepView
        gui.keyboard.recDelegate = recorder
        
        view.addSubview(gui)
        
        player.startManager()
        // player.seq.play()
        
        // gui.showKeyboard()
        
        
       
    }

    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
       
        
        coordinator.animate(alongsideTransition: nil) { (context) in
            
            
            self.gui.updateView()
            self.view.setNeedsUpdateConstraints()
            self.view.setNeedsLayout()
            
            
            // self.present(self.apuVC, animated: true, completion: nil)
            
        }
    
  }
}

