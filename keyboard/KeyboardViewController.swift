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
    
    // settings
    var isTextAid: Bool = true
    
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
    //20160909 let oddColumnUnpressedTextColor = UIColor.init(white: 0.2, alpha: 1)
    let oddColumnUnpressedTextColor = UIColor.init(white: 0.7, alpha: 1)
    let oddColumnPressedTextColor = UIColor.init(white: 0.2, alpha: 1)
    // 20160909 let evenGuideColor = UIColor.init(white: 0.5, alpha: 1)
    let evenGuideColor = UIColor.init(white: 0.3, alpha: 1)
    let evenGuideAnimationColor = UIColor.init(white: 0.9, alpha: 1)
    let oddGuideColor = UIColor.whiteColor()
    let oddGuideAnimationColor = UIColor.init(white: 0.1, alpha: 1)
    
    enum UtilKey: Int {
        case nextKeyboardKey = 1, returnKey, shiftKey, backspaceKey, numbersLettersKey, numbersPuncKey
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
        let backspaceImage = UIImage(named: "backspaceOff")
        let backspaceKey = UIImageView(image: backspaceImage)
        setupImageView(backspaceKey)
        let backspaceTouchKey = UIView()
        backspaceTouchKey.addSubview(backspaceKey)
        backspaceKey.tag = UtilKey.backspaceKey.rawValue
        bottomRowTouchButtons.append(backspaceTouchKey)
        ConstraintMaker.centerViewInView(backspaceTouchKey, subview: backspaceKey)
        
        // add and configure long press recognizer
        let backspaceLongPressRecognizer = UILongPressGestureRecognizer(target: self, action: Selector("handleBackspaceLongPress:"))
        backspaceTouchKey.addGestureRecognizer(backspaceLongPressRecognizer)
        
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
        
        // add label to textRowView
        let textAidLabel = UILabel()
        textAidLabel.translatesAutoresizingMaskIntoConstraints = false
        textAidLabel.userInteractionEnabled = false
        textRowView.addSubview(textAidLabel)
        // add label to textProxy object
        let rawTextProxy = textProxy as! TextAidProxy
        rawTextProxy.label = textAidLabel
        
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
        spacebarKey.tag = 30    // to designate it as a text entering key
        
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
        
        // wrap util buttons into touch buttons
        
        var utilRowTouchButtons = wrapButtons(utilRowButtons)
        
        // add spacebar double tap recognizer
        doubleTapRecognizer = UITapGestureRecognizer(target: self, action: Selector("insertDoubleTapPeriod:"))
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.delaysTouchesEnded = false
        utilRowTouchButtons[4] = spacebarKey
        utilRowTouchButtons[4].addGestureRecognizer(doubleTapRecognizer)
        
        // add utilRowTouch buttons to utilRowView
        
        for button in utilRowTouchButtons {
            utilRowView.addSubview(button)
        }
        
        // add constraints for rows in superview
        var rows = [[self.topRowView], [self.midRowView], [self.bottomRowView], [self.utilRowView]]
        if isTextAid {
            rows = [[textRowView]] + rows
        }
        
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
        
        ConstraintMaker.addAllButtonConstraints(topRowView, midRowView: midRowView, bottomRowView: bottomRowView, utilRowView: utilRowView, verticalGuideViews: verticalGuideViews, utilKeys: utilRowButtons, topTouchButtons: topRowTouchButtons, midTouchButtons: midRowTouchButtons, bottomTouchButtons: bottomRowTouchButtons, utilTouchKeys: utilRowTouchButtons, betweenSpace: 0, shiftWidth: 0.05, nextKeyboardWidth: 0.12, spaceKeyWidth: 0.45, charVerticalConstant: 0)
        
        if isTextAid {
            ConstraintMaker.addTextRowViewConstraints(textRowView)
        }
        
        // do startup hiding
        manager.loadStart()
        if self.textDocumentProxy.keyboardType == UIKeyboardType.NumberPad {
            manager.goToNumbersPage()
        }
    }
    
    private func addSubviews(view: UIView, subviews: [UIView]) {
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
        view.layer.masksToBounds = true
        Appearance.setCornerRadius(view)
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
            
            // !!!!!!!!!!!!!!!!!!!!!!!!!!!!
            // DEBUG
            //label.hidden = true
            // !!!!!!!!!!!!!!!!!!!!!!!!!!!!
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
            if subview.pointInside(touchPoint, withEvent: event) && !subview.hidden && subview.tag > 9 {
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
                textProxy.deleteBackward()
                self.prevButton = ""
            }
        }
    }
    
    func handleTouchMoveInButton(view: UIView) {
        let buttonLabel = view.subviews[0] as! UILabel
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
                textProxy.insertText(character)
            } else {
                // in this case the previous button
                // was a different character.
                // i.e. slide from button to button
                textProxy.deleteBackward()
                textProxy.insertText(character)
            }
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
                    if prevButton == " " {
                        cancelDoubleTap()
                    }
                } else {
                    let buttonLabel = subview.subviews[0] as! UILabel
                    let currButtonLabel = buttonLabel.text!
                    let character = manager.isShift || isSpaceShift ? currButtonLabel: currButtonLabel.lowercaseString
                    if isSpaceShift {
                        textProxy.deleteBackward()
                    }
                    // cancel double tap recognizer
                    // if a tap is detected not on space
                    if prevButton == " " && character != " " {
                        cancelDoubleTap()
                    }
                    textProxy.insertText(character)
                    isTouchInButton = true
                    self.prevButton = currButtonLabel
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
    
    private func createBlankTouchButtonsWithLabels(numButtons: Int) -> [UIView] {
        // creates a bunch of UIView
        // adds a label to each
        // and adds each to an array which is returned
        
        var buttons = [UIView]()
        for i in 0..<numButtons {
            let touchButton = UIView()
            let label = UILabel()
            buttons.append(touchButton)
            touchButton.addSubview(label)
            
            // set default properties
            setTouchButtonDefaults(touchButton)
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
    
    private func setTouchButtonDefaults(button: UIView) {
        button.opaque = false
    }
    
    private func setLabelDefaults(label: UILabel) {
        label.userInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setRowDefaults(row: UIView) {
        row.opaque = false
        //row.userInteractionEnabled = false
    }
    
    func cancelDoubleTap() {
        doubleTapRecognizer.enabled = false
        doubleTapRecognizer.enabled = true
    }
    
    func makeLetterButtonsAlternateColors (buttons: [UIView]) {
        // change letters in columns to correct color
        // and put a tag on UILabel so correct colors
        // can be used on and after keypress
        for (i, button) in buttons.enumerate() {
            let buttonLabel = button.subviews[0] as! UILabel
            if i % 2 == 0 {
                buttonLabel.textColor = evenColumnUnpressedTextColor
                button.tag = LetterIdentifier.evenRowKey.rawValue
            } else {
                buttonLabel.textColor = oddColumnUnpressedTextColor
                button.tag = LetterIdentifier.oddRowKey.rawValue
            }
        }
        
    }
    
    func makeKeyPressed(button: UIView) {
        // change button to pressed color
        let buttonLabel = button.subviews[0] as! UILabel
        // ignore the spacebar
        if buttonLabel.text != " " {
            button.backgroundColor = pressedBackgroundColor
            if button.tag == LetterIdentifier.oddRowKey.rawValue {
                buttonLabel.textColor = oddColumnPressedTextColor
            } else if button.tag == LetterIdentifier.evenRowKey.rawValue {
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
                if button!.tag == LetterIdentifier.oddRowKey.rawValue {
                    buttonLabel.textColor = self.oddColumnUnpressedTextColor
                } else if button!.tag == LetterIdentifier.evenRowKey.rawValue {
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
            print("return happened")
            textProxy.insertText("\n")
        case UtilKey.backspaceKey.rawValue:
            textProxy.deleteBackward()
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
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.disableTouch = false;
        if prevDisplayButton != nil && event?.allTouches()?.count < 2 {
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
        if isTextAid {
            let rawTextAidProxy = textProxy as! TextAidProxy
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
        print(inputView!.frame.height)
    }
    
    override func loadView() {
        super.loadView()
        let settings = NSUserDefaults.init(suiteName: "group.com.douglaslamb.tap")
        //isTextAid = settings!.boolForKey("isTextAid")
        if isTextAid {
            textProxy = TextAidProxy(inDocumentProxy: textDocumentProxy)
        } else {
            textProxy = textDocumentProxy
        }
    }
}