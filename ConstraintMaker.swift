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
    
    static func addAllButtonConstraints(topRowView: UIView, midRowView: UIView, bottomRowView: UIView, utilRowView: UIView, topLetters: [UIView], midLetters: [UIView], bottomLettersShiftBackspace: [UIView], utilKeys: [UIView], topNumbers: [UIView], midNumbers: [UIView], bottomPuncAndNumbersPuncKey: [UIView], topPuncs: [UIView], midPuncs: [UIView], topTouchLetters: [UIView], midTouchLetters: [UIView], bottomTouchLettersShiftBackspace: [UIView], utilTouchKeys: [UIView], topTouchNumbers: [UIView], midTouchNumbers: [UIView], bottomTouchPuncAndNumbersPuncKey: [UIView], topTouchPuncs: [UIView], midTouchPuncs: [UIView], betweenSpace: CGFloat = 0) {
        
        // touch buttons
        
        addTouchButtonConstraints(topRowView, midRowView: midRowView, bottomRowView: bottomRowView, utilRowView: utilRowView, topLetters: topTouchLetters, midLetters: midTouchLetters, bottomLettersShiftBackspace: bottomTouchLettersShiftBackspace, utilKeys: utilTouchKeys, topNumbers: topTouchNumbers, midNumbers: midTouchNumbers, bottomPuncAndNumbersPuncKey: bottomTouchPuncAndNumbersPuncKey, topPuncs: topTouchPuncs, midPuncs: midTouchPuncs)
        
        // display buttons
        
        // topRow
        
        addButtonConstraintsToRow(topLetters, betweenSpace: 2, containingView: topRowView)
        addButtonConstraintsToRow(topNumbers, betweenSpace: 2, containingView: topRowView)
        addButtonConstraintsToRow(topPuncs, betweenSpace: 2, containingView: topRowView)
        
        // midRow
        
        midLetters[4].centerXAnchor.constraintEqualToAnchor(midRowView.centerXAnchor).active = true
        for (i, button) in midLetters.enumerate() {
            if i != 0 {
                button.leftAnchor.constraintEqualToAnchor(midLetters[i - 1].rightAnchor, constant: betweenSpace).active = true
            }
            // all buttons in row get this
            button.widthAnchor.constraintEqualToAnchor(topLetters[0].widthAnchor).active = true
            button.topAnchor.constraintEqualToAnchor(midRowView.topAnchor).active = true
            button.bottomAnchor.constraintEqualToAnchor(midRowView.bottomAnchor).active = true
        }
        // starting here next time 20160803 22:33
        // I'm writing constraint for the display buttons
        // I think the block above should have successfully set the constraints on the midletters
    }
    
    static func addTouchButtonConstraints(topRowView: UIView, midRowView: UIView, bottomRowView: UIView, utilRowView: UIView, topLetters: [UIView], midLetters: [UIView], bottomLettersShiftBackspace: [UIView], utilKeys: [UIView], topNumbers: [UIView], midNumbers: [UIView], bottomPuncAndNumbersPuncKey: [UIView], topPuncs: [UIView], midPuncs: [UIView]) {
        
        //topRow
        
        addButtonConstraintsToRow(topLetters, containingView: topRowView)
        addButtonConstraintsToRow(topNumbers, containingView: topRowView)
        addButtonConstraintsToRow(topPuncs, containingView: topRowView)
        
        // midRow
        
        for (i, button) in midLetters.enumerate() {
            if i == 0 {
                button.leftAnchor.constraintEqualToAnchor(midRowView.leftAnchor).active = true
                button.rightAnchor.constraintEqualToAnchor(midLetters[i + 1].leftAnchor).active = true
            } else {
                if i == midLetters.count - 1 {
                    button.rightAnchor.constraintEqualToAnchor(midRowView.rightAnchor).active = true
                    button.leftAnchor.constraintEqualToAnchor(midLetters[i - 1].rightAnchor).active = true
                } else {
                    button.rightAnchor.constraintEqualToAnchor(midLetters[i + 1].leftAnchor).active = true
                }
                // default case
                // this line sets the width of these keys in the middle to the same width
                // as the letters in the top row
                button.widthAnchor.constraintEqualToAnchor(topLetters[0].widthAnchor).active = true
            }
            // all buttons in row get this
            button.topAnchor.constraintEqualToAnchor(midRowView.topAnchor).active = true
            button.bottomAnchor.constraintEqualToAnchor(midRowView.bottomAnchor).active = true
        }
        
        addButtonConstraintsToRow(midNumbers, containingView: midRowView)
        addButtonConstraintsToRow(midPuncs, containingView: midRowView)
        
        // bottomRow
        
        for (i, button) in bottomLettersShiftBackspace.enumerate() {
            if i == 0 {
                button.leftAnchor.constraintEqualToAnchor(bottomRowView.leftAnchor).active = true
            } else {
                if i == bottomLettersShiftBackspace.count - 1 {
                    button.rightAnchor.constraintEqualToAnchor(bottomRowView.rightAnchor).active = true
                    button.widthAnchor.constraintEqualToAnchor(bottomLettersShiftBackspace[0].widthAnchor).active = true
                } else {
                    button.widthAnchor.constraintEqualToAnchor(topLetters[0].widthAnchor).active = true
                }
                button.leftAnchor.constraintEqualToAnchor(bottomLettersShiftBackspace[i - 1].rightAnchor).active = true
            }
            // all buttons in row get this
            button.topAnchor.constraintEqualToAnchor(bottomRowView.topAnchor).active = true
            button.bottomAnchor.constraintEqualToAnchor(bottomRowView.bottomAnchor).active = true
        }
        
        for (i, button) in bottomPuncAndNumbersPuncKey.enumerate() {
            if i == 0 {
                button.leftAnchor.constraintEqualToAnchor(bottomRowView.leftAnchor).active = true
                button.widthAnchor.constraintEqualToAnchor(bottomLettersShiftBackspace[0].widthAnchor).active = true
            } else {
                if i == bottomPuncAndNumbersPuncKey.count - 1 {
                    button.rightAnchor.constraintEqualToAnchor(bottomLettersShiftBackspace[bottomLettersShiftBackspace.count - 1].leftAnchor).active = true
                }
                button.widthAnchor.constraintEqualToAnchor(bottomPuncAndNumbersPuncKey[1].widthAnchor).active = true
                button.leftAnchor.constraintEqualToAnchor(bottomPuncAndNumbersPuncKey[i - 1].rightAnchor).active = true
            }
            // all buttons in row get this
            button.topAnchor.constraintEqualToAnchor(bottomRowView.topAnchor).active = true
            button.bottomAnchor.constraintEqualToAnchor(bottomRowView.bottomAnchor).active = true
        }
        
        // utilRow
        // SPECIFY THE SIZE OF THE UTIL ROW KEYS HERE
        for (i, button) in utilKeys.enumerate() {
            if i == 0 {
                button.leftAnchor.constraintEqualToAnchor(utilRowView.leftAnchor).active = true
                button.widthAnchor.constraintEqualToConstant(40).active = true
            } else {
                if i == 1 {
                    button.widthAnchor.constraintEqualToAnchor(utilKeys[0].widthAnchor).active = true
                } else {
                    if i == 3 {
                        button.widthAnchor.constraintEqualToConstant(80).active = true
                        button.rightAnchor.constraintEqualToAnchor(utilRowView.rightAnchor).active = true
                    }
                }
                button.leftAnchor.constraintEqualToAnchor(utilKeys[i - 1].rightAnchor).active = true
            }
            button.topAnchor.constraintEqualToAnchor(utilRowView.topAnchor).active = true
            button.bottomAnchor.constraintEqualToAnchor(utilRowView.bottomAnchor).active = true
        }
    }
}