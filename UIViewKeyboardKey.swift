//
//  UIViewKeyboardKey.swift
//  keyboard-201606220-01
//
//  Created by rocker on 20160630.
//  Copyright © 2016 rocker. All rights reserved.
//

import UIKit

class UIViewKeyboardKey: UIView {
    
    var label = ""

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    /*
    override func drawRect(rect: CGRect) {
        
        // set the font to Helvetica Neue 18
        let fieldFont = UIFont(name: "Helvetica Neue", size: 18)
        
        
        var attributes: NSDictionary = [
            NSFontAttributeName: fieldFont!
        ]
        
        self.label.drawInRect(CGRectMake(5.0, 5.0, 15.0, 25.0), withAttributes: attributes as! [String : AnyObject])
    }
 */
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 5.0
        self.backgroundColor = UIColor.lightGrayColor()
        var label = UILabel(frame: CGRectMake(5.0, 5.0, 15.0, 25.0))
        label.text = self.label
        self.addSubview(label)
    }
}
