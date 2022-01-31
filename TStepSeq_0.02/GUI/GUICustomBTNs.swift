//
//  GUICustomBTNs.swift
//  tSeq_AK4
//
//  Created by Taito Kantomaa on 1.3.2021.
//

import Foundation
import UIKit


extension UIStackView {
    func addBackground(color: UIColor, radius: CGFloat, border: CGFloat, borderColor: UIColor) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.layer.cornerRadius = radius
        subView.layer.borderWidth = border
        subView.layer.borderColor = borderColor.cgColor
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        subView.layer.opacity = 0.7
        
        insertSubview(subView, at: 0)
    }

    func changeBackground(col: UIColor) {
        
        
        self.subviews[0].backgroundColor = col
        
    }



}

class SeqButton: UIButton {
    
    override init(frame: CGRect) {
           super.init(frame: frame)
           setup()
       }
       
       required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
           fatalError("init(coder:) has not been implemented")
       }
        var tStep = TStep()
        var SEQBtnState = 0
        var col = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.5)
        var stepNro = -1
        var pattern = -1
    
    private func setup(){
           
           self.layer.cornerRadius = 4
           self.backgroundColor = UIColor.lightGray
           self.setTitleColor(UIColor.white, for: .normal)
           self.setTitleColor(UIColor.red, for: .highlighted)
           /*self.addConstraint(NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0))*/
           self.translatesAutoresizingMaskIntoConstraints = false
           self.heightAnchor.constraint(equalTo: self.widthAnchor).isActive = true
            self.widthAnchor.constraint(lessThanOrEqualToConstant: 40).isActive = true
            
       }
    
}

class CTRLButton: UIButton {
    
    override init(frame: CGRect) {
              super.init(frame: frame)
              setup()
          }
          
          required init?(coder aDecoder: NSCoder) {
              super.init(coder: aDecoder)
              fatalError("init(coder:) has not been implemented")
          }
          
          var CTRLButtonState = 0
             
            var col = UIColor(red: 1, green: 1, blue: 1, alpha: 0.1)
    
            private func setup() {
              
            
              self.layer.cornerRadius = 12
              self.backgroundColor = UIColor(named: "Color3")
              self.setTitleColor(UIColor(named: "BackgroundColor"), for: .normal)
              self.setTitleColor(UIColor.white, for: .highlighted)
              self.titleEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
              
              self.translatesAutoresizingMaskIntoConstraints = false
              self.widthAnchor.constraint(lessThanOrEqualToConstant: 70).isActive = true
               
                
               
            self.heightAnchor.constraint(equalTo: self.widthAnchor).isActive = true
            self.titleLabel?.font = UIFont(name: "Arial", size: 21)
            self.setTitleShadowColor(col, for: .highlighted)
            self.titleLabel?.shadowOffset = CGSize(width: 4, height: 3)
            
            self.layer.shadowOffset = CGSize(width: 3, height: 4)
            self.layer.shadowColor = UIColor.darkGray.cgColor
            self.layer.shadowRadius = 8
            self.layer.shadowOpacity = 0.4
            
               
          }
    
    
    
}

