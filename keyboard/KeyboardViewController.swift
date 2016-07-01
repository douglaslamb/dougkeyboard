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

    @IBAction func printChar(sender: ModestUIButton) {
        self.textDocumentProxy.insertText(sender.titleLabel!.text!)
    }
    @IBAction func disappearChar(sender: ModestUIButton) {
        self.textDocumentProxy.deleteBackward()
    }
    @IBOutlet var nextKeyboardButton: UIButton!

    override func updateViewConstraints() {
        super.updateViewConstraints()
    
        // Add custom view sizing constraints here
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let nib = UINib(nibName: "KeyboardView", bundle: nil)
        //let objects = nib.instantiateWithOwner(self, options: nil)
        //view = objects[0] as! UIView
    
        // Perform custom UI setup here
        self.nextKeyboardButton = UIButton(type: .System)
        self.nextKeyboardButton.setTitle(NSLocalizedString("Next Keyboard", comment: "Title for 'Next Keyboard' button"), forState: .Normal)
        self.nextKeyboardButton.sizeToFit()
        self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
    
        self.nextKeyboardButton.addTarget(self, action: #selector(advanceToNextInputMode), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(self.nextKeyboardButton)
    
        self.nextKeyboardButton.leftAnchor.constraintEqualToAnchor(self.view.leftAnchor).active = true
        self.nextKeyboardButton.bottomAnchor.constraintEqualToAnchor(self.view.bottomAnchor).active = true
        
        let topRowButtonTitles = ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"]
        var topRowButtons = createButtons(topRowButtonTitles)
        var topRowView = UIView(frame: CGRectMake(0, 0, 320, 40))
        topRowView.backgroundColor = UIColor.darkGrayColor()
        
        for button in topRowButtons {
            topRowView.addSubview(button)
            
        }
        
        self.view.addSubview(topRowView)
    }
    
    func createButtons(titles: [String]) -> [UIViewKeyboardKey] {
        
        var buttons = [UIViewKeyboardKey]()
        
        for (i, title) in titles.enumerate() {
            let button = UIViewKeyboardKey(frame: CGRectMake(5 + 25 * CGFloat(i), 5, 25, 30))
            button.label = title
            buttons.append(button)
        }
        
        return buttons
    }
    
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("touchesMoved" + String(arc4random_uniform(9)))
        let keyboardView = self.view.subviews[0]
        let subviews = keyboardView.subviews
        var isTouchInButton = false
        for subview in subviews {
            let touchPoint = touches.first!.locationInView(subview)
            if subview.pointInside(touchPoint, withEvent: event) {
                handleTouchMoveInButton(subview)
                isTouchInButton = true
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
        var buttonLabel = view.subviews[0] as! UILabel
        var currButtonLabel = buttonLabel.text!
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
        let keyboardView = self.view.subviews[0]
        let subviews = keyboardView.subviews
        var isTouchInButton = false
        for subview in subviews {
            let touchPoint = touches.first!.locationInView(subview)
            if subview.pointInside(touchPoint, withEvent: event) {
                var buttonLabel = subview.subviews[0] as! UILabel
                self.prevButton = buttonLabel.text!
                self.textDocumentProxy.insertText(buttonLabel.text!)
                isTouchInButton = true
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
        self.nextKeyboardButton.setTitleColor(textColor, forState: .Normal)
    }

}
