//
//  ConstraintMaker.swift
//  keyboard-201606220-01
//
//  Created by rocker on 20160718.
//  Copyright © 2016 rocker. All rights reserved.
//

import UIKit

class ConstraintMaker {
    
    static func addButtonConstraintsToRow(buttons: [UIView], widths: [CGFloat?] = [], sideSpace: CGFloat = 0, topSpace: CGFloat = 0, bottomSpace: CGFloat = 0, betweenSpace: CGFloat = 0, containingView: UIView) {
        var constraints = [NSLayoutConstraint]()
        var equalWidthButtons = [UIView]()
        
        for (index, button) in buttons.enumerate() {
            
            // set width or save button for later
            if widths.count != 0 && widths[index] != nil {
                let widthConstraint = NSLayoutConstraint(item: button, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: widths[index]!)
                constraints.append(widthConstraint)
            } else {
                // save equalWidthButtons for later
                equalWidthButtons.append(button)
            }
            
            // set top and bottom constraints
            // top and bottom constraints are same for all buttons
            let topConstraint = NSLayoutConstraint(item: button, attribute: .Top, relatedBy: .Equal, toItem: containingView, attribute: .Top, multiplier: 1.0, constant: topSpace)
            constraints.append(topConstraint)
            
            let bottomConstraint = NSLayoutConstraint(item: button, attribute: .Bottom, relatedBy: .Equal, toItem: containingView, attribute: .Bottom, multiplier: 1.0, constant: -1.0 * bottomSpace)
            constraints.append(bottomConstraint)
            
            // set left constraint depending on whether button is leftmost or not
            var leftConstraint: NSLayoutConstraint!
            if index == 0 {
                leftConstraint = NSLayoutConstraint(item: button, attribute: .Left, relatedBy: .Equal, toItem: containingView, attribute: .Left, multiplier: 1.0, constant: sideSpace)
            } else {
                leftConstraint = NSLayoutConstraint(item: button, attribute: .Left, relatedBy: .Equal, toItem: buttons[index - 1], attribute: .Right, multiplier: 1.0, constant: betweenSpace)
            }
            constraints.append(leftConstraint)
            
            // set right constraint depending on whether button is rightmost or not
            if index == buttons.count - 1 {
                let rightConstraint = NSLayoutConstraint(item: button, attribute: .Right, relatedBy: .Equal, toItem: containingView, attribute: .Right, multiplier: 1.0, constant: -1.0 * sideSpace)
                constraints.append(rightConstraint)
            }
        }
        
        // set width on all equal width buttons equal
        for button in equalWidthButtons {
            let widthConstraint = NSLayoutConstraint(item: equalWidthButtons[0], attribute: .Width, relatedBy: .Equal, toItem: button, attribute: .Width, multiplier: 1.0, constant: 0)
            constraints.append(widthConstraint)
        }
        
        // activate all constraints
        NSLayoutConstraint.activateConstraints(constraints)
    }
    
    static func addRowConstraintsToSuperview(rows: [[UIView]], sideSpace: CGFloat = 0, topSpace: CGFloat = 0, bottomSpace: CGFloat = 0, betweenSpace: CGFloat = 0, containingView: UIView) {
        
        var constraints = [NSLayoutConstraint]()
        
        for (index, row) in rows.enumerate() {
            
            for rowInstance in row {
            
                // set height
                let heightConstraint = NSLayoutConstraint(item: rows[0][0], attribute: .Height, relatedBy: .Equal, toItem: rowInstance, attribute: .Height, multiplier: 1.0, constant: 0)
                constraints.append(heightConstraint)
            
                // set side constraints
                // side constraints are same for all rows
                let leftConstraint = NSLayoutConstraint(item: rowInstance, attribute: .Left, relatedBy: .Equal, toItem: containingView, attribute: .Left, multiplier: 1.0, constant: sideSpace)
                let rightConstraint = NSLayoutConstraint(item: rowInstance, attribute: .Right, relatedBy: .Equal, toItem: containingView, attribute: .Right, multiplier: 1.0, constant: -1 * sideSpace)
                constraints.append(leftConstraint)
                constraints.append(rightConstraint)
            
                // set top constraint
                var topConstraint: NSLayoutConstraint
                if (index == 0) {
                    topConstraint = NSLayoutConstraint(item: rowInstance, attribute: .Top, relatedBy: .Equal, toItem: containingView, attribute: .Top, multiplier: 1.0, constant: topSpace)
                } else {
                    topConstraint = NSLayoutConstraint(item: rowInstance, attribute: .Top, relatedBy: .Equal, toItem: rows[index - 1][0], attribute: .Bottom, multiplier: 1.0, constant: betweenSpace)
                }
                constraints.append(topConstraint)
            
                // set bottom constraint
                if (index == rows.count - 1) {
                    let bottomConstraint = NSLayoutConstraint(item: rowInstance, attribute: .Bottom, relatedBy: .Equal, toItem: containingView, attribute: .Bottom, multiplier: 1.0, constant: -1 * bottomSpace)
                    constraints.append(bottomConstraint)
                }
            }
        }
        
        // activate all constraints
        NSLayoutConstraint.activateConstraints(constraints)
    }
}