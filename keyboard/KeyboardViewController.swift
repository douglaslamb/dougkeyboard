//
//  KeyboardViewController.swift
//  keyboard
//
//  Created by rocker on 20160622.
//  Copyright © 2016 rocker. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController {
    
    // it's bottomRowNumberButtons (number singular)
    // and bottomRowLettersButtons (letter plural)
    // it's just the way I wrote them
    
    // views
    var topRowView: UIView = UIView()
    var midRowView: UIView = UIView()
    var bottomRowView: UIView = UIView()
    var utilRowView: UIView = UIView()
    
    // global vars
    var isShift: Bool = false
    var isNumbersPage: Bool = false
    var isPuncsPage: Bool = false
    var prevButton = ""
    var disableTouch = false;
    
    // global arrays of buttons
    var lettersAndShift: [UIView] = [UIView]()
    var numbersAndPuncs: [UIView] = [UIView]()
    var puncs: [UIView] = [UIView]()
    var lowerPuncsAndNumbersPuncsKey: [UIView] = [UIView]()
    
    // keys
    var shiftKey: UIImageView = UIImageView()
    var numbersKey: UIView = UIView()
    var numbersPuncKey: UIView = UIView()
    
    enum UtilKey: Int {
        case nextKeyboardKey = 1, returnKey, shiftKey, backspaceKey, numbersLettersKey, numbersPuncKey
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
        
        let shiftImage = UIImage(named: "shiftOff")
        let shiftKey = UIImageView(image: shiftImage)
        shiftKey.translatesAutoresizingMaskIntoConstraints = false
        shiftKey.layer.masksToBounds = true
        shiftKey.layer.cornerRadius = 5
        bottomRowButtons.append(shiftKey)
        shiftKey.tag = UtilKey.shiftKey.rawValue
        
        // save shift key as global to change image later
        self.shiftKey = shiftKey
        
        // add letter buttons to bottom row
        
        let bottomRowLetterTitles = ["Z", "X", "C", "V", "B", "N", "M"]
        let bottomRowLettersButtons = createButtons(bottomRowLetterTitles)
        bottomRowButtons = bottomRowButtons + bottomRowLettersButtons
        
        // put letters and shiftkey in one array to control hiding
        self.lettersAndShift = topRowButtons + midRowButtons + bottomRowButtons
        
        // add backspace key to bottom row
        
        let backspaceImage = UIImage(named: "backspace")
        let backspaceKey = UIImageView(image: backspaceImage)
        backspaceKey.translatesAutoresizingMaskIntoConstraints = false
        backspaceKey.layer.masksToBounds = true
        backspaceKey.layer.cornerRadius = 5
        backspaceKey.tag = UtilKey.backspaceKey.rawValue
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
        numbersKey.tag = UtilKey.numbersLettersKey.rawValue
        
        utilRowButtons.append(numbersKey)
        
        /// save later for label changing
        self.numbersKey = numbersKey

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
        
        let spacebarKeyLabel = UILabel(frame: CGRectMake(10.0, 10.0, 60, 25))
        spacebarKeyLabel.text = " "
        spacebarKey.addSubview(spacebarKeyLabel)
        
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
        returnKey.tag = UtilKey.returnKey.rawValue
        
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
        
        for button in topRowNumberButtons {
            topRowView.addSubview(button)
        }
        
        // create mid row numbers
        let midRowNumberButtonTitles = ["-", "/", ":", ";", "(", ")", "$", "&", "@", "\""]
        let midRowNumberButtons = createButtons(midRowNumberButtonTitles)
        
        for button in midRowNumberButtons {
            midRowView.addSubview(button)
        }
        
        // put top and mid number rows in one array for hiding later
        self.numbersAndPuncs = topRowNumberButtons + midRowNumberButtons
        
        /// create bottom row numbers
        // this punctuation row does not have its own view
        // it goes into the bottomRowView, but it will be hidden to start
        let bottomRowNumberButtonTitles = [".", ",", "?", "!", "'"]
        let bottomRowNumberButtons = createButtons(bottomRowNumberButtonTitles)
        
        for button in bottomRowNumberButtons {
            bottomRowView.addSubview(button)
        }
        
        // hide bottom number row to start
        hide(bottomRowNumberButtons)
        
        // add numbersPunc key to bottom row
        
        let numbersPuncKey = UIView()
        let numbersPuncKeyLabel = UILabel(frame: CGRectMake(3.0, 10.0, 60, 25))
        numbersPuncKeyLabel.text = "#+="
        numbersPuncKey.addSubview(numbersPuncKeyLabel)
        
        numbersPuncKey.backgroundColor = UIColor.whiteColor()
        numbersPuncKey.layer.cornerRadius = 5
        numbersPuncKey.translatesAutoresizingMaskIntoConstraints = false
        numbersPuncKey.tag = UtilKey.numbersPuncKey.rawValue
        
        /// save global for label changing later
        self.numbersPuncKey = numbersPuncKey
        
        // put ". < ? ..." in one array for hiding later
        self.lowerPuncsAndNumbersPuncsKey = bottomRowNumberButtons + [numbersPuncKey]
        
        self.bottomRowView.addSubview(numbersPuncKey)
        
        // PUNCTUATION PAGE !!!
        
        // create top row punc
        let topRowPuncButtonTitles = ["[", "]", "{", "}", "#", "%", "^", "*", "+", "="]
        let topRowPuncButtons = createButtons(topRowPuncButtonTitles)
        
        for button in topRowPuncButtons {
            topRowView.addSubview(button)
        }
        
        // create mid row punc
        let euro = "\u{20AC}"
        let pound = "\u{00A3}"
        let yen = "\u{00A5}"
        let bullet = "\u{2022}"
        let midRowPuncButtonTitles = ["_", "\\", "|", "~", "<", ">", euro, pound, yen, bullet]
        let midRowPuncButtons = createButtons(midRowPuncButtonTitles)
        
        for button in midRowPuncButtons {
            midRowView.addSubview(button)
        }
        
        // put punc page in one array for hiding later
        self.puncs = topRowPuncButtons + midRowPuncButtons
        
        // add constraints for rows in superview
        let rows = [[self.topRowView], [self.midRowView], [self.bottomRowView], [self.utilRowView]]
        
        for row in rows {
            for view in row {
                view.translatesAutoresizingMaskIntoConstraints = false
            }
        }
        ConstraintMaker.addRowConstraintsToSuperview(rows, containingView: self.inputView!)
        
        // add constraints for buttons in rows
        // LETTERS SCREEN
        ConstraintMaker.addButtonConstraintsToRow(topRowButtons, sideSpace: 1, topSpace: 1, bottomSpace: 1, betweenSpace: 1, containingView: topRowView)
        ConstraintMaker.addButtonConstraintsToRow(midRowButtons, sideSpace: 1, topSpace: 1, bottomSpace: 1, betweenSpace: 1, containingView: midRowView)
        ConstraintMaker.addButtonConstraintsToRow(bottomRowButtons, sideSpace: 1, topSpace: 1, bottomSpace: 1, betweenSpace: 1, containingView: bottomRowView)
        ConstraintMaker.addButtonConstraintsToRow(utilRowButtons, widths: [40, 40, nil, 80], sideSpace: 1, topSpace: 1, bottomSpace: 1, betweenSpace: 1, containingView: utilRowView)
        
        // NUMBERS SCREEN
        ConstraintMaker.addButtonConstraintsToRow(topRowNumberButtons, sideSpace: 1, topSpace: 1, bottomSpace: 1, betweenSpace: 1, containingView: topRowView)
        ConstraintMaker.addButtonConstraintsToRow(midRowNumberButtons, sideSpace: 1, topSpace: 1, bottomSpace: 1, betweenSpace: 1, containingView: midRowView)
        
        // SPECIAL CASE: bottom row numbers
        // add these constraints manually
        // because the ConstraintMaker functions cannot handle them
        for (index, button) in bottomRowNumberButtons.enumerate() {
            let leftButton = shiftKey
            let rightButton = backspaceKey
            var constraints = [NSLayoutConstraint]()
            let container = bottomRowView
            // set left constraint
            if index == 0 {
                constraints.append(NSLayoutConstraint(item: button, attribute: .Left, relatedBy: .Equal, toItem: leftButton, attribute: .Right, multiplier: 1.0, constant: 1))
            } else {
                constraints.append(NSLayoutConstraint(item: button, attribute: .Left, relatedBy: .Equal, toItem: bottomRowNumberButtons[index - 1] , attribute: .Right, multiplier: 1.0, constant: 1))
            }
        
            // set right constraint if last button
            if index == bottomRowNumberButtons.count - 1 {
                constraints.append(NSLayoutConstraint(item: button, attribute: .Right, relatedBy: .Equal, toItem: rightButton, attribute: .Left, multiplier: 1.0, constant: -1))
            }
            
            // set top and bottom constraints, same for all
            constraints.append(NSLayoutConstraint(item: button, attribute: .Top, relatedBy: .Equal, toItem: container, attribute: .Top, multiplier: 1.0, constant: 1))
            constraints.append(NSLayoutConstraint(item: button, attribute: .Bottom, relatedBy: .Equal, toItem: container, attribute: .Bottom, multiplier: 1.0, constant: -1))
            
            // set widths
            constraints.append(NSLayoutConstraint(item: bottomRowNumberButtons[0], attribute: .Width, relatedBy: .Equal, toItem: button, attribute: .Width, multiplier: 1.0, constant: 0))
            
            // activate constraints
            NSLayoutConstraint.activateConstraints(constraints)
        }
        
        // SPECIAL CASE: numbersPunc key
        // this needs the same constraints as the shift key
        // add the constraints manually
        // The ConstraintMaker functions cannot handle this
        // setting right constraint relative to the "Z" key
        
        numbersPuncKey.leftAnchor.constraintEqualToAnchor(bottomRowView.leftAnchor, constant: 1).active = true
        numbersPuncKey.rightAnchor.constraintEqualToAnchor(bottomRowButtons[1].leftAnchor, constant: -1).active = true
        numbersPuncKey.topAnchor.constraintEqualToAnchor(bottomRowView.topAnchor, constant: 1).active = true
        numbersPuncKey.bottomAnchor.constraintEqualToAnchor(bottomRowView.bottomAnchor, constant: -1).active = true
        
        // PUNC SCREEN
        ConstraintMaker.addButtonConstraintsToRow(topRowPuncButtons, sideSpace: 1, topSpace: 1, bottomSpace: 1, betweenSpace: 1, containingView: topRowView)
        ConstraintMaker.addButtonConstraintsToRow(midRowPuncButtons, sideSpace: 1, topSpace: 1, bottomSpace: 1, betweenSpace: 1, containingView: midRowView)
        
        // do startup hiding
        hide(numbersAndPuncs)
        hide(puncs)
        hide(lowerPuncsAndNumbersPuncsKey)
        goToLettersPage()
    }
    
    func goToNumbersPage() {
        // hide what needs to be hidden and set state
        // and other stuff
        // set correct label on numbersPuncKey
        let label = self.numbersPuncKey.subviews[0] as! UILabel
        label.text = "#+="
        unhide(numbersAndPuncs)
        if self.isPuncsPage {
            hide(puncs)
            self.isPuncsPage = false
        } else {
            unhide(lowerPuncsAndNumbersPuncsKey)
            hide(lettersAndShift)
            let label = self.numbersKey.subviews[0] as! UILabel
            // put correct label on numbersKey
            label.text = "ABC"
            self.isNumbersPage = true
        }
    }
    
    func goToPuncsPage() {
        // hide what needs to be hidden and set state
        // and other stuff
        hide(numbersAndPuncs)
        unhide(puncs)
        // set correct label on numbersPuncKey
        let label = self.numbersPuncKey.subviews[0] as! UILabel
        label.text = "123"
        // modify global state
        self.isPuncsPage = true
    }
    
    func goToLettersPage() {
        // hide what needs to be hidden and set state
        // and other stuff
        shiftOff()
        unhide(lettersAndShift)
        hide(lowerPuncsAndNumbersPuncsKey)
        if self.isPuncsPage {
            hide(puncs)
            self.isPuncsPage = false
        } else {
            hide(numbersAndPuncs)
        }
        // put correct label on numbersKey
        let label = self.numbersKey.subviews[0] as! UILabel
        label.text = "123"
        // modify global state
        self.isNumbersPage = false
    }
    
    func shiftOn() {
        self.isShift = true
        self.shiftKey.image = UIImage(named: "shiftOn")
    }
    
    func shiftOff() {
        self.isShift = false
        self.shiftKey.image = UIImage(named: "shiftOff")
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
    
    func hide(buttons: [UIView]) {
        for button in buttons {
            button.hidden = true
        }
    }
    
    func unhide(buttons: [UIView]) {
        for button in buttons {
            button.hidden = false
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // if touch is disabled early return and do nothing
        if self.disableTouch {
            return
        }
        print("touchesMoved" + String(arc4random_uniform(9)))
        let subviews = self.topRowView.subviews + self.midRowView.subviews + self.bottomRowView.subviews + self.utilRowView.subviews
        var isTouchInButton = false
        for subview in subviews {
            let touchPoint = touches.first!.locationInView(subview)
            // if touch is in a button, and button is not hidden then handle touch
            if subview.pointInside(touchPoint, withEvent: event) && !subview.hidden && subview.tag == 0 {
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
                self.prevButton = ""
            }
        }
    }
    
    func handleTouchMoveInButton(view: UIView) {
        let buttonLabel = view.subviews[0] as! UILabel
        let currButtonLabel = buttonLabel.text!
        let character = self.isShift ? currButtonLabel : currButtonLabel.lowercaseString
        // checking if we insert text or
        // delete and insert text
        if (self.prevButton != currButtonLabel) {
            // if the current button is not the previous
            if (self.prevButton == "") {
                // if the previous button was outside buttons
                self.textDocumentProxy.insertText(character)
            } else {
                // in this case the previous button
                // was a different character.
                // i.e. slide from button to button
                self.textDocumentProxy.deleteBackward()
                self.textDocumentProxy.insertText(character)
            }
            self.prevButton = currButtonLabel
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
            if subview.pointInside(touchPoint, withEvent: event) && !subview.hidden {
                if (subview.tag != 0) {
                    // pass to utility key function handler
                    // like for shift key
                    doKeyFunction(subview)
                    // disable touch so if user drags out of util
                    // key it won't crash
                    self.disableTouch = true;
                    // found the button so return
                    //return
                } else {
                    print("inside button" + String(arc4random_uniform(9)))
                    let buttonLabel = subview.subviews[0] as! UILabel
                    let currButtonLabel = buttonLabel.text!
                    let character = self.isShift ? currButtonLabel: currButtonLabel.lowercaseString
                    self.textDocumentProxy.insertText(character)
                    isTouchInButton = true
                    self.prevButton = currButtonLabel
                    // found the button so return
                    //return
                }
            }
        }
        if (!isTouchInButton) {
            self.prevButton = ""
        }
    }
    
    func doKeyFunction(key: UIView) {
        // handler function for function keys like shift
        let tag = key.tag
        switch tag {
        case UtilKey.nextKeyboardKey.rawValue:
            self.advanceToNextInputMode()
        case UtilKey.shiftKey.rawValue:
            // change shift key image
            // set global boolean
            if self.isShift {
                shiftOff()
            } else {
                shiftOn()
            }
        case UtilKey.returnKey.rawValue:
            self.textDocumentProxy.insertText("\n")
        case UtilKey.backspaceKey.rawValue:
            self.textDocumentProxy.deleteBackward()
        case UtilKey.numbersLettersKey.rawValue:
            if self.isNumbersPage {
                // switch back to letters page
                goToLettersPage()
            } else {
                // switch to numbers page
                goToNumbersPage()
            }
        case UtilKey.numbersPuncKey.rawValue:
            if self.isPuncsPage {
                goToNumbersPage()
            } else {
                goToPuncsPage()
            }
        default:
            return
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.disableTouch = false;
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
    }

}
