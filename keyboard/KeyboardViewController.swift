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
    var topRowNumberView: UIView = UIView()
    var midRowNumberView: UIView = UIView()
    var bottomRowNumberView: UIView = UIView()
    var topRowPuncView: UIView = UIView()
    var midRowPuncView: UIView = UIView()
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
        let topRowButtons = createButtons(topRowButtonTitles)
        let topRowView = UIView()
        topRowView.backgroundColor = UIColor.lightGrayColor()
        
        for button in topRowButtons {
            topRowView.addSubview(button)
        }
        
        self.inputView!.addSubview(topRowView)
        self.topRowView = topRowView
        
        // create mid row buttons
        let midRowButtonTitles = ["A", "S", "D", "F", "G", "H", "J", "K", "L"]
        let midRowButtons = createButtons(midRowButtonTitles)
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
        
        // add letter buttons to bottom row subrow
        
        let bottomRowLetterTitles = ["Z", "X", "C", "V", "B", "N", "M"]
        let bottomRowLettersSubrow = UIView()
        let bottomRowLettersSubrowButtons = createButtons(bottomRowLetterTitles)
        for button in bottomRowLettersSubrowButtons {
            bottomRowLettersSubrow.addSubview(button)
        }
        bottomRowLettersSubrow.translatesAutoresizingMaskIntoConstraints = false
        bottomRowButtons.append(bottomRowLettersSubrow)
        
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
        
        // NUMBERS PAGE!!!
        
        // create top row numbers
        let topRowNumberButtonTitles = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
        let topRowNumberButtons = createButtons(topRowNumberButtonTitles)
        let topRowNumberView = UIView()
        topRowNumberView.backgroundColor = UIColor.lightGrayColor()
        
        for button in topRowNumberButtons {
            topRowNumberView.addSubview(button)
        }
        
        self.inputView!.addSubview(topRowNumberView)
        self.topRowNumberView = topRowNumberView
        
        // hide top number row to start
        self.topRowNumberView.hidden = true
        
        // create mid row numbers
        let midRowNumberButtonTitles = ["-", "/", ":", ";", "(", ")", "$", "&", "@", "\""]
        let midRowNumberButtons = createButtons(midRowNumberButtonTitles)
        let midRowNumberView = UIView()
        midRowNumberView.backgroundColor = UIColor.lightGrayColor()
        
        for button in midRowNumberButtons {
            midRowNumberView.addSubview(button)
        }
        
        self.inputView!.addSubview(midRowNumberView)
        self.midRowNumberView = midRowNumberView
        
        // hide mid number row to start
        self.midRowNumberView.hidden = true
        
        // create bottom row numbers
        // add backspace and switch to punctuation buttons later
        let bottomRowNumberButtonTitles = [".", ",", "?", "!", "'"]
        let bottomRowNumberButtons = createButtons(bottomRowNumberButtonTitles)
        let bottomRowNumberView = UIView()
        bottomRowNumberView.backgroundColor = UIColor.lightGrayColor()
        
        for button in bottomRowNumberButtons {
            bottomRowNumberView.addSubview(button)
        }
        
        self.inputView!.addSubview(bottomRowNumberView)
        self.bottomRowNumberView = bottomRowNumberView
        
        // hide bottom number row to start
        self.bottomRowNumberView.hidden = true
        
        // PUNCTUATION PAGE !!!
        
        // create top row punc
        let topRowPuncButtonTitles = ["[", "]", "{", "}", "#", "%", "^", "*", "+", "="]
        let topRowPuncButtons = createButtons(topRowPuncButtonTitles)
        let topRowPuncView = UIView()
        topRowPuncView.backgroundColor = UIColor.lightGrayColor()
        
        for button in topRowPuncButtons {
            topRowPuncView.addSubview(button)
        }
        
        self.inputView!.addSubview(topRowPuncView)
        self.topRowPuncView = topRowPuncView
        
        // hide top punc row to start
        self.topRowPuncView.hidden = true
        
        // create mid row punc
        let euro = "\u{20AC}"
        let pound = "\u{00A3}"
        let yen = "\u{00A5}"
        let bullet = "\u{2022}"
        let midRowPuncButtonTitles = ["_", "\\", "|", "~", "<", ">", euro, pound, yen, bullet]
        let midRowPuncButtons = createButtons(midRowPuncButtonTitles)
        let midRowPuncView = UIView()
        midRowPuncView.backgroundColor = UIColor.lightGrayColor()
        
        for button in midRowPuncButtons {
            midRowPuncView.addSubview(button)
        }
        
        self.inputView!.addSubview(midRowPuncView)
        self.midRowPuncView = midRowPuncView
        
        // hide mid punc row to start
        self.midRowPuncView.hidden = true
        
        // add constraints for rows in superview
        let rows = [[self.topRowView, self.topRowNumberView, self.topRowPuncView], [self.midRowView, self.midRowNumberView, self.midRowPuncView], [self.bottomRowView, self.bottomRowNumberView], [self.utilRowView]]
        
        for row in rows {
            for view in row {
                view.translatesAutoresizingMaskIntoConstraints = false
            }
        }
        ConstraintMaker.addRowConstraintsToSuperview(rows, containingView: self.inputView!)
        
        // add constraints to bottomRowLettersSubrow
        ConstraintMaker.addButtonConstraintsToRow(bottomRowLettersSubrowButtons, sideSpace: 0, topSpace: 1, bottomSpace: 1, betweenSpace: 1, containingView: bottomRowLettersSubrow)
        
        // add constraints for buttons in rows
        // LETTERS SCREEN
        ConstraintMaker.addButtonConstraintsToRow(topRowButtons, sideSpace: 1, topSpace: 1, bottomSpace: 1, betweenSpace: 1, containingView: topRowView)
        ConstraintMaker.addButtonConstraintsToRow(midRowButtons, sideSpace: 1, topSpace: 1, bottomSpace: 1, betweenSpace: 1, containingView: midRowView)
        ConstraintMaker.addButtonConstraintsToRow(bottomRowButtons, widths: [60, nil, 60], sideSpace: 1, topSpace: 1, bottomSpace: 1, betweenSpace: 1, containingView: bottomRowView)
        ConstraintMaker.addButtonConstraintsToRow(utilRowButtons, widths: [40, 40, nil, 80], sideSpace: 1, topSpace: 1, bottomSpace: 1, betweenSpace: 1, containingView: utilRowView)
        
        // NUMBERS SCREEN
        ConstraintMaker.addButtonConstraintsToRow(topRowNumberButtons, sideSpace: 1, topSpace: 1, bottomSpace: 1, betweenSpace: 1, containingView: topRowNumberView)
        ConstraintMaker.addButtonConstraintsToRow(midRowNumberButtons, sideSpace: 1, topSpace: 1, bottomSpace: 1, betweenSpace: 1, containingView: midRowNumberView)
        ConstraintMaker.addButtonConstraintsToRow(bottomRowNumberButtons, sideSpace: 1, topSpace: 1, bottomSpace: 1, betweenSpace: 1, containingView: bottomRowNumberView)
        
        // PUNC SCREEN
        ConstraintMaker.addButtonConstraintsToRow(topRowPuncButtons, sideSpace: 1, topSpace: 1, bottomSpace: 1, betweenSpace: 1, containingView: topRowPuncView)
        ConstraintMaker.addButtonConstraintsToRow(midRowPuncButtons, sideSpace: 1, topSpace: 1, bottomSpace: 1, betweenSpace: 1, containingView: midRowPuncView)
    }
    
    func createButtons(titles: [String]) -> [UIView] {
        
        var buttons = [UIView]()
        
        for title in titles {
            
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
