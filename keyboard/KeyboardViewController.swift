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
        
        // create top row buttons
        let topRowButtonTitles = ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"]
        var topRowButtons = createButtons(topRowButtonTitles)
        var topRowView = UIView(frame: CGRectMake(0, 0, 320, 40))
        topRowView.backgroundColor = UIColor.lightGrayColor()
        
        for button in topRowButtons {
            topRowView.addSubview(button)
        }
        
        self.view.addSubview(topRowView)
        self.topRowView = topRowView
        
        
        // create mid row buttons
        let midRowButtonTitles = ["A", "S", "D", "F", "G", "H", "J", "K", "L"]
        var midRowButtons = createButtons(midRowButtonTitles)
        var midRowView = UIView(frame: CGRectMake(0, 40, 320, 40))
        midRowView.backgroundColor = UIColor.lightGrayColor()
        
        for button in midRowButtons {
            midRowView.addSubview(button)
        }
        
        self.view.addSubview(midRowView)
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
        
        // add backspace to bottom row
        
        let backspaceImage = UIImage(named: "backspace")
        let backspaceKey = UIImageView(image: backspaceImage)
        backspaceKey.translatesAutoresizingMaskIntoConstraints = false
        backspaceKey.layer.masksToBounds = true
        backspaceKey.layer.cornerRadius = 5
        bottomRowButtons.append(backspaceKey)
        
        // create bottom row view and add all buttons to view
        
        var bottomRowView = UIView(frame: CGRectMake(0, 80, 320, 40))
        bottomRowView.backgroundColor = UIColor.lightGrayColor()
        
        for button in bottomRowButtons {
            bottomRowView.addSubview(button)
        }
        
        self.view.addSubview(bottomRowView)
        self.bottomRowView = bottomRowView
        
        /*
        // create util row buttons
        let utilRowButtonTitles = ["Z", "X", "C", "V", "B", "N", "M"]
        
        var utilRowButtons = [UIView]()
        
        
        bottomRowButtons = bottomRowButtons + createButtons(bottomRowButtonTitles)
        var bottomRowView = UIView(frame: CGRectMake(0, 80, 320, 40))
        bottomRowView.backgroundColor = UIColor.lightGrayColor()
        
        for button in bottomRowButtons {
            bottomRowView.addSubview(button)
        }
        
        self.view.addSubview(bottomRowView)
        self.bottomRowView = bottomRowView
         */

        
        // add constraints
 
        addConstraints(topRowButtons, containingView: topRowView)
        addConstraints(midRowButtons, containingView: midRowView)
        addConstraints(bottomRowButtons, containingView: bottomRowView)
    
        // Perform custom UI setup here
        self.nextKeyboardButton = UIButton(type: .System)
        self.nextKeyboardButton.setTitle(NSLocalizedString("Next Keyboard", comment: "Title for 'Next Keyboard' button"), forState: .Normal)
        self.nextKeyboardButton.sizeToFit()
        self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
    
        self.nextKeyboardButton.addTarget(self, action: #selector(advanceToNextInputMode), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(self.nextKeyboardButton)
    
        self.nextKeyboardButton.leftAnchor.constraintEqualToAnchor(self.view.leftAnchor).active = true
        self.nextKeyboardButton.bottomAnchor.constraintEqualToAnchor(self.view.bottomAnchor).active = true
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
    
    func addConstraints(buttons: [UIView], containingView: UIView) {
        for (index, button) in buttons.enumerate() {
            
            var topConstraint = NSLayoutConstraint(item: button, attribute: .Top, relatedBy: .Equal, toItem: containingView, attribute: .Top, multiplier: 1.0, constant: 1)
            var bottomConstraint = NSLayoutConstraint(item: button, attribute: .Bottom, relatedBy: .Equal, toItem: containingView, attribute: .Bottom, multiplier: 1.0, constant: -1)
            var leftConstraint : NSLayoutConstraint!
            
            if index == 0 {
                leftConstraint = NSLayoutConstraint(item: button, attribute: .Left, relatedBy: .Equal, toItem: containingView, attribute: .Left, multiplier: 1.0, constant: 1)
            } else {
                leftConstraint = NSLayoutConstraint(item: button, attribute: .Left, relatedBy: .Equal, toItem: buttons[index - 1], attribute: .Right, multiplier: 1.0, constant: 1)
                var widthConstraint = NSLayoutConstraint(item: buttons[0], attribute: .Width, relatedBy: .Equal, toItem: button, attribute: .Width, multiplier: 1.0, constant: 0)
                containingView.addConstraint(widthConstraint)
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
        let subviews = self.topRowView.subviews + self.midRowView.subviews + self.bottomRowView.subviews
        var isTouchInButton = false
        //print(subviews.count)
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
        
        // gather subviews
        let subviews = self.topRowView.subviews + self.midRowView.subviews + self.bottomRowView.subviews
        var isTouchInButton = false
        
        // check each uiview for touch
        for subview in subviews {
            let touchPoint = touches.first!.locationInView(subview)
            if subview.pointInside(touchPoint, withEvent: event) {
                print("inside button" + String(arc4random_uniform(9)))
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
