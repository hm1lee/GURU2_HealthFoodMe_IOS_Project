//
//  Utilities.swift
//  customauth
//
//  Created by Christopher Ching on 2019-05-09.
//  Copyright © 2019 Christopher Ching. All rights reserved.
//

import Foundation
import UIKit

class Utilities {
    
    static func styleTextField(_ textfield:UITextField) {
        
        // Create the bottom line
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 2)
        
        bottomLine.backgroundColor = UIColor(displayP3Red: 249/255, green: 243/255, blue: 237/255, alpha: 1).cgColor
        
        // Remove border on text field
        textfield.borderStyle = .none
        
        // Add the line to the text field
        textfield.layer.addSublayer(bottomLine)
        
    }
    
    
    static func styleFilledButton(_ button:UIButton) {
        button.backgroundColor = UIColor(displayP3Red: 249/255, green: 243/255, blue: 237/255, alpha: 1)
        button.tintColor = UIColor.white
        button.layer.cornerRadius = 25.0 // 디자인
    }
    
    static func styleHollowButton(_ button:UIButton) {
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor(displayP3Red: 249/255, green: 243/255, blue: 237/255, alpha: 1).cgColor
        button.tintColor = UIColor.black
        button.layer.cornerRadius = 25.0 // 디자인
    }
    
    static func isPasswordValid(_ password : String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }

}
