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
    
    static func addRowConstraintsToSuperview(rows: [[UIView!]], sideSpace: CGFloat = 0, topSpace: CGFloat = 0, bottomSpace: CGFloat = 0, betweenSpace: CGFloat = 0, containingView: UIView) {
        
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
    
    static func addTextRowViewConstraints(textRowView: UIView, label: UILabel, labelMask: UIView, tutMessageLabel: UILabel, showCharsButton: UIView, tutButton: UIView) {
        let labelOffset: CGFloat = 7
        label.rightAnchor.constraintEqualToAnchor(textRowView.centerXAnchor, constant: labelOffset).active = true
        label.centerYAnchor.constraintEqualToAnchor(textRowView.centerYAnchor).active = true
        
        labelMask.leftAnchor.constraintEqualToAnchor(textRowView.leftAnchor).active = true
        labelMask.bottomAnchor.constraintEqualToAnchor(textRowView.bottomAnchor).active = true
        labelMask.topAnchor.constraintEqualToAnchor(textRowView.topAnchor).active = true
        labelMask.widthAnchor.constraintEqualToConstant(30).active = true
        
        tutMessageLabel.leftAnchor.constraintEqualToAnchor(textRowView.leftAnchor, constant: 5).active = true
        tutMessageLabel.bottomAnchor.constraintEqualToAnchor(textRowView.bottomAnchor, constant: -5).active = true
        tutMessageLabel.topAnchor.constraintEqualToAnchor(textRowView.topAnchor).active = true
        tutMessageLabel.widthAnchor.constraintEqualToConstant(130).active = true
        
        showCharsButton.rightAnchor.constraintEqualToAnchor(textRowView.rightAnchor).active = true
        showCharsButton.topAnchor.constraintEqualToAnchor(textRowView.topAnchor).active = true
        showCharsButton.heightAnchor.constraintEqualToAnchor(textRowView.heightAnchor).active = true
        showCharsButton.widthAnchor.constraintEqualToAnchor(textRowView.heightAnchor).active = true
        
        tutButton.rightAnchor.constraintEqualToAnchor(showCharsButton.leftAnchor).active = true
        tutButton.topAnchor.constraintEqualToAnchor(textRowView.topAnchor).active = true
        tutButton.heightAnchor.constraintEqualToAnchor(textRowView.heightAnchor).active = true
        tutButton.widthAnchor.constraintEqualToAnchor(textRowView.heightAnchor).active = true
    }
    
    static func addAllButtonConstraints(topRowView: UIView, midRowView: UIView, bottomRowView: UIView, utilRowView: UIView, verticalGuideViews: [UIView], topTouchButtons: [UIView], midTouchButtons: [UIView], bottomTouchButtons: [UIView], utilTouchKeys: [UIView], betweenSpace: CGFloat = 0, shiftWidth: CGFloat = 0.03, nextKeyboardWidth: CGFloat = 0.8, spaceKeyWidth: CGFloat = 0.3, charVerticalConstant: CGFloat = 0) {
        
        //==============================
        // Constants for Dimensions
        //
        //==============================
        
        let utilRowTopSpace: CGFloat = 8
        let utilRowBottomSpace: CGFloat = 8
        
        // touch buttons
        addTouchButtonConstraints(topRowView, midRowView: midRowView, bottomRowView: bottomRowView, utilRowView: utilRowView, topTouchButtons: topTouchButtons, midTouchButtons: midTouchButtons, bottomTouchButtons: bottomTouchButtons, utilKeys: utilTouchKeys, betweenSpace: betweenSpace, nextKeyboardWidth: nextKeyboardWidth, spaceKeyWidth: spaceKeyWidth)
        
        // verticalGuideViews
        for (i, view) in verticalGuideViews.enumerate() {
            view.topAnchor.constraintEqualToAnchor(topRowView.topAnchor).active = true
            view.bottomAnchor.constraintEqualToAnchor(bottomRowView.bottomAnchor).active = true
            view.leftAnchor.constraintEqualToAnchor(topTouchButtons[i].leftAnchor).active = true
            view.rightAnchor.constraintEqualToAnchor(topTouchButtons[i].rightAnchor).active = true
        }
    }
    
    static func addTouchButtonConstraints(topRowView: UIView, midRowView: UIView, bottomRowView: UIView, utilRowView: UIView, topTouchButtons: [UIView], midTouchButtons: [UIView], bottomTouchButtons: [UIView], utilKeys: [UIView], betweenSpace: CGFloat = 2, nextKeyboardWidth: CGFloat = 0.12, spaceKeyWidth: CGFloat = 0.48) {
        
        // char rows
        addButtonConstraintsToRow(topTouchButtons, containingView: topRowView)
        addButtonConstraintsToRow(midTouchButtons, containingView: midRowView)
        addButtonConstraintsToRow(bottomTouchButtons, containingView: bottomRowView)
        
        // utilRow
        // SPECIFY THE SIZE OF THE UTIL ROW KEYS HERE
        for (i, button) in utilKeys.enumerate() {
            if i == 0 {
                button.leftAnchor.constraintEqualToAnchor(utilRowView.leftAnchor).active = true
                button.widthAnchor.constraintEqualToAnchor(utilRowView.widthAnchor, multiplier: nextKeyboardWidth).active = true
            } else {
                if i == 1 {
                    button.widthAnchor.constraintEqualToAnchor(utilKeys[0].widthAnchor).active = true
                } else {
                    if i == 2 {
                        button.widthAnchor.constraintEqualToAnchor(utilKeys[0].widthAnchor).active = true
                    } else {
                        if i == 3 {
                            button.widthAnchor.constraintEqualToAnchor(utilRowView.widthAnchor, multiplier: spaceKeyWidth).active = true
                        } else {
                            button.rightAnchor.constraintEqualToAnchor(utilRowView.rightAnchor).active = true
                        }
                    }
                }
                button.leftAnchor.constraintEqualToAnchor(utilKeys[i - 1].rightAnchor).active = true
            }
            button.topAnchor.constraintEqualToAnchor(utilRowView.topAnchor).active = true
            button.bottomAnchor.constraintEqualToAnchor(utilRowView.bottomAnchor).active = true
        }
    }
    
    static func centerViewInView(view: UIView, subview: UIView, verticalConstant: CGFloat = 0) {
        subview.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        subview.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor, constant: verticalConstant).active = true
    }
    
    static func centerLabels(buttons: [UIView], verticalConstant: CGFloat = 0) {
        for button in buttons {
            centerLabel(button, verticalConstant: verticalConstant)
        }
    }
    
    static func centerLabel(button:UIView, verticalConstant: CGFloat = 0) {
        button.subviews[0].centerXAnchor.constraintEqualToAnchor(button.centerXAnchor).active = true
        button.subviews[0].centerYAnchor.constraintEqualToAnchor(button.centerYAnchor, constant: verticalConstant).active = true
    }
    
    static func setWindowHeight(view: UIView) {
        let constraint = view.heightAnchor.constraintEqualToConstant(270)
        constraint.priority = 999.0
        constraint.active = true
    }
}
