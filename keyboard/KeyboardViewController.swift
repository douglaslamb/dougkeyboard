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
    var prevButton = ""
    var disableTouch = false;
    var manager: KeyboardManager = KeyboardManager()
    var longDeleteTimer: NSTimer! = nil
    
    enum UtilKey: Int {
        case nextKeyboardKey = 1, returnKey, shiftKey, backspaceKey, numbersLettersKey, numbersPuncKey
    }

    override func updateViewConstraints() {
        super.updateViewConstraints()
    
        // Add custom view sizing constraints here
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create top row view
        let topRowView = UIView()
        topRowView.backgroundColor = UIColor.lightGrayColor()
        // create buttons
        let topRowButtonTitles = ["Q", "W", "E", "R", "T", "Y", "U", "I", "O"]
        let topRowButtons = createButtons(topRowButtonTitles)
        // create touch buttons
        var topRowTouchButtons: [UIView] = wrapButtons(topRowButtons)
        // put each button in a touchview and add touchview to view
        for button in topRowTouchButtons {
            topRowView.addSubview(button)
        }
        
        self.inputView!.addSubview(topRowView)
        self.topRowView = topRowView
        
        // create mid row view
        let midRowView = UIView()
        midRowView.backgroundColor = UIColor.lightGrayColor()
        // create buttons
        let midRowButtonTitles = ["A", "S", "D", "F", "G", "H", "J", "K", "P"]
        let midRowButtons = createButtons(midRowButtonTitles)
        // create touch buttons
        var midRowTouchButtons: [UIView] = wrapButtons(midRowButtons)
        for button in midRowTouchButtons {
            midRowView.addSubview(button)
        }
        
        self.inputView!.addSubview(midRowView)
        self.midRowView = midRowView
        
        // create bottom row buttons
        
        // empty array to eventually contain
        // all bottom row buttons
        
        var bottomRowButtons = [UIView]()
        
        
        
        // add letter buttons to bottom row
        
        let bottomRowLetterTitles = ["Z", "X", "C", "V", "B", "N", "M", "L"]
        let bottomRowLettersButtons = createButtons(bottomRowLetterTitles)
        bottomRowButtons = bottomRowButtons + bottomRowLettersButtons
        // wrap these now so I can put them into the manager
        // without including the backspace key, which the manager
        // does not want because backspace is never hidden
        var bottomRowTouchButtons = wrapButtons(bottomRowButtons)
        
        // put letters and shiftkey in one array to control hiding
        manager.lettersAndShift = topRowTouchButtons + midRowTouchButtons + bottomRowTouchButtons
        
        // add backspace key to bottom row
        
        let backspaceImage = UIImage(named: "backspaceOff")
        let backspaceKey = UIImageView(image: backspaceImage)
        setupImageView(backspaceKey)
        let backspaceTouchKey = UIView()
        backspaceTouchKey.addSubview(backspaceKey)
        backspaceKey.tag = UtilKey.backspaceKey.rawValue
        bottomRowButtons.append(backspaceKey)
        
        // add and configure long press recognizer
        let backspaceLongPressRecognizer = UILongPressGestureRecognizer(target: self, action: Selector("handleBackspaceLongPress:"))
        backspaceTouchKey.addGestureRecognizer(backspaceLongPressRecognizer)
        
        // put the backspace key in bottomRowTouchButtons now
        // because it still needs its constraints set later
        bottomRowTouchButtons.append(backspaceTouchKey)
        
        // create bottom row view and add all buttons to view
        
        let bottomRowView = UIView()
        bottomRowView.backgroundColor = UIColor.lightGrayColor()
        
        // create touch buttons
        // put each button in a touchview and add touchview to view
        for button in bottomRowTouchButtons {
            bottomRowView.addSubview(button)
        }
        
        self.inputView!.addSubview(bottomRowView)
        self.bottomRowView = bottomRowView
        
        // create util row buttons
        
        var utilRowButtons = [UIView]()
        
        // add shift key to util row
        
        let shiftImage = UIImage(named: "shiftOff")
        let shiftKey = UIImageView(image: shiftImage)
        setupImageView(shiftKey)
        shiftKey.tag = UtilKey.shiftKey.rawValue
        
        utilRowButtons.append(shiftKey)
        
        // save shift key as global to change image later
        manager.shiftKey = shiftKey
        
        // create numbersPunc key
        // add it to util row
        let numbersPuncKey = UIView()
        let numbersPuncKeyLabel = UILabel(frame: CGRectMake(0, 0, 60, 25))
        numbersPuncKeyLabel.translatesAutoresizingMaskIntoConstraints = false
        numbersPuncKeyLabel.text = "#+="
        numbersPuncKey.addSubview(numbersPuncKeyLabel)
        
        numbersPuncKey.backgroundColor = UIColor.grayColor()
        Appearance.setCornerRadius(numbersPuncKey)
        numbersPuncKey.translatesAutoresizingMaskIntoConstraints = false
        numbersPuncKey.tag = UtilKey.numbersPuncKey.rawValue
        
        utilRowButtons.append(numbersPuncKey)
        
        /// save global for label changing later
        manager
            .numbersPuncKey = numbersPuncKey
        
        // numbers key
        
        let numbersKey = UIView()
        let numbersKeyLabel = UILabel(frame: CGRectMake(0, 0, 60, 25))
        numbersKeyLabel.translatesAutoresizingMaskIntoConstraints = false
        numbersKeyLabel.text = "123"
        numbersKey.addSubview(numbersKeyLabel)
        
        numbersKey.backgroundColor = UIColor.grayColor()
        Appearance.setCornerRadius(numbersKey)
        numbersKey.translatesAutoresizingMaskIntoConstraints = false
        numbersKey.tag = UtilKey.numbersLettersKey.rawValue
        
        utilRowButtons.append(numbersKey)
        
        /// save later for label changing
        manager.numbersKey = numbersKey

        // next keyboard key
        
        let nextKeyboardImage = UIImage(named: "nextKeyboard")
        let nextKeyboardKey = UIImageView(image: nextKeyboardImage)
        setupImageView(nextKeyboardKey)
        
        nextKeyboardKey.tag = UtilKey.nextKeyboardKey.rawValue
        
        utilRowButtons.append(nextKeyboardKey)
        
        // spacebar
        
        let spacebarKey = UIView()
        
        let spacebarKeyLabel = UILabel(frame: CGRectMake(10.0, 10.0, 60, 25))
        spacebarKeyLabel.text = " "
        spacebarKey.addSubview(spacebarKeyLabel)
        
        // add spacebar logo
        let spacebarLogo = UIImageView(image: UIImage(named: "spaceKeyLogo"))
        spacebarLogo.translatesAutoresizingMaskIntoConstraints = false
        spacebarKey.addSubview(spacebarLogo)
        spacebarLogo.tag = 20 // to get it later when adding constraints
        
        spacebarKey.backgroundColor = UIColor.whiteColor()
        Appearance.setCornerRadius(spacebarKey)
        spacebarKey.translatesAutoresizingMaskIntoConstraints = false
        
        utilRowButtons.append(spacebarKey)
        
        // return key
        
        let returnImage = UIImage(named: "returnOff")
        let returnKey = UIImageView(image: returnImage)
        setupImageView(returnKey)
        returnKey.tag = UtilKey.returnKey.rawValue
        
        utilRowButtons.append(returnKey)
        
        // add util buttons to util view
        
        let utilRowView = UIView()
        utilRowView.backgroundColor = UIColor.lightGrayColor()
        
        let utilRowTouchButtons = wrapButtons(utilRowButtons)
        
        for button in utilRowTouchButtons {
            utilRowView.addSubview(button)
        }
        
        self.inputView!.addSubview(utilRowView)
        self.utilRowView = utilRowView
        
        // put shift into manager for hiding later
        manager.lettersAndShift.append(utilRowTouchButtons[0])
        
        // NUMBERS PAGE!!!
        
        // create top row numbers
        let topRowNumberButtonTitles = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
        let topRowNumberButtons = createButtons(topRowNumberButtonTitles)
        let topRowNumberTouchButtons = wrapButtons(topRowNumberButtons)
        
        for button in topRowNumberTouchButtons {
            topRowView.addSubview(button)
        }
        
        // create mid row numbers
        let midRowNumberButtonTitles = ["-", "/", ":", ";", "(", ")", "$", "&", "@", "\""]
        let midRowNumberButtons = createButtons(midRowNumberButtonTitles)
        let midRowNumberTouchButtons = wrapButtons(midRowNumberButtons)
        
        for button in midRowNumberTouchButtons {
            midRowView.addSubview(button)
        }
        
        // put top and mid number rows in one array for hiding later
        manager
            .numbersAndPuncs = topRowNumberTouchButtons + midRowNumberTouchButtons
        
        /// create bottom row numbers
        // this punctuation row does not have its own view
        // it goes into the bottomRowView, but it will be hidden to start
        let bottomRowNumberButtonTitles = [".", ",", "?", "!", "'"]
        var bottomRowNumberButtons = createButtons(bottomRowNumberButtonTitles)
        var bottomRowNumberTouchButtons = wrapButtons(bottomRowNumberButtons)
        
        for button in bottomRowNumberTouchButtons {
            bottomRowView.addSubview(button)
        }
        
        
        // put ". < ? ..." and numbersPuncKey in one array for hiding later
        manager
            .lowerPuncsAndNumbersPuncKey = bottomRowNumberTouchButtons + [utilRowTouchButtons[1]]
        
        // PUNCTUATION PAGE !!!
        
        // create top row punc
        let topRowPuncButtonTitles = ["[", "]", "{", "}", "#", "%", "^", "*", "+", "="]
        let topRowPuncButtons = createButtons(topRowPuncButtonTitles)
        let topRowPuncTouchButtons = wrapButtons(topRowPuncButtons)
        
        for button in topRowPuncTouchButtons {
            topRowView.addSubview(button)
        }
        
        // create mid row punc
        let euro = "\u{20AC}"
        let pound = "\u{00A3}"
        let yen = "\u{00A5}"
        let bullet = "\u{2022}"
        let midRowPuncButtonTitles = ["_", "\\", "|", "~", "<", ">", euro, pound, yen, bullet]
        let midRowPuncButtons = createButtons(midRowPuncButtonTitles)
        let midRowPuncTouchButtons = wrapButtons(midRowPuncButtons)
        
        for button in midRowPuncTouchButtons {
            midRowView.addSubview(button)
        }
        
        // put punc page in one array for hiding later
        manager
            .puncs = topRowPuncTouchButtons + midRowPuncTouchButtons
        
        // add constraints for rows in superview
        let rows = [[self.topRowView], [self.midRowView], [self.bottomRowView], [self.utilRowView]]
        
        for row in rows {
            for view in row {
                view.translatesAutoresizingMaskIntoConstraints = false
            }
        }
        ConstraintMaker.addRowConstraintsToSuperview(rows, containingView: self.inputView!)
        
        // SET CONSTRAINTS ON TOUCH AND DISPLAY BUTTONS
        // turn off autoresizingIntoConstraints then add constraints
        autoresizeIntoConstraintsOff(topRowTouchButtons)
        autoresizeIntoConstraintsOff(midRowTouchButtons)
        autoresizeIntoConstraintsOff(bottomRowTouchButtons)
        autoresizeIntoConstraintsOff(utilRowTouchButtons)
        autoresizeIntoConstraintsOff(topRowNumberTouchButtons)
        autoresizeIntoConstraintsOff(midRowNumberTouchButtons)
        autoresizeIntoConstraintsOff(bottomRowNumberTouchButtons)
        autoresizeIntoConstraintsOff(topRowPuncTouchButtons)
        autoresizeIntoConstraintsOff(midRowPuncTouchButtons)
        ConstraintMaker.addAllButtonConstraints(topRowView, midRowView: midRowView, bottomRowView: bottomRowView, utilRowView: utilRowView, topLetters: topRowButtons, midLetters: midRowButtons, bottomLettersShiftBackspace: bottomRowButtons, utilKeys: utilRowButtons, topNumbers: topRowNumberButtons, midNumbers: midRowNumberButtons, bottomPuncAndNumbersPuncKey: bottomRowNumberButtons, topPuncs: topRowPuncButtons, midPuncs: midRowPuncButtons, topTouchLetters: topRowTouchButtons, midTouchLetters: midRowTouchButtons, bottomTouchLettersShiftBackspace: bottomRowTouchButtons, utilTouchKeys: utilRowTouchButtons, topTouchNumbers: topRowNumberTouchButtons, midTouchNumbers: midRowNumberTouchButtons, bottomTouchPuncAndNumbersPuncKey: bottomRowNumberTouchButtons, topTouchPuncs: topRowPuncTouchButtons, midTouchPuncs: midRowPuncTouchButtons, betweenSpace: 3, shiftWidth: 0.05, nextKeyboardWidth: 0.12, spaceKeyWidth: 0.45, charVerticalConstant: -5)
        
        // do startup hiding
        manager.loadStart()
    }
    
    func setupImageView(view: UIImageView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        Appearance.setCornerRadius(view)
        view.contentMode = UIViewContentMode.Center
        view.backgroundColor = UIColor.grayColor()
    }
    
    func wrapButtons (buttons: [UIView]) -> [UIView] {
        var touchViews: [UIView] = [UIView]()
        for button in buttons {
                let touchView = UIView()
                touchView.addSubview(button)
                touchViews.append(touchView)
                button.translatesAutoresizingMaskIntoConstraints = false
        }
        return touchViews
    }
    
    func createButtons(titles: [String]) -> [UIView] {
        
        var buttons = [UIView]()
        
        for title in titles {
            
            let button = UIView()
            let label = UILabel(frame: CGRectMake(0, 0, 20, 20))
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = title
            label.font = label.font.fontWithSize(21)
            button.userInteractionEnabled = false
            button.addSubview(label)
            
            // button appearance config
            button.backgroundColor = UIColor.whiteColor()
            Appearance.setCornerRadius(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            
            // add button to return array
            buttons.append(button)
        }
        
        return buttons
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
            if subview.pointInside(touchPoint, withEvent: event) && !subview.hidden && subview.subviews[0].tag == 0 {
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
        let buttonLabel = view.subviews[0].subviews[0] as! UILabel
        let currButtonLabel = buttonLabel.text!
        let character = manager.isShift ? currButtonLabel : currButtonLabel.lowercaseString
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
        
        // !!!!!!!!!!!!!!!!!!!
        // Clean this code up down here. Pull out subviews[0] into
        // a variable so I don't have to keep pulling it out
        // 20160817
        // !!!!!!!!!!!!!!!!!!!
        
        // check each uiview for touch
        for subview in subviews {
            let touchPoint = touches.first!.locationInView(subview)
            if subview.pointInside(touchPoint, withEvent: event) && !subview.hidden {
                if (subview.subviews[0].tag != 0) {
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
                    let buttonLabel = subview.subviews[0].subviews[0] as! UILabel
                    let currButtonLabel = buttonLabel.text!
                    let character = manager.isShift ? currButtonLabel: currButtonLabel.lowercaseString
                    self.textDocumentProxy.insertText(character)
                    isTouchInButton = true
                    self.prevButton = currButtonLabel
                    subview.subviews[0].backgroundColor = UIColor.blackColor()
                    buttonLabel.textColor = UIColor.whiteColor()
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
        let tag = key.subviews[0].tag
        print(tag)
        switch tag {
        case UtilKey.nextKeyboardKey.rawValue:
            self.advanceToNextInputMode()
        case UtilKey.shiftKey.rawValue:
            // change shift key image
            // set global boolean
            if manager.isShift {
                manager.shiftOff()
            } else {
                manager.shiftOn()
            }
        case UtilKey.returnKey.rawValue:
            self.textDocumentProxy.insertText("\n")
        case UtilKey.backspaceKey.rawValue:
            self.textDocumentProxy.deleteBackward()
        case UtilKey.numbersLettersKey.rawValue:
            if manager.isNumbersPage {
                // switch back to letters page
                manager.goToLettersPage()
            } else {
                // switch to numbers page
                manager.goToNumbersPage()
            }
        case UtilKey.numbersPuncKey.rawValue:
            if manager.isPuncsPage {
                manager.goToNumbersPage()
            } else {
                manager.goToPuncsPage()
            }
        default:
            return
        }
    }
    
    func startLongDelete() {
        longDeleteTimer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self.textDocumentProxy, selector: Selector("deleteBackward"), userInfo: nil, repeats: true)
    }
    
    func stopLongDelete() {
        print("stoplongdelete fired")
        longDeleteTimer.invalidate()
        longDeleteTimer = nil
    }
    
    func handleBackspaceLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.Began {
            startLongDelete()
        } else if sender.state == UIGestureRecognizerState.Ended {
            stopLongDelete()
        }
    }
    
    func autoresizeIntoConstraintsOff (views: [UIView]) {
        for view in views {
            view.translatesAutoresizingMaskIntoConstraints = false
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
