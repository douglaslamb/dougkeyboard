//
//  KeyboardViewController.swift
//  keyboard
//
//  Created by rocker on 20160622.
//  Copyright © 2016 rocker. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController {
    
    // views
    var textRowView: UIView!
    var topRowView: UIView!
    var midRowView: UIView!
    var bottomRowView: UIView!
    var utilRowView: UIView!
    
    // objects
    var textProxy: UIKeyInput!
    var manager: KeyboardManager = KeyboardManager()
    var tutRunner: TutRunner!
    
    // global UI
    var doubleTapRecognizer: UITapGestureRecognizer!
    var tutDoubleTapRecognizer: UITapGestureRecognizer!
    var showCharsDoubleTapRecognizer: UITapGestureRecognizer!
    var nextKBDoubleTapRecognizer: UITapGestureRecognizer!
    var spacebarTouchButton: UIView!
    
    // global vars
    var prevButton = ""
    var disableTouch = false
    var longDeleteTimer: NSTimer!
    var isSpaceShift = false
    var firstTouchPoint: CGPoint?
    var doubleTapPuncModifier: Int?
    
    // global constants
    let minFirstTouchDistance = CGFloat(361)
    
    // appearance
    let defaultFontSize = 18
    
    // colors
    let defaultBackgroundColor = UIColor.init(white: 1.0, alpha: 1)
    let evenColumnUnpressedTextColor = UIColor.init(white: 0.9, alpha: 1)
    let evenColumnPressedTextColor = UIColor.init(white: 0.0, alpha: 1)
    let oddColumnUnpressedTextColor = UIColor.init(white: 0.2, alpha: 1)
    let oddColumnPressedTextColor = UIColor.init(white: 0.2, alpha: 1)
    
    // real guide colors
    // !!! EXPERIMENTING
    let topRowEvenWhiteVal = 0.45
    let midRowEvenWhiteVal = 0.35
    let bottomRowEvenWhiteVal = 0.2
    let oddColumnWhiteVal = 1.0
    // !!!
    let topRowEvenColor = UIColor.init(white: 0.45, alpha: 1)
    let midRowEvenColor = UIColor.init(white: 0.35, alpha: 1)
    let bottomRowEvenColor = UIColor.init(white: 0.2, alpha: 1)
    let topRowOddColor = UIColor.init(white: 1.0, alpha: 1)
    let midRowOddColor = UIColor.init(white: 1.0, alpha: 1)
    let bottomRowOddColor = UIColor.init(white: 1.0, alpha: 1)
    
    // icon colors
    let negativeIconsColor = UIColor.init(white: 0.9, alpha: 1)
    let defaultIconsColor = UIColor.init(white: 0.0, alpha: 1)
    
    enum UtilKey: Int {
        case nextKeyboardKey = 1, returnKey, shiftKey, backspaceKey, numbersLettersKey, numbersPuncKey, showCharsKey, tutKey
    }
    
    enum LetterIdentifier: Int {
        case oddRowKey = 10, evenRowKey
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
    
        // Add custom view sizing constraints here
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initial setup
        inputView?.backgroundColor = defaultBackgroundColor
        
        // init row views
        textRowView = UIView()
        topRowView = UIView()
        midRowView = UIView()
        bottomRowView = UIView()
        utilRowView = UIView()
        
        // put in array for convenience
        let rowViews = [topRowView, midRowView, bottomRowView, utilRowView, textRowView]
        
        // add rowViews to inputview and set default settings
        for rowView in rowViews {
            inputView!.addSubview(rowView)
            setRowDefaults(rowView)
        }
        
        // create button arrays
        let topRowTouchButtons = createBlankTouchButtonsWithLabels(9)
        let midRowTouchButtons = createBlankTouchButtonsWithLabels(9)
        var bottomRowTouchButtons = createBlankTouchButtonsWithLabels(8)
        
        // add backspace key to bottom row
        let backspaceImage = UIImageView(image: UIImage(named: "backspaceOff"))
        backspaceImage.image = backspaceImage.image?.imageWithRenderingMode(.AlwaysTemplate)
        backspaceImage.tintColor = negativeIconsColor
        setupImageView(backspaceImage)
        let backspaceTouchKey = UIView()
        backspaceTouchKey.addSubview(backspaceImage)
        backspaceTouchKey.tag = UtilKey.backspaceKey.rawValue
        ConstraintMaker.centerViewInView(backspaceTouchKey, subview: backspaceImage)
        
        // add backspace to bottomRowTouchButtons
        bottomRowTouchButtons.append(backspaceTouchKey)
        
        // add and configure long press recognizer
        let backspaceLongPressRecognizer = UILongPressGestureRecognizer(target: self, action: Selector("handleBackspaceLongPress:"))
        backspaceTouchKey.addGestureRecognizer(backspaceLongPressRecognizer)
        
        // put touch buttons in manager for label switching
        manager.charTouchButtons = topRowTouchButtons + midRowTouchButtons + bottomRowTouchButtons 
        
        // put touch button labels in manager for label hiding
        var charTouchButtonLabels = [UILabel]()
        for view in manager.charTouchButtons[0..<manager.charTouchButtons.count - 1] {
            charTouchButtonLabels.append(view.subviews[0] as! UILabel)
        }
        manager.charTouchButtonLabels = charTouchButtonLabels 
        
        // add touchButtons to rowViews
        addSubviews(topRowView, subviews: topRowTouchButtons)
        addSubviews(midRowView, subviews: midRowTouchButtons)
        addSubviews(bottomRowView, subviews: bottomRowTouchButtons)
        
        // page labels chars
        let yen = "\u{00A5}"
        let pound = "\u{00A3}"
        let euro = "\u{20AC}"
        let bullet = "\u{2022}"
        manager.letterPageChars = ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "A",
                                   "S", "D", "F", "G", "H", "J", "K", "P", "Z", "X",
                                   "C", "V", "B", "N", "M", "L"]
 
        manager.numberPageChars = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "-", "/", ":", ";", "(", ")", "$", "&", "0", ".", ",", "?", "!", "'", "\"", "@", ""]
 
        manager.puncPageChars = ["[", "]", "{", "}", "#", "%", "^", "*", bullet, "_", "\\", "|", "~", "<", ">", euro, pound, yen, ".", ",", "?", "!", "'", "+", "=", ""]
        
        // add UIlabel to textRowView
        let textAidLabel = UILabel()
        textAidLabel.translatesAutoresizingMaskIntoConstraints = false
        textAidLabel.userInteractionEnabled = false
        textRowView.addSubview(textAidLabel)
        // add label to textProxy object
        let rawTextProxy = textProxy as! TextAidProxy
        rawTextProxy.label = textAidLabel
        
        // add labelMask to textRowView
        let labelMask = UIView()
        labelMask.translatesAutoresizingMaskIntoConstraints = false
        labelMask.userInteractionEnabled = false
        labelMask.backgroundColor = defaultBackgroundColor
        textRowView.addSubview(labelMask)
        
        // add tutMessageView to textRowView
        let tutMessageLabel = UILabel()
        tutMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        tutMessageLabel.userInteractionEnabled = false
        tutMessageLabel.backgroundColor = midRowEvenColor
        tutMessageLabel.textColor = UIColor.whiteColor()
        tutMessageLabel.layer.masksToBounds = true
        tutMessageLabel.layer.cornerRadius = 5
        tutMessageLabel.font = tutMessageLabel.font.fontWithSize(13)
        tutMessageLabel.textAlignment = NSTextAlignment.Center
        tutMessageLabel.numberOfLines = 0
        textRowView.addSubview(tutMessageLabel)
        
        // add showchars button to textRowView
        let showCharsTouchButton = createBlankTouchButton()
        showCharsTouchButton.translatesAutoresizingMaskIntoConstraints = false
        
        showCharsTouchButton.tag = UtilKey.showCharsKey.rawValue
        let showCharsImageView = UIImageView(image: UIImage(named: "cycleLabelsModeKey"))
        showCharsImageView.image = showCharsImageView.image?.imageWithRenderingMode(.AlwaysTemplate)
        showCharsImageView.tintColor = defaultIconsColor
        setupImageView(showCharsImageView)
        showCharsTouchButton.addSubview(showCharsImageView)
        ConstraintMaker.centerViewInView(showCharsTouchButton, subview: showCharsImageView)
        textRowView.addSubview(showCharsTouchButton)
        // add double tap recognizer
        showCharsDoubleTapRecognizer = UITapGestureRecognizer(target: self, action: Selector("userCycleLabelsDisplayMode:"))
        showCharsDoubleTapRecognizer.numberOfTapsRequired = 2
        showCharsDoubleTapRecognizer.delaysTouchesEnded = false
        showCharsTouchButton.addGestureRecognizer(showCharsDoubleTapRecognizer)
        
        // add tut button to textRowView
        let tutTouchButton = createBlankTouchButton()
        tutTouchButton.translatesAutoresizingMaskIntoConstraints = false
        
        tutTouchButton.tag = UtilKey.tutKey.rawValue
        let tutImageView = UIImageView(image: UIImage(named: "tutKey"))
        tutImageView.image = tutImageView.image?.imageWithRenderingMode(.AlwaysTemplate)
        tutImageView.tintColor = defaultIconsColor
        setupImageView(tutImageView)
        tutTouchButton.addSubview(tutImageView)
        ConstraintMaker.centerViewInView(tutTouchButton, subview: tutImageView)
        textRowView.addSubview(tutTouchButton)
        // add double tap recognizer
        tutDoubleTapRecognizer = UITapGestureRecognizer(target: self, action: Selector("startStopTut:"))
        tutDoubleTapRecognizer.numberOfTapsRequired = 2
        tutDoubleTapRecognizer.delaysTouchesEnded = false
        tutTouchButton.addGestureRecognizer(tutDoubleTapRecognizer)
        
        // create util row touch button array
        
        var utilRowTouchButtons = [UIView]()
        
        // add shiftOrNumbersPuncKey key to util row
        
        let shiftOrNumbersPuncTouchButton = createBlankTouchButton()
        shiftOrNumbersPuncTouchButton.tag = UtilKey.shiftKey.rawValue
        
        let shiftKeyImageView = UIImageView(image: UIImage(named: "shiftOff"))
        setupImageView(shiftKeyImageView)
        shiftOrNumbersPuncTouchButton.addSubview(shiftKeyImageView)
        
        // save shift key as global to change image later
        manager.shiftKeyImageView = shiftKeyImageView
        
        // create numbersPunc key
        // add it to util row
        let numbersPuncKeyLabel = UILabel(frame: CGRectMake(0, 0, 60, 25))
        setLabelDefaults(numbersPuncKeyLabel)
        numbersPuncKeyLabel.text = "#+="
        shiftOrNumbersPuncTouchButton.addSubview(numbersPuncKeyLabel)
        ConstraintMaker.centerViewInView(shiftOrNumbersPuncTouchButton, subview: shiftKeyImageView)
        ConstraintMaker.centerViewInView(shiftOrNumbersPuncTouchButton, subview: numbersPuncKeyLabel)
        
        // add shiftOrNumbersPuncKey and tags to manager
        manager.shiftKeyTag = UtilKey.shiftKey.rawValue
        manager.numbersPuncKeyTag = UtilKey.numbersPuncKey.rawValue
        manager.shiftOrNumbersPuncTouchButton = shiftOrNumbersPuncTouchButton
        
        utilRowTouchButtons.append(shiftOrNumbersPuncTouchButton)
        
        /// save global for label changing later
        manager.numbersPuncKeyLabel = numbersPuncKeyLabel
        
        // numbers key
        
        let numbersTouchButton = createBlankTouchButton()
        let numbersKeyLabel = UILabel(frame: CGRectMake(0, 0, 60, 25))
        setLabelDefaults(numbersKeyLabel)
        numbersKeyLabel.text = "123"
        numbersTouchButton.tag = UtilKey.numbersLettersKey.rawValue
        
        numbersTouchButton.addSubview(numbersKeyLabel)
        ConstraintMaker.centerViewInView(numbersTouchButton, subview: numbersKeyLabel)
        
        utilRowTouchButtons.append(numbersTouchButton)
        
        /// save later for label changing
        manager.numbersKeyLabel = numbersKeyLabel

        // next keyboard key
        
        let nextKeyboardTouchButton = createBlankTouchButton()
        
        let nextKeyboardImageView = UIImageView(image: UIImage(named: "nextKeyboard"))
        setupImageView(nextKeyboardImageView)
        nextKeyboardTouchButton.tag = UtilKey.nextKeyboardKey.rawValue
        
        // add double tap recognizer
        nextKBDoubleTapRecognizer = UITapGestureRecognizer(target: self, action: Selector("advanceToNextInputMode"))
        nextKBDoubleTapRecognizer.numberOfTapsRequired = 2
        nextKBDoubleTapRecognizer.delaysTouchesEnded = false
        nextKeyboardTouchButton.addGestureRecognizer(nextKBDoubleTapRecognizer)
        
        nextKeyboardTouchButton.addSubview(nextKeyboardImageView)
        ConstraintMaker.centerViewInView(nextKeyboardTouchButton, subview: nextKeyboardImageView)
        
        utilRowTouchButtons.append(nextKeyboardTouchButton)
        
        // spacebar
        
        spacebarTouchButton = createBlankTouchButton()
        spacebarTouchButton.tag = 30    // to designate it as a text entering key
        
        let spacebarKeyLabel = UILabel(frame: CGRectMake(10.0, 10.0, 60, 25))
        spacebarKeyLabel.text = " "
        spacebarTouchButton.addSubview(spacebarKeyLabel)
        
        // add spacebar logo
        let spacebarLogo = UIImageView(image: UIImage(named: "spaceKeyLogo"))
        setupImageView(spacebarLogo)
        spacebarLogo.tag = 20 // to get it later when adding constraints
        spacebarTouchButton.addSubview(spacebarLogo)
        ConstraintMaker.centerViewInView(spacebarTouchButton, subview: spacebarLogo)
        
        // add spacebar double tap recognizer
        doubleTapRecognizer = UITapGestureRecognizer(target: self, action: Selector("insertDoubleTapPeriod:"))
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.delaysTouchesEnded = false
        spacebarTouchButton.addGestureRecognizer(doubleTapRecognizer)
        
        utilRowTouchButtons.append(spacebarTouchButton)
        
        // return key
        
        let returnTouchButton = createBlankTouchButton()
        returnTouchButton.tag = UtilKey.returnKey.rawValue
        
        let returnKeyImageView = UIImageView(image: UIImage(named: "returnOff"))
        setupImageView(returnKeyImageView)
        
        returnTouchButton.addSubview(returnKeyImageView)
        ConstraintMaker.centerViewInView(returnTouchButton, subview: returnKeyImageView)
        
        utilRowTouchButtons.append(returnTouchButton)
        
        // add utilRowTouch buttons to utilRowView
        
        for button in utilRowTouchButtons {
            utilRowView.addSubview(button)
        }
        
        // CASCADING GUIDES
        
        let evenColumnGuideWhiteVals = [topRowEvenWhiteVal, midRowEvenWhiteVal, bottomRowEvenWhiteVal]
        let baseFontSize: CGFloat = 12
        let scaleFactor = CGFloat(1.12)
        
        for (i, button) in manager.charTouchButtons.enumerate() {
            let yVal = i / 9
            let xVal = i % 9
            
            // font sizes get geometrically
            // larger farther from the textaid
             
            let xLoc = CGFloat(abs(xVal - 4))
            let yLoc = CGFloat(yVal + 1)
            let distance: CGFloat = sqrt(pow(2.0, xLoc) + pow(2.0, yLoc))
            let thisLabelFontSize = pow(scaleFactor, distance) * baseFontSize
            
            let label = button.subviews[0] as? UILabel
            if label != nil {
                label!.font = label!.font.fontWithSize(thisLabelFontSize)
            }
            
            // set background color
            
            var whiteVal: Double
            if xVal % 2 == 0 {
                whiteVal = evenColumnGuideWhiteVals[yVal]
                button.backgroundColor = UIColor.init(white: CGFloat(whiteVal), alpha: 1)
            } else {
                whiteVal = oddColumnWhiteVal
                button.backgroundColor = UIColor.init(white: CGFloat(whiteVal), alpha: 1)
            }
        }
        
        // set manager label display modes from user defaults
        let defaults = NSUserDefaults.standardUserDefaults()
        manager.lettersPageLabelsDisplayMode = defaults.integerForKey("lettersPageLabelsDisplayMode")
        manager.numbersPageLabelsDisplayMode = defaults.integerForKey("numbersPageLabelsDisplayMode")
        
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
        
        ConstraintMaker.addAllButtonConstraints(topRowView, midRowView: midRowView, bottomRowView: bottomRowView, utilRowView: utilRowView, topTouchButtons: topRowTouchButtons, midTouchButtons: midRowTouchButtons, bottomTouchButtons: bottomRowTouchButtons, utilTouchKeys: utilRowTouchButtons, shiftWidth: 0.05, nextKeyboardWidth: 0.12, spaceKeyWidth: 0.45, charVerticalConstant: 0)
        
        ConstraintMaker.addTextRowViewConstraints(textRowView, label: textAidLabel, labelMask: labelMask, tutMessageLabel: tutMessageLabel, showCharsButton: showCharsTouchButton, tutButton: tutTouchButton)
        
        // init tut runner
        tutRunner = TutRunner(buttons: topRowTouchButtons + midRowTouchButtons + bottomRowTouchButtons, label: rawTextProxy.label, tutMessageLabel: tutMessageLabel, keyboardManager: manager, showCharsDoubleTapRecognizer: showCharsDoubleTapRecognizer)
        rawTextProxy.tutRunner = tutRunner
        
        // do startup hiding
        manager.loadStart()
        
    }
    
    func startStopTut(sender: UITapGestureRecognizer) {
        if tutRunner.isRunning() {
            tutRunner.end()
        } else {
            tutRunner.run()
        }
    }
    
    func addSubviews(view: UIView, subviews: [UIView]) {
        for subview in subviews {
            view.addSubview(subview)
        }
    }
    
    func insertDoubleTapPeriod(sender: UITapGestureRecognizer) {
        let doubleTapPuncModifiers = [",", "'", "?", "!"]
        var deleteTimes: Int = 2
        var text: String
        
        // decide if a modifier is being pressed
        if doubleTapPuncModifier != nil {
            text = doubleTapPuncModifiers[doubleTapPuncModifier!]
            // if touch is in textRow or not
            if doubleTapPuncModifier != 3 {
                deleteTimes = 3
            }
        } else {
            text = "."
        }
        
        // then insert the character
        for _ in 0..<deleteTimes {
            textProxy.deleteBackward()
        }
        textProxy.insertText(text)
        isSpaceShift = false
        disableTouch = true
    }
    
    func setupImageView(view: UIImageView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = UIViewContentMode.Center
        view.userInteractionEnabled = false
    }
    
    func createBlankTouchButton() -> UIView {
        let button = UIView()
        setTouchButtonDefaults(button)
        return button
    }
    
    func createBlankTouchButtonsWithLabels(numButtons: Int) -> [UIView] {
        // creates a bunch of UIView
        // adds a label to each
        // and adds each to an array which is returned
        
        var buttons = [UIView]()
        for i in 0..<numButtons {
            let touchButton = createBlankTouchButton()
            let label = UILabel()
            buttons.append(touchButton)
            touchButton.addSubview(label)
            
            // set default properties
            setLabelDefaults(label)
            ConstraintMaker.centerViewInView(touchButton, subview: label)
            
            // !!! TEMP
            // temporarily using this evenRowKey value for each key
            // because the typing logic needs the tag to be above some number
            touchButton.tag = LetterIdentifier.evenRowKey.rawValue
        }
        return buttons
    }
    
    func setTouchButtonDefaults(button: UIView) {
    }
    
    func setLabelDefaults(label: UILabel) {
        label.userInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setRowDefaults(row: UIView) {
        row.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func cancelDoubleTap() {
        doubleTapRecognizer.enabled = false
        doubleTapRecognizer.enabled = true
    }
    
    func doKeyFunction(key: UIView) {
        if !(tutRunner.isRunning()) {
                let tag = key.tag
                switch tag {
            case UtilKey.shiftKey.rawValue:
                if manager.isShift {
                    manager.shiftOff()
                } else {
                    manager.shiftOn()
                }
            case UtilKey.returnKey.rawValue:
                textProxy.insertText("\n")
                prevButton = "\n"
            case UtilKey.backspaceKey.rawValue:
                textProxy.deleteBackward()
            case UtilKey.numbersLettersKey.rawValue:
                if manager.isNumbersPage() {
                    manager.goToLettersPage()
                } else {
                    manager.goToNumbersPage()
                }
            case UtilKey.numbersPuncKey.rawValue:
                if manager.isPuncsPage() {
                    manager.goToNumbersPage()
                } else {
                    manager.goToPuncsPage()
                }
            default:
                return
            }
        }
    }
    
    func startLongDelete() {
        longDeleteTimer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: Selector("sendDeleteMessages"), userInfo: nil, repeats: true)
    }
    
    func sendDeleteMessages() {
        // FUNCTION WAS CREATED ONLY FOR startLongDelete
        // BECAUSE startLongDelete NEEDS IT
        // bc NSTimers cannot call more than one method
        textProxy.deleteBackward()
    }
    
    func stopLongDelete() {
        longDeleteTimer.invalidate()
        longDeleteTimer = nil
    }
    
    func handleBackspaceLongPress(sender: UILongPressGestureRecognizer) {
        //print("handleBackspaceLongPress")
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
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print(arc4random())
        super.touchesBegan(touches, withEvent: event)
        
        // get view touch is in
        let touchPoint = touches.first!.locationInView(view)
        firstTouchPoint = touchPoint
        
        let viewArr = [bottomRowView, midRowView, topRowView, textRowView]
        for (i, rowView) in viewArr.enumerate() {
            if rowView.pointInside(view.convertPoint(touchPoint, toView: rowView), withEvent: nil) {
                doubleTapPuncModifier = i
            }
        }
    
        let touchView = view.hitTest(touchPoint, withEvent: nil)
        
        // check for nil for safety
        if touchView != nil {
            if (touchView!.tag < 9) {
                // disable touch so if user drags out of util
                // key it won't crash
                self.disableTouch = true;
                if prevButton == " " {
                    cancelDoubleTap()
                }
                self.prevButton = ""
                // pass to utility key function handler
                doKeyFunction(touchView!)
            } else {
                let buttonLabel = touchView!.subviews[0] as! UILabel
                let rawChar = buttonLabel.text!
                let character = manager.isShift || isSpaceShift ? rawChar: rawChar.lowercaseString
                if isSpaceShift {
                    textProxy.deleteBackward()
                }
                // cancel double tap recognizer
                // if a tap is detected not on space
                if prevButton == " " && character != " " {
                    cancelDoubleTap()
                }
                textProxy.insertText(character)
                self.prevButton = rawChar
                if rawChar == " " {
                    isSpaceShift = true
                }
            }
        } else {
            self.prevButton = ""
        }
    }
   
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesMoved(touches, withEvent: event)
        // if touch is disabled or if isSpaceShift return and do nothing
        if self.disableTouch || isSpaceShift {
            return
        }
        
        let touchPoint = touches.first!.locationInView(inputView)
        
        // if touch point is not some distance away
        // from firstTouchPoint return and do nothing
        if firstTouchPoint != nil {
            let firstTouchDistance = pow(touchPoint.x - firstTouchPoint!.x, 2) + pow(touchPoint.y - firstTouchPoint!.y, 2)
            if firstTouchDistance < minFirstTouchDistance {
                return
            } else {
                firstTouchPoint = nil
            }
        }
        
        // get view touch is in
        let touchView = view.hitTest(touchPoint, withEvent: nil)
        
        // if touch is in letter key, handleTouch
        // else if touch was just in a letter key, backspace.
        // check for nil for safety
        if touchView != nil {
            if touchView!.tag > 9 {
                handleTouchMoveInButton(touchView!)
            } else {
                if (prevButton != "") {
                    textProxy.deleteBackward()
                    self.prevButton = ""
                }
            }
        }
    }
    
    func handleTouchMoveInButton(view: UIView) {
        let buttonLabel = view.subviews[0] as! UILabel
        let rawChar = buttonLabel.text!
        // if touch is not in spacebar and
        // if touch is not in same button as last time
        if rawChar != " " && rawChar != self.prevButton {
            let character = manager.isShift || isSpaceShift ? rawChar : rawChar.lowercaseString
            if (self.prevButton == "") {
                // if the previous button was outside buttons
                textProxy.insertText(character)
            } else {
                // if user slides from one char to another
                textProxy.deleteBackward()
                textProxy.insertText(character)
            }
            self.prevButton = rawChar
        }
    }
    
    func userCycleLabelsDisplayMode(sender: UIGestureRecognizer) {
        manager.cycleLabelsDisplayMode()
    }
   
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        self.disableTouch = false;
        //if prevButton != "" && event?.allTouches()?.count < 2 {
        if prevButton != "" {
            if manager.isShift {
                manager.shiftOff()
            }
        }
        if (prevButton == " " || prevButton == "\n") && manager.isNumbersPage() {
            manager.goToLettersPage()
        }
        if isSpaceShift {
            isSpaceShift = false
            let touchPoint = touches.first!.locationInView(spacebarTouchButton)
            if prevButton != " " && prevButton != "" && spacebarTouchButton.pointInside(touchPoint, withEvent: nil) {
                print("spaceshift correction")
                textProxy.deleteBackward()
                textProxy.insertText(prevButton.lowercaseString)
            }
        }
        // set doubleTapPuncModifier to nil if touch ends outside spacebar
        let touchPoint = touches.first?.locationInView(spacebarTouchButton)
        if !spacebarTouchButton.pointInside(touchPoint!, withEvent: nil) {
            doubleTapPuncModifier = nil
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }

    override func textWillChange(textInput: UITextInput?) {
        super.textWillChange(textInput)
        // The app is about to change the document's contents. Perform any preparation here.
    }

    override func textDidChange(textInput: UITextInput?) {
        super.textDidChange(textInput)
        // The app has just changed the document's contents, the document context has been updated.
        let rawTextAidProxy = textProxy as! TextAidProxy
        rawTextAidProxy.refresh()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        ConstraintMaker.setWindowHeight(self.view)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // save labelsDisplayMode in user defaults
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(manager.lettersPageLabelsDisplayMode, forKey: "lettersPageLabelsDisplayMode")
        defaults.setInteger(manager.numbersPageLabelsDisplayMode, forKey: "numbersPageLabelsDisplayMode")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let rawTextAidProxy = textProxy as! TextAidProxy
        rawTextAidProxy.refresh()
    }
    
    override func loadView() {
        super.loadView()
        textProxy = TextAidProxy(documentProxy: textDocumentProxy)
    }
    
    override func advanceToNextInputMode() {
        super.advanceToNextInputMode()
        // end tutorial if running
        if tutRunner.isRunning() {
            tutRunner.end()
        }
    }
}
