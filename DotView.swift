//
//  DotView.swift
//  keyboard-201606220-01
//
//  Created by rocker on 20160830.
//  Copyright © 2016 rocker. All rights reserved.
//

import UIKit

class DotView: UIView {
    
    override func drawRect(rect: CGRect) {
        let path =  UIBezierPath(ovalInRect: rect)
        UIColor.greenColor().setFill()
        path.fill()
    }

}
