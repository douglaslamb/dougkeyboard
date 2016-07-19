//
//  KeyboardViewController.swift
//  keyboard
//
//  Created by rocker on 20160622.
//  Copyright © 2016 rocker. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController {
    
    var prevButton = ""
    var topRowView: UIView = UIView()
    var midRowView: UIView = UIView()
    var bottomRowView: UIView = UIView()
    var utilRowView: UIView = UIView()
    enum UtilKey: Int {
        case nextKeyboardKey = 1, returnKey, shiftKey
    }

    override func updateViewConstraints() {
        super.updateViewConstraints()
    
        // Add custom view sizing constraints here
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create top row buttons
        let topRowButtonTitles = ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"]
        var topRowButtons = createButtons(topRowButtonTitles)
        let topRowView = UIView()
        topRowView.backgroundColor = UIColor.lightGrayColor()
        
        for button in topRowButtons {
            topRowView.addSubview(button)
        }
        
        self.inputView!.addSubview(topRowView)
        self.topRowView = topRowView
        
        
        // create mid row buttons
        let midRowButtonTitles = ["A", "S", "D", "F", "G", "H", "J", "K", "L"]
        var midRowButtons = createButtons(midRowButtonTitles)
        let midRowView = UIView()
        midRowView.backgroundColor = UIColor.lightGrayColor()
        
        for button in midRowButtons {
            midRowView.addSubview(button)
        }
        
        self.inputView!.addSubview(midRowView)
        self.midRowView = midRowView
        
        // create bottom row buttons
        
        // empty array to eventually contain
        // all bottom row buttons
        
        var bottomRowButtons = [UIView]()
        
        // add shift key to bottom row
        
        let shiftImage = UIImage(named: "shift")
        let shiftKey = UIImageView(image: shiftImage)
        shiftKey.translatesAutoresizingMaskIntoConstraints = false
        shiftKey.layer.masksToBounds = true
        shiftKey.layer.cornerRadius = 5
        bottomRowButtons.append(shiftKey)
        
        // add letter buttons to bottom row
        
        let bottomRowButtonTitles = ["Z", "X", "C", "V", "B", "N", "M"]
        bottomRowButtons = bottomRowButtons + createButtons(bottomRowButtonTitles)
        
        // add backspace key to bottom row
        
        let backspaceImage = UIImage(named: "backspace")
        let backspaceKey = UIImageView(image: backspaceImage)
        backspaceKey.translatesAutoresizingMaskIntoConstraints = false
        backspaceKey.layer.masksToBounds = true
        backspaceKey.layer.cornerRadius = 5
        bottomRowButtons.append(backspaceKey)
        
        // create bottom row view and add all buttons to view
        
        let bottomRowView = UIView()
        bottomRowView.backgroundColor = UIColor.lightGrayColor()
        
        for button in bottomRowButtons {
            bottomRowView.addSubview(button)
        }
        
        self.inputView!.addSubview(bottomRowView)
        self.bottomRowView = bottomRowView
        
        // create util row buttons
        
        var utilRowButtons = [UIView]()
        
        // numbers key
        
        let numbersKey = UIView()
        let numbersKeyLabel = UILabel(frame: CGRectMake(10.0, 10.0, 60, 25))
        numbersKeyLabel.text = "123"
        numbersKey.addSubview(numbersKeyLabel)
        
        numbersKey.backgroundColor = UIColor.whiteColor()
        numbersKey.layer.cornerRadius = 5
        numbersKey.translatesAutoresizingMaskIntoConstraints = false
        
        utilRowButtons.append(numbersKey)

        // next keyboard key
        
        let nextKeyboardImage = UIImage(named: "nextKeyboard")
        let nextKeyboardKey = UIImageView(image: nextKeyboardImage)
        
        nextKeyboardKey.backgroundColor = UIColor.whiteColor()
        nextKeyboardKey.layer.cornerRadius = 5
        nextKeyboardKey.translatesAutoresizingMaskIntoConstraints = false
        nextKeyboardKey.layer.masksToBounds = true
        nextKeyboardKey.tag = UtilKey.nextKeyboardKey.rawValue
        
        utilRowButtons.append(nextKeyboardKey)
        
        // spacebar
        
        let spacebarKey = UIView()
        
        spacebarKey.backgroundColor = UIColor.whiteColor()
        spacebarKey.layer.cornerRadius = 5
        spacebarKey.translatesAutoresizingMaskIntoConstraints = false
        
        utilRowButtons.append(spacebarKey)
        
        // return key
        
        let returnImage = UIImage(named: "return")
        let returnKey = UIImageView(image: returnImage)
        
        returnKey.backgroundColor = UIColor.whiteColor()
        returnKey.layer.cornerRadius = 5
        returnKey.translatesAutoresizingMaskIntoConstraints = false
        returnKey.layer.masksToBounds = true
        
        utilRowButtons.append(returnKey)
        
        // add util buttons to util view
        
        let utilRowView = UIView()
        utilRowView.backgroundColor = UIColor.lightGrayColor()
        
        for button in utilRowButtons {
            utilRowView.addSubview(button)
        }
        
        self.inputView!.addSubview(utilRowView)
        self.utilRowView = utilRowView
        
        // add constraints for rows
        //let rows = [topRowView, midRowView, bottomRowView, utilRowView]
        let rows = [self.topRowView, self.midRowView, self.bottomRowView, self.utilRowView]
        addRowConstraints(rows, containingView: self.inputView!)
        
        // add constraints for buttons
        ConstraintMaker.addButtonConstraintsToRow(topRowButtons, sideSpace: 1, topSpace: 1, bottomSpace: 1, betweenSpace: 1, containingView: topRowView)
        ConstraintMaker.addButtonConstraintsToRow(midRowButtons, sideSpace: 1, topSpace: 1, bottomSpace: 1, betweenSpace: 1, containingView: midRowView)
        ConstraintMaker.addButtonConstraintsToRow(bottomRowButtons, sideSpace: 1, topSpace: 1, bottomSpace: 1, betweenSpace: 1, containingView: bottomRowView)
        addUtilRowConstraints(utilRowButtons, containingView: utilRowView)
    }
    
    func createButtons(titles: [String]) -> [UIView] {
        
        var buttons = [UIView]()
        
        for (i, title) in titles.enumerate() {
            
            let button = UIView()
            let label = UILabel(frame: CGRectMake(10.0, 10.0, 20, 15))
            label.text = title
            button.addSubview(label)
            
            // button appearance config
            button.backgroundColor = UIColor.whiteColor()
            button.layer.cornerRadius = 5
            button.translatesAutoresizingMaskIntoConstraints = false
            
            // add button to return array
            buttons.append(button)
        }
        
        return buttons
    }
    
    func addRowConstraints(rows: [UIView], containingView: UIView) {
        for (index, row) in rows.enumerate() {
            
            row.translatesAutoresizingMaskIntoConstraints = false
            // top constraints
            var topConstraint: NSLayoutConstraint
            if (index == 0) {
                topConstraint = NSLayoutConstraint(item: row, attribute: .Top, relatedBy: .Equal, toItem: containingView, attribute: .Top, multiplier: 1.0, constant: 0)
            } else {
                topConstraint = NSLayoutConstraint(item: row, attribute: .Top, relatedBy: .Equal, toItem: rows[index - 1], attribute: .Bottom, multiplier: 1.0, constant: 0)
            }

            // bottom constraint
            if (index == 3) {
                containingView.addConstraint(NSLayoutConstraint(item: row, attribute: .Bottom, relatedBy: .Equal, toItem: containingView, attribute: .Bottom, multiplier: 1.0, constant: 0))
            }
            
            // side constraints
            let leftConstraint = NSLayoutConstraint(item: row, attribute: .Left, relatedBy: .Equal, toItem: containingView, attribute: .Left, multiplier: 1.0, constant: 0)
            let rightConstraint = NSLayoutConstraint(item: row, attribute: .Right, relatedBy: .Equal, toItem: containingView, attribute: .Right, multiplier: 1.0, constant: 0)
            NSLayoutConstraint.activateConstraints([topConstraint,leftConstraint, rightConstraint])
        }
    }
    
    func addUtilRowConstraints(buttons: [UIView], containingView: UIView) {
        for (index, button) in buttons.enumerate() {
            
            var topConstraint = NSLayoutConstraint(item: button, attribute: .Top, relatedBy: .Equal, toItem: containingView, attribute: .Top, multiplier: 1.0, constant: 1)
            var bottomConstraint = NSLayoutConstraint(item: button, attribute: .Bottom, relatedBy: .Equal, toItem: containingView, attribute: .Bottom, multiplier: 1.0, constant: -1)
            var leftConstraint : NSLayoutConstraint!
            
            switch index {
            case 0:
                // numbers key
                leftConstraint = NSLayoutConstraint(item: button, attribute: .Left, relatedBy: .Equal, toItem: containingView, attribute: .Left, multiplier: 1.0, constant: 1)
                var widthConstraint = NSLayoutConstraint(item: button, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 40)
                containingView.addConstraint(widthConstraint)
                
            case 1:
                // next keyboard key
                leftConstraint = NSLayoutConstraint(item: button, attribute: .Left, relatedBy: .Equal, toItem: buttons[index - 1], attribute: .Right, multiplier: 1.0, constant: 1)
                var widthConstraint = NSLayoutConstraint(item: buttons[0], attribute: .Width, relatedBy: .Equal, toItem: button, attribute: .Width, multiplier: 1.0, constant: 0)
                containingView.addConstraint(widthConstraint)
                
            case 2:
                // spacebar
                leftConstraint = NSLayoutConstraint(item: button, attribute: .Left, relatedBy: .Equal, toItem: buttons[index - 1], attribute: .Right, multiplier: 1.0, constant: 1)
                
            case 3:
                // return key
                leftConstraint = NSLayoutConstraint(item: button, attribute: .Left, relatedBy: .Equal, toItem: buttons[index - 1], attribute: .Right, multiplier: 1.0, constant: 1)
                var widthConstraint = NSLayoutConstraint(item: button, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 80)
                containingView.addConstraint(widthConstraint)
                
            default:
                print()
                
            }
            
            var rightConstraint : NSLayoutConstraint!
            
            if index == buttons.count - 1 {
                rightConstraint = NSLayoutConstraint(item: button, attribute: .Right, relatedBy: .Equal, toItem: containingView, attribute: .Right, multiplier: 1.0, constant: -1)
            } else {
                rightConstraint = NSLayoutConstraint(item: button, attribute: .Right, relatedBy: .Equal, toItem: buttons[index + 1], attribute: .Left, multiplier: 1.0, constant: -1)
            }
            
            containingView.addConstraints([topConstraint, bottomConstraint, rightConstraint, leftConstraint])
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("touchesMoved" + String(arc4random_uniform(9)))
        let subviews = self.topRowView.subviews + self.midRowView.subviews + self.bottomRowView.subviews + self.utilRowView.subviews
        var isTouchInButton = false
        for subview in subviews {
            let touchPoint = touches.first!.locationInView(subview)
            if subview.pointInside(touchPoint, withEvent: event) {
                handleTouchMoveInButton(subview)
                isTouchInButton = true
                // found the button so return
                //return
            }
        }
        if (!isTouchInButton) {
            // if touch was not detected in any button
            if (prevButton != "") {
                // if touch was just in a button
                self.textDocumentProxy.deleteBackward()
                prevButton = ""
            }
        }
    }
    
    func handleTouchMoveInButton(view: UIView) {
        let buttonLabel = view.subviews[0] as! UILabel
        let currButtonLabel = buttonLabel.text!
        //checking if we delete text
        // or insert or both
        if (self.prevButton != currButtonLabel) {
            // if the current button is not the previous
            if (self.prevButton == "") {
                // if the previous button was outside buttons
                self.textDocumentProxy.insertText(currButtonLabel)
                self.prevButton = currButtonLabel
            } else {
                // in this case the previous button
                // was a different character.
                // i.e. slide from button to button
                self.textDocumentProxy.deleteBackward()
                self.textDocumentProxy.insertText(currButtonLabel)
                self.prevButton = currButtonLabel
            }
        }
        print(view.dynamicType)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("touchesBegan" + String(arc4random_uniform(9)))
        
        // gather subviews
        let subviews = self.topRowView.subviews + self.midRowView.subviews + self.bottomRowView.subviews + self.utilRowView.subviews
        var isTouchInButton = false
        
        // check each uiview for touch
        for subview in subviews {
            let touchPoint = touches.first!.locationInView(subview)
            if subview.pointInside(touchPoint, withEvent: event) {
                if (subview.tag == UtilKey.nextKeyboardKey.rawValue) {
                    self.advanceToNextInputMode()
                    // found the button so return
                    //return
                } else {
                    print("inside button" + String(arc4random_uniform(9)))
                    var buttonLabel = subview.subviews[0] as! UILabel
                    self.prevButton = buttonLabel.text!
                    self.textDocumentProxy.insertText(buttonLabel.text!)
                    isTouchInButton = true
                    // found the button so return
                    //return
                }
            }
        }
        if (!isTouchInButton) {
            self.prevButton = ""
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }

    override func textWillChange(textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }

    override func textDidChange(textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
    
        var textColor: UIColor
        let proxy = self.textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.Dark {
            textColor = UIColor.whiteColor()
        } else {
            textColor = UIColor.blackColor()
        }
        //self.nextKeyboardButton.setTitleColor(textColor, forState: .Normal)
    }

}
