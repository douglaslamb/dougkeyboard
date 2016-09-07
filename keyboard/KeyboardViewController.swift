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
    var topRowView: UIView!
    var midRowView: UIView!
    var bottomRowView: UIView!
    var utilRowView: UIView!
    var textRowView: UIView!
    
    // global UI
    var doubleTapRecognizer: UITapGestureRecognizer!
    
    // global vars
    var prevButton = ""
    var prevDisplayButton: UIView?
    var disableTouch = false
    var manager: KeyboardManager = KeyboardManager()
    var longDeleteTimer: NSTimer! = nil
    var isSpaceShift = false
    var firstTouchPoint: CGPoint? = nil
    var textAidProxy: TextAidProxy!
    
    // global constants
    let evenUnpressedFontSize = CGFloat(18.0)
    let oddUnpressedFontSize = CGFloat(18.0)
    let pressedFontSize = CGFloat(25.0)
    let minFirstTouchDistance = CGFloat(324)
    
    // colors
    // make sure to get rid of these uiviews
    // that are invisible once I know I don't need them
    let pressedBackgroundColor = UIColor.init(white: 1, alpha: 0.0)
    let pressedTextColor = UIColor.init(white: 0.2, alpha: 1)
    let unpressedBackgroundColor = UIColor.init(white: 0.5, alpha: 0.0)
    let unpressedTextColor = UIColor.init(white: 0, alpha: 1)
    let defaultBackgroundColor = UIColor.init(white: 1.0, alpha: 1)
    let verticalGuideColor = UIColor.init(white: 0.0, alpha: 1)
    let evenColumnUnpressedTextColor = UIColor.init(white: 0.0, alpha: 1)
    let evenColumnPressedTextColor = UIColor.init(white: 0.0, alpha: 1)
    let oddColumnUnpressedTextColor = UIColor.init(white: 0.2, alpha: 1)
    let oddColumnPressedTextColor = UIColor.init(white: 0.2, alpha: 1)
    let evenGuideColor = UIColor.init(white: 0.5, alpha: 1)
    let evenGuideAnimationColor = UIColor.init(white: 0.9, alpha: 1)
    let oddGuideColor = UIColor.whiteColor()
    let oddGuideAnimationColor = UIColor.init(white: 0.1, alpha: 1)
    
    enum UtilKey: Int {
        case nextKeyboardKey = 1, returnKey, shiftKey, backspaceKey, numbersLettersKey, numbersPuncKey
    }
    
    enum LetterIdentifier: Int {
        case oddRowKey = 1, evenRowKey
    }

    override func updateViewConstraints() {
        super.updateViewConstraints()
    
        // Add custom view sizing constraints here
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initial setup
        inputView?.backgroundColor = defaultBackgroundColor
        
        // create vertical guides
        var verticalGuideViews = [UIView]()
        
        for i in 0..<9 {
            let view = UIView()
            var thisGuideColor: UIColor
            var thisGuideAnimationColor: UIColor
            if i % 2 == 0 {
                thisGuideColor = evenGuideColor
                thisGuideAnimationColor = evenGuideAnimationColor
            } else {
                thisGuideColor = oddGuideColor
                thisGuideAnimationColor = oddGuideAnimationColor
            }
            view.backgroundColor = thisGuideColor
            verticalGuideViews.append(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.userInteractionEnabled = false
            self.inputView!.addSubview(view)
        }
    
        manager.guides = verticalGuideViews
        
        // create text row view
        
        let textRowView = UIView()
        textRowView.userInteractionEnabled = false
        self.inputView!.addSubview(textRowView)
        
        let textAid = UILabel()
        textAid.translatesAutoresizingMaskIntoConstraints = false
        textAid.userInteractionEnabled = false
        textRowView.addSubview(textAid)
        // textAidProxy wrapper for textaid uilabel
        textAidProxy = TextAidProxy(inLabel: textAid, inDocumentProxy: self.textDocumentProxy)
        
        // create top row view
        let topRowView = UIView()
        topRowView.opaque = false
        // create buttons
        let topRowButtonTitles = ["Q", "W", "E", "R", "T", "Y", "U", "I", "O"]
        let topRowButtons = createButtons(topRowButtonTitles)
        makeLetterButtonsAlternateColors(topRowButtons)
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
        midRowView.opaque = false
        // create buttons
        let midRowButtonTitles = ["A", "S", "D", "F", "G", "H", "J", "K", "P"]
        let midRowButtons = createButtons(midRowButtonTitles)
        makeLetterButtonsAlternateColors(midRowButtons)
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
        makeLetterButtonsAlternateColors(bottomRowLettersButtons)
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
        bottomRowView.opaque = false
        
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
        
        /// !!!!! maybe change this back!!!! 20160903
        //numbersPuncKey.backgroundColor = UIColor.grayColor()
        numbersPuncKey.opaque = false
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
        
        /// !!!!! maybe change this back!!!! 20160903
        //numbersKey.backgroundColor = UIColor.grayColor()
        numbersKey.opaque = false
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
        utilRowView.opaque = false
        
        let utilRowTouchButtons = wrapButtons(utilRowButtons)
        
        // add spacebar double tap recognizer
        doubleTapRecognizer = UITapGestureRecognizer(target: self, action: Selector("insertDoubleTapPeriod:"))
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.delaysTouchesEnded = false
        utilRowTouchButtons[4].addGestureRecognizer(doubleTapRecognizer)
        
        for button in utilRowTouchButtons {
            utilRowView.addSubview(button)
        }
        
        self.inputView!.addSubview(utilRowView)
        self.utilRowView = utilRowView
        
        // put shift into manager for hiding later
        manager.lettersAndShift.append(utilRowTouchButtons[0])
        
        // NUMBERS PAGE!!!
        
        // create top row numbers
        let topRowNumberButtonTitles = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
        let topRowNumberButtons = createButtons(topRowNumberButtonTitles)
        makeLetterButtonsAlternateColors(topRowNumberButtons)
        let topRowNumberTouchButtons = wrapButtons(topRowNumberButtons)
        
        for button in topRowNumberTouchButtons {
            topRowView.addSubview(button)
        }
        
        // create mid row numbers
        let midRowNumberButtonTitles = ["-", "/", ":", ";", "(", ")", "$", "&", "0"]
        let midRowNumberButtons = createButtons(midRowNumberButtonTitles)
        makeLetterButtonsAlternateColors(midRowNumberButtons)
        let midRowNumberTouchButtons = wrapButtons(midRowNumberButtons)
        
        for button in midRowNumberTouchButtons {
            midRowView.addSubview(button)
        }
        
        /// create bottom row numbers
        // this punctuation row does not have its own view
        // it goes into the bottomRowView, but it will be hidden to start
        let bottomRowNumberButtonTitles = [".", ",", "?", "!", "'", "\"", "@", ""]
        var bottomRowNumberButtons = createButtons(bottomRowNumberButtonTitles)
        makeLetterButtonsAlternateColors(bottomRowNumberButtons)
        var bottomRowNumberTouchButtons = wrapButtons(bottomRowNumberButtons)
        
        for button in bottomRowNumberTouchButtons {
            bottomRowView.addSubview(button)
        }
        
        // THIS NEXT LINE NEEDS TO BE HERE instead of with the rest of the midrow stuff
        // bc of how I'm adding these to the manager
        // and the constraintMaker later
        // put top and mid number rows in one array for hiding later
        manager
            .numbersAndPuncs = topRowNumberTouchButtons + midRowNumberTouchButtons + Array(bottomRowNumberTouchButtons[5...7])
        
        // put ". < ? ..." and numbersPuncKey in one array for hiding later
        manager
            .lowerPuncsAndNumbersPuncKey = Array(bottomRowNumberTouchButtons[0..<5]) + [utilRowTouchButtons[1]]
        
        // PUNCTUATION PAGE !!!
        
        // create top row punc
        let bullet = "\u{2022}"
        let topRowPuncButtonTitles = ["[", "]", "{", "}", "#", "%", "^", "*", bullet]
        let topRowPuncButtons = createButtons(topRowPuncButtonTitles)
        makeLetterButtonsAlternateColors(topRowPuncButtons)
        let topRowPuncTouchButtons = wrapButtons(topRowPuncButtons)
        
        for button in topRowPuncTouchButtons {
            topRowView.addSubview(button)
        }
        
        // create mid row punc
        let euro = "\u{20AC}"
        let pound = "\u{00A3}"
        let yen = "\u{00A5}"
        let midRowPuncButtonTitles = ["_", "\\", "|", "~", "<", ">", euro, pound, yen]
        let midRowPuncButtons = createButtons(midRowPuncButtonTitles)
        makeLetterButtonsAlternateColors(midRowPuncButtons)
        let midRowPuncTouchButtons = wrapButtons(midRowPuncButtons)
        
        for button in midRowPuncTouchButtons {
            midRowView.addSubview(button)
        }
        
        //create bottom row punc
        let bottomRowPuncButtonTitles = ["+", "="]
        let bottomRowPuncButtons = createButtons(bottomRowPuncButtonTitles)
        for (i, button) in bottomRowPuncButtons.enumerate() {
            let label = button.subviews[0] as! UILabel
            // This even/odd arrangement seems wrong
            // but for these two buttons it is right
            if i % 2 == 0 {
                label.textColor = oddColumnUnpressedTextColor
                label.tag = LetterIdentifier.oddRowKey.rawValue
            } else {
                label.textColor = evenColumnUnpressedTextColor
                label.tag = LetterIdentifier.evenRowKey.rawValue
            }
        }
        let bottomRowPuncTouchButtons = wrapButtons(bottomRowPuncButtons)
        
        for button in bottomRowPuncTouchButtons {
            bottomRowView.addSubview(button)
        }
        
        // put punc page in one array for hiding later
        manager
            .puncs = topRowPuncTouchButtons + midRowPuncTouchButtons + bottomRowPuncTouchButtons
        
        // add constraints for rows in superview
        let rows = [[textRowView], [self.topRowView], [self.midRowView], [self.bottomRowView], [self.utilRowView]]
        
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
        autoresizeIntoConstraintsOff(bottomRowPuncTouchButtons)
        ConstraintMaker.addAllButtonConstraints(topRowView, midRowView: midRowView, bottomRowView: bottomRowView, utilRowView: utilRowView, verticalGuideViews: verticalGuideViews, topLetters: topRowButtons, midLetters: midRowButtons, bottomLettersShiftBackspace: bottomRowButtons, utilKeys: utilRowButtons, topNumbers: topRowNumberButtons, midNumbers: midRowNumberButtons, bottomPuncAndNumbersPuncKey: bottomRowNumberButtons, topPuncs: topRowPuncButtons, midPuncs: midRowPuncButtons, bottomPuncs: bottomRowPuncButtons, topTouchLetters: topRowTouchButtons, midTouchLetters: midRowTouchButtons, bottomTouchLettersShiftBackspace: bottomRowTouchButtons, utilTouchKeys: utilRowTouchButtons, topTouchNumbers: topRowNumberTouchButtons, midTouchNumbers: midRowNumberTouchButtons, bottomTouchPuncAndNumbersPuncKey: bottomRowNumberTouchButtons, topTouchPuncs: topRowPuncTouchButtons, midTouchPuncs: midRowPuncTouchButtons, bottomTouchPuncs: bottomRowPuncTouchButtons, betweenSpace: 0, shiftWidth: 0.05, nextKeyboardWidth: 0.12, spaceKeyWidth: 0.45, charVerticalConstant: 0)
        ConstraintMaker.addTexRowViewConstraints(textRowView)
        
        // do startup hiding
        manager.loadStart()
        if self.textDocumentProxy.keyboardType == UIKeyboardType.NumberPad {
            manager.goToNumbersPage()
        }
    }
    
    func insertDoubleTapPeriod(sender: UITapGestureRecognizer) {
        self.textDocumentProxy.deleteBackward()
        self.textDocumentProxy.deleteBackward()
        textAidProxy.deleteBackward()
        textAidProxy.deleteBackward()
        self.textDocumentProxy.insertText(".")
        textAidProxy.insertText(".")
        isSpaceShift = false
    }
    
    func setupImageView(view: UIImageView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        Appearance.setCornerRadius(view)
        view.contentMode = UIViewContentMode.Center
        // !!!!!!!!! MADE THIS OPAQUE SLOPPILY. remove the background color setting if need be
        view.opaque = false
        //view.backgroundColor = UIColor.grayColor()
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
        
        for (i, title) in titles.enumerate() {
            
            let button = UIView()
            let label = UILabel(frame: CGRectMake(0, 0, 20, 20))
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = title
            if i % 2 == 0 {
                label.font = label.font.fontWithSize(evenUnpressedFontSize)
            } else {
                label.font = label.font.fontWithSize(oddUnpressedFontSize)
            }
            button.userInteractionEnabled = false
            button.addSubview(label)
            
            // button appearance config
            button.backgroundColor = unpressedBackgroundColor
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
        // if touch point is not some distance away
        // firstTouchPoint return and do nothing
        if firstTouchPoint != nil {
            let touchPoint = touches.first!.locationInView(inputView)
            let firstTouchDistance = pow(touchPoint.x - firstTouchPoint!.x, 2) + pow(touchPoint.y - firstTouchPoint!.y, 2)
            print(sqrt(firstTouchDistance))
            if firstTouchDistance < minFirstTouchDistance {
                return
            } else {
                firstTouchPoint = nil
            }
        }
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
                textAidProxy.deleteBackward()
                self.prevButton = ""
                makePrevKeyUnpressed(false)
            }
        }
    }
    
    func handleTouchMoveInButton(view: UIView) {
        let displayButton = view.subviews[0]
        let buttonLabel = displayButton.subviews[0] as! UILabel
        let currButtonLabel = buttonLabel.text!
        // if touch is in spacebar return early
        if currButtonLabel == " " {
            return
        }
        let character = manager.isShift ? currButtonLabel : currButtonLabel.lowercaseString
        // checking if we insert text or
        // delete and insert text
        if (self.prevButton != currButtonLabel) {
            // if the current button is not the previous
            if (self.prevButton == "") {
                // if the previous button was outside buttons
                self.textDocumentProxy.insertText(character)
                textAidProxy.insertText(character)
            } else {
                // in this case the previous button
                // was a different character.
                // i.e. slide from button to button
                self.textDocumentProxy.deleteBackward()
                textAidProxy.deleteBackward()
                self.textDocumentProxy.insertText(character)
                textAidProxy.insertText(character)
                makePrevKeyUnpressed(false)
            }
            makeKeyPressed(displayButton)
            self.prevButton = currButtonLabel
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // get location of touch
            firstTouchPoint = touches.first!.locationInView(inputView)
            print(firstTouchPoint)
        // gather subviews
        let subviews = self.topRowView.subviews + self.midRowView.subviews + self.bottomRowView.subviews + self.utilRowView.subviews
        var isTouchInButton = false
        
        // !!!!!!!!!!!!!!!!!!!
        // Clean this code up down here. Pull out subviews[0] into
        // a variable so I don't have to keep pulling it out
        // 20160817
        // !!!!!!!!!!!!!!!!!!!
        
        if prevDisplayButton != nil {
            makePrevKeyUnpressed(false)
        }
        
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
                    // return
                } else {
                    let displayButton = subview.subviews[0]
                    let buttonLabel = displayButton.subviews[0] as! UILabel
                    let currButtonLabel = buttonLabel.text!
                    let character = manager.isShift || isSpaceShift ? currButtonLabel: currButtonLabel.lowercaseString
                    // !!! put code for cancelling double touch
                    // here
                    if prevButton == " " && {
                        doubleTapRecognizer.enabled = false
                        doubleTapRecognizer.enabled = true
                    }
                    if isSpaceShift {
                        self.textDocumentProxy.deleteBackward()
                        textAidProxy.deleteBackward()
                    }
                    print(character)
                    self.textDocumentProxy.insertText(character)
                    textAidProxy.insertText(character)
                    isTouchInButton = true
                    self.prevButton = currButtonLabel
                    makeKeyPressed(displayButton)
                    if currButtonLabel == " " {
                        isSpaceShift = true
                    }
                    // found the button so return
                    // return
                }
            }
        }
        if (!isTouchInButton) {
            self.prevButton = ""
        }
    }
    
    func makeLetterButtonsAlternateColors (buttons: [UIView]) {
        // change letters in columns to correct color
        // and put a tag on UILabel so correct colors
        // can be used on and after keypress
        for (i, button) in buttons.enumerate() {
            let buttonLabel = button.subviews[0] as! UILabel
            if i % 2 == 0 {
                buttonLabel.textColor = evenColumnUnpressedTextColor
                buttonLabel.tag = LetterIdentifier.evenRowKey.rawValue
            } else {
                buttonLabel.textColor = oddColumnUnpressedTextColor
                buttonLabel.tag = LetterIdentifier.oddRowKey.rawValue
            }
        }
        
    }
    
    func makeKeyPressed(button: UIView) {
        // change button to pressed color
        let buttonLabel = button.subviews[0] as! UILabel
        // ignore the spacebar
        if buttonLabel.text != " " {
            button.backgroundColor = pressedBackgroundColor
            if buttonLabel.tag == LetterIdentifier.oddRowKey.rawValue {
                buttonLabel.textColor = oddColumnPressedTextColor
            } else if buttonLabel.tag == LetterIdentifier.evenRowKey.rawValue {
                buttonLabel.textColor = evenColumnPressedTextColor
            } else {
                buttonLabel.textColor = pressedTextColor
            }
            // save new button as prevDisplayButton
        }
        prevDisplayButton = button
    }
    
    func makePrevKeyUnpressed(lag: Bool) {
        let button = prevDisplayButton
        let buttonLabel = button?.subviews[0] as! UILabel
        // ignore the spacebar
        if buttonLabel.text != " " {
            let changeAppearance: () -> Void = {
                () -> Void in
                button?.backgroundColor = self.unpressedBackgroundColor
                if buttonLabel.tag == LetterIdentifier.oddRowKey.rawValue {
                    buttonLabel.textColor = self.oddColumnUnpressedTextColor
                } else if buttonLabel.tag == LetterIdentifier.evenRowKey.rawValue {
                    buttonLabel.textColor = self.evenColumnUnpressedTextColor
                } else {
                    buttonLabel.textColor = self.unpressedTextColor
                }
            }
            // change button to unpressed color
            if lag {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.06 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), changeAppearance)
            } else {
                changeAppearance()
            }
        }
        // nil prev button
        prevDisplayButton = nil
    }
    
    func doKeyFunction(key: UIView) {
        // handler function for function keys like shift
        let tag = key.subviews[0].tag
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
            textAidProxy.clear()
        case UtilKey.backspaceKey.rawValue:
            self.textDocumentProxy.deleteBackward()
            textAidProxy.deleteBackward()
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
        longDeleteTimer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: Selector("sendDeleteMessages"), userInfo: nil, repeats: true)
    }
    
    func sendDeleteMessages() {
        // FUNCTION WAS CREATED ONLY FOR startLongDelete
        // BECAUSE startLongDelete NEEDS IT
        // bc NSTimers cannot call more than one method
        self.textDocumentProxy.deleteBackward()
        textAidProxy.deleteBackward()
    }
    
    func stopLongDelete() {
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
        if prevDisplayButton != nil && event?.allTouches()?.count < 2 {
            makePrevKeyUnpressed(true)
            if manager.isShift {
                manager.shiftOff()
            }
        }
        if prevButton == " " && manager.isNumbersPage {
            manager.goToLettersPage()
        }
        if isSpaceShift {
            isSpaceShift = false
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
        textAidProxy.clear()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        ConstraintMaker.setWindowHeight(inputView!)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print(inputView!.frame.height)
    }
}
