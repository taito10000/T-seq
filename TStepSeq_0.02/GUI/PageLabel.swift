//
//  PageLabel.swift
//  TStepSeq_0.02
//
//  Created by Taito Kantomaa on 4.4.2021.
//

import Foundation
import UIKit


protocol labelDelegate {
    
    
    func updateLabel()
    
    
}


class PageLabel: UIView, labelDelegate {
    
    var label = UILabel()
    var playlist:TPlaylist!
    var heightConst = NSLayoutConstraint()
    var widthConst = NSLayoutConstraint()
    var height = UIScreen.main.bounds.height
    var width = UIScreen.main.bounds.width
    
    
    
    init(plylist: TPlaylist) {
        
        super.init(frame: UIScreen.main.bounds)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        heightConst = self.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 2)
        widthConst = self.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height)
        heightConst.isActive = true
        widthConst.isActive = true
        
        
        
        
        playlist = plylist
        label.text = "\(playlist.viewPage)"
        label.frame = CGRect(width: width, height: height/2)
        label.font = UIFont(name: "Times", size: 400)
        label.textColor = #colorLiteral(red: 0.2005113335, green: 0.1953437918, blue: 0.1851579651, alpha: 1)
        label.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.layer.shadowOffset = CGSize(width: 4, height: 4)
        label.layer.shadowRadius = 10
        label.layer.shadowOpacity = 0.5
        label.textAlignment = .center
        self.addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateLabel() {
        
        
        heightConst = self.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 2.5)
        widthConst = self.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height)
        
        height = UIScreen.main.bounds.height
        width = UIScreen.main.bounds.width
        label.frame = CGRect(width: width, height: height/2.5)
        label.text = "\(playlist.viewPage)"
        
        self.setNeedsUpdateConstraints()
        self.setNeedsLayout()
    }
    
    
}
