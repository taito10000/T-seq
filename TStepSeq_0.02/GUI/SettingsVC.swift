//
//  SettingsVC.swift
//  TStepSeq_0.02
//
//  Created by Taito Kantomaa on 19.4.2021.
//

import Foundation
import UIKit


class SettingsVC:  UIViewController {
    
    let box = UIView(frame: .zero)
   
    override func loadView() {
       
        view = UIView()
        view.backgroundColor = UIColor.lightGray
        
        
        box.frame = CGRect(width: 100, height: 100)
        box.backgroundColor = UIColor.red
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        
        
        view.addSubview(box)
        
    
    }
    
}





