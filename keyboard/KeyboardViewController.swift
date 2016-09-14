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
    var textRowView: UIView!
    var topRowView: UIView!
    var midRowView: UIView!
    var bottomRowView: UIView!
    var utilRowView: UIView!
    
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
    var textProxy: UIKeyInput!
    
    // global constants
    let minFirstTouchDistance = CGFloat(324)
    
    // appearance
    let defaultFontSize = 18
    
    // colors
    let defaultBackgroundColor = UIColor.init(white: 1.0, alpha: 1)
    let verticalGuideColor = UIColor.init(white: 0.0, alpha: 1)
    let evenColumnUnpressedTextColor = UIColor.init(white: 0.9, alpha: 1)
    let evenColumnPressedTextColor = UIColor.init(white: 0.0, alpha: 1)
    //20160909 let oddColumnUnpressedTextColor = UIColor.init(white: 0.2, alpha: 1)
    let oddColumnUnpressedTextColor = UIColor.init(white: 0.3, alpha: 1)
    let oddColumnPressedTextColor = UIColor.init(white: 0.2, alpha: 1)
    // 20160909 let evenGuideColor = UIColor.init(white: 0.5, alpha: 1)
    let evenGuideColor = UIColor.init(white: 0.3, alpha: 1)
    let evenGuideAnimationColor = UIColor.init(white: 0.9, alpha: 1)
    let oddGuideColor = UIColor.whiteColor()
    let oddGuideAnimationColor = UIColor.init(white: 0.1, alpha: 1)
    
    enum UtilKey: Int {
        case nextKeyboardKey = 1, returnKey, shiftKey, backspaceKey, numbersLettersKey, numbersPuncKey, showCharsKey
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
        
        // create vertical guides and add to view
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
        
        // put touch buttons in manager for label switching
        manager.charTouchButtons = topRowTouchButtons + midRowTouchButtons + bottomRowTouchButtons
        
        // add backspace key to bottom row
        let backspaceImage = UIImageView(image: UIImage(named: "backspaceOff"))
        backspaceImage.image = backspaceImage.image?.imageWithRenderingMode(.AlwaysTemplate)
        backspaceImage.tintColor = evenColumnUnpressedTextColor
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
        
        // put touch button labels in manager for label hiding
        var charTouchButtonLabels = [UIView]()
        for view in manager.charTouchButtons {
            charTouchButtonLabels.append(view.subviews[0])
        }
        manager.charTouchButtonLabels = charTouchButtonLabels + [backspaceImage]
        
        // add touchButtons to rowViews
        addSubviews(topRowView, subviews: topRowTouchButtons)
        addSubviews(midRowView, subviews: midRowTouchButtons)
        addSubviews(bottomRowView, subviews: bottomRowTouchButtons)
        
        // page labels chars
        let yen = "\u{00A5}"
        let pound = "\u{00A3}"
        let euro = "\u{20AC}"
        let bullet = "\u{2022}"
        manager.letterPageChars = ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "A", "S", "D", "F", "G", "H", "J", "K", "P", "Z", "X", "C", "V", "B", "N", "M", "L"]
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
        
        // add showchars button to textRowView
        let showCharsTouchButton = createBlankTouchButton()
        showCharsTouchButton.translatesAutoresizingMaskIntoConstraints = false
        
        showCharsTouchButton.tag = UtilKey.showCharsKey.rawValue
        let showCharsImageView = UIImageView(image: UIImage(named: "showCharsKey"))
        setupImageView(showCharsImageView)
        showCharsTouchButton.addSubview(showCharsImageView)
        ConstraintMaker.centerViewInView(showCharsTouchButton, subview: showCharsImageView)
        textRowView.addSubview(showCharsTouchButton)
        
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
        
        nextKeyboardTouchButton.addSubview(nextKeyboardImageView)
        ConstraintMaker.centerViewInView(nextKeyboardTouchButton, subview: nextKeyboardImageView)
        
        utilRowTouchButtons.append(nextKeyboardTouchButton)
        
        // spacebar
        
        let spacebarTouchButton = createBlankTouchButton()
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
        
        // add constraints for rows in superview
        var rows = [[textRowView], [self.topRowView], [self.midRowView], [self.bottomRowView], [self.utilRowView]]
        
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
        
        ConstraintMaker.addAllButtonConstraints(topRowView, midRowView: midRowView, bottomRowView: bottomRowView, utilRowView: utilRowView, verticalGuideViews: verticalGuideViews, topTouchButtons: topRowTouchButtons, midTouchButtons: midRowTouchButtons, bottomTouchButtons: bottomRowTouchButtons, utilTouchKeys: utilRowTouchButtons, betweenSpace: 0, shiftWidth: 0.05, nextKeyboardWidth: 0.12, spaceKeyWidth: 0.45, charVerticalConstant: 0)
        
        ConstraintMaker.addTextRowViewConstraints(textRowView, showCharsButton: showCharsTouchButton)
        
        // do startup hiding
        manager.loadStart()
        if self.textDocumentProxy.keyboardType == UIKeyboardType.NumberPad {
            manager.goToNumbersPage()
        }
    }
    
    func addSubviews(view: UIView, subviews: [UIView]) {
        for subview in subviews {
            view.addSubview(subview)
        }
    }
    
    func insertDoubleTapPeriod(sender: UITapGestureRecognizer) {
        textProxy.deleteBackward()
        textProxy.deleteBackward()
        textProxy.insertText(".")
        isSpaceShift = false
    }
    
    func setupImageView(view: UIImageView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = UIViewContentMode.Center
        view.opaque = false
        view.userInteractionEnabled = false
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
            
            // alternate column settings
            if i % 2 == 0 {
                label.textColor = evenColumnUnpressedTextColor
                touchButton.tag = LetterIdentifier.evenRowKey.rawValue
            } else {
                label.textColor = oddColumnUnpressedTextColor
                touchButton.tag = LetterIdentifier.oddRowKey.rawValue
            }
        }
        return buttons
    }
    
    func setTouchButtonDefaults(button: UIView) {
        button.opaque = false
    }
    
    func setLabelDefaults(label: UILabel) {
        label.userInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setRowDefaults(row: UIView) {
        row.opaque = false
    }
    
    func cancelDoubleTap() {
        doubleTapRecognizer.enabled = false
        doubleTapRecognizer.enabled = true
    }
    
    func makeKeyPressed(button: UIView) {
        // change button label to pressed color
        let buttonLabel = button.subviews[0] as! UILabel
        // ignore the spacebar
        if buttonLabel.text != " " {
            if button.tag == LetterIdentifier.oddRowKey.rawValue {
                buttonLabel.textColor = oddColumnPressedTextColor
            } else if button.tag == LetterIdentifier.evenRowKey.rawValue {
                buttonLabel.textColor = evenColumnPressedTextColor
            }
        }
        // save new button as prevDisplayButton
        prevDisplayButton = button
    }
    
    func makePrevKeyUnpressed(lag: Bool) {
        let button = prevDisplayButton
        let buttonLabel = button?.subviews[0] as! UILabel
        // ignore the spacebar
        if buttonLabel.text != " " {
            let changeAppearance: () -> Void = {
                () -> Void in
                if button!.tag == LetterIdentifier.oddRowKey.rawValue {
                    buttonLabel.textColor = self.oddColumnUnpressedTextColor
                } else if button!.tag == LetterIdentifier.evenRowKey.rawValue {
                    buttonLabel.textColor = self.evenColumnUnpressedTextColor
                }
            }
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
        let tag = key.tag
        switch tag {
        case UtilKey.nextKeyboardKey.rawValue:
            self.advanceToNextInputMode()
        case UtilKey.shiftKey.rawValue:
            if manager.isShift {
                manager.shiftOff()
            } else {
                manager.shiftOn()
            }
        case UtilKey.returnKey.rawValue:
            textProxy.insertText("\n")
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
        case UtilKey.showCharsKey.rawValue:
            manager.showHideLabels()
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
        textProxy.deleteBackward()
    }
    
    func stopLongDelete() {
        longDeleteTimer.invalidate()
        longDeleteTimer = nil
    }
    
    func handleBackspaceLongPress(sender: UILongPressGestureRecognizer) {
        print("handleBackspaceLongPress")
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
        // get view touch is in
        let touchPoint = touches.first!.locationInView(inputView)
        let touchView = view.hitTest(touchPoint, withEvent: nil)
        firstTouchPoint = touchPoint
        
        // !!!! DEBUG
        print(firstTouchPoint)
        // !!!! DEBUG
        
        // !!! some logic I haven't remembered why I am keeping 20160914
        if prevDisplayButton != nil {
        }
        // !!!
        
        // check for nil for safety
        if touchView != nil {
            if (touchView!.tag < 9) {
                // pass to utility key function handler
                doKeyFunction(touchView!)
                // disable touch so if user drags out of util
                // key it won't crash
                self.disableTouch = true;
                if prevButton == " " {
                    cancelDoubleTap()
                }
                self.prevButton = ""
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
        // if touch is disabled return and do nothing
        if self.disableTouch {
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
   
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.disableTouch = false;
        if prevDisplayButton != nil && event?.allTouches()?.count < 2 {
            if manager.isShift {
                manager.shiftOff()
            }
        }
        if (prevButton == " " || prevButton == "\n") && manager.isNumbersPage() {
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
        let rawTextAidProxy = textProxy as! TextAidProxy
        if !textDocumentProxy.hasText() {
            rawTextAidProxy.clear()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //self.view.translatesAutoresizingMaskIntoConstraints = false
        ConstraintMaker.setWindowHeight(self.view)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func loadView() {
        super.loadView()
        let settings = NSUserDefaults.init(suiteName: "group.com.douglaslamb.tap")
        textProxy = TextAidProxy(inDocumentProxy: textDocumentProxy)
    }
}