//
//  TutRunner.swift
//  keyboard-201606220-01
//
//  Created by rocker on 20160915.
//  Copyright © 2016 rocker. All rights reserved.
//

import UIKit

class TutRunner {
    
    struct TutState {
        let requiredCharacters: [String]?
        let message: String?
        let highlightKeys: [UIView]?
    }
    
    struct ButtonToUnhighlight {
        let button: UIView?
        let unhighlightColor: UIColor?
    }
    
    // outside objects
    let buttons: [UIView]
    let label: UILabel
    let manager: KeyboardManager
    let showCharsDoubleTapRecognizer: UIGestureRecognizer
    
    // constants
    let kbIndexes: [Int] = [9, 22, 20, 11, 2, 12, 13, 14, 7, 15, 16, 25, 24, 23, 8, 17, 0, 3, 10, 4, 6, 21, 1, 19, 5, 18]
    let highlightColor: UIColor = UIColor.init(white: 0.8, alpha: 1.0)
    
    // stateful vars
    var currChar: String?
    var nextAlphabetIndex: Int = 0
    var unhighlightColor: UIColor?
    var tutStates: [TutState] = [TutState]()
    var buttonsToUnhighlight: [ButtonToUnhighlight]?
    var isTutRunning: Bool = false
    var currState: TutState?
    
    init(buttons: [UIView], label: UILabel, keyboardManager: KeyboardManager, showCharsDoubleTapRecognizer: UIGestureRecognizer) {
        self.buttons = buttons
        self.label = label
        manager = keyboardManager
        self.showCharsDoubleTapRecognizer = showCharsDoubleTapRecognizer
       
    }
    
    func loadNextState() {
        print("loadNextState")
        // unhighlightbuttons if necessary
        if buttonsToUnhighlight != nil {
            unhighlightButtons()
        }
        
        // load next state into global
        let state = tutStates.removeFirst()
        currState = state
        
        // set message to user
        label.text = state.message
        
        // create and store buttons to unhighlight
        if state.highlightKeys != nil {
            var buttons = [ButtonToUnhighlight]()
            for button in state.highlightKeys! {
                let buttonStruct = ButtonToUnhighlight(button: button, unhighlightColor: button.backgroundColor)
                buttons.append(buttonStruct)
                button.backgroundColor = highlightColor
            }
            buttonsToUnhighlight = buttons
        } 
    }
    
    func unhighlightButtons() {
        for button in buttonsToUnhighlight! {
            button.button?.backgroundColor = button.unhighlightColor
        }
        buttonsToUnhighlight = nil
    }
    
    func run() {
        isTutRunning = true
        // constants
        
        // define uppercase chars array
        var upperCaseChars = [String]()
        for i in 65..<91 {
            upperCaseChars.append(String(UnicodeScalar(i)))
        }
        
        // fill tutstate array
        tutStates = [
            TutState(requiredCharacters: nil, message: "Tutorial. Press any key.", highlightKeys: nil),
            TutState(requiredCharacters: upperCaseChars, message: "Hold space for capitalization.", highlightKeys: nil),
            TutState(requiredCharacters: nil, message: "Good job!", highlightKeys: nil),
            TutState(requiredCharacters: ["."], message: "Double tap space for period.", highlightKeys: nil),
            TutState(requiredCharacters: nil, message: "Good job!", highlightKeys: nil),
            TutState(requiredCharacters: [","], message: "Hold first row and double tap space for comma.", highlightKeys: nil),
            TutState(requiredCharacters: ["'"], message: "Hold second row and double tap space for apostrophe.", highlightKeys: nil),
            TutState(requiredCharacters: ["?"], message: "Hold third row and double tap space for question mark.", highlightKeys: nil),
            TutState(requiredCharacters: ["!"], message: "Hold top row and double tap space for exclamation point.", highlightKeys: nil),
            TutState(requiredCharacters: nil, message: "Good job!", highlightKeys: nil),
            TutState(requiredCharacters: nil, message: "Practice with hidden labels.", highlightKeys: nil),
            TutState(requiredCharacters: nil, message: "Eyes here.", highlightKeys: nil),
            TutState(requiredCharacters: nil, message: "Good job!", highlightKeys: nil),
        ]
        
        loadNextState()
        
        //let labelText = "Eyes here."
        //label.text = labelText
        
        if manager.isNumbersPage() {
            manager.goToLettersPage()
        }
        /*
        if !(manager.userDidHideLabels) {
            manager.showHideLabels()
        }
 */
        showCharsDoubleTapRecognizer.enabled = false
        //goToNextButton()
    }
    
    func end() {
        isTutRunning = false
        if isAlphaPracRunning() {
            unhighlightButton(buttons[kbIndexes[nextAlphabetIndex - 1]])
        } else {
            unhighlightButtons()
        }
        if !(manager.userDidHideLabels) {
            manager.showHideLabels()
        }
        showCharsDoubleTapRecognizer.enabled = true
        
        // reset label and vars
        label.text = ""
        currChar = nil
        nextAlphabetIndex = 0
    }
    
    func goToNextButton() {
        print("goToNextButton")
        if nextAlphabetIndex < 26 {
            if nextAlphabetIndex == 1 {
                label.text = ""
            }
            // set previous button to original color
            if nextAlphabetIndex > 0 {
                unhighlightButton(buttons[kbIndexes[nextAlphabetIndex - 1]])
            }
            // if done with alphabet
            let button = buttons[kbIndexes[nextAlphabetIndex]]
            
            highlightButton(button)
            currChar = String(UnicodeScalar(65 + nextAlphabetIndex))
            nextAlphabetIndex = nextAlphabetIndex + 1
        } else {
            end()
        }
    }
    
    func highlightButton(button: UIView) {
        unhighlightColor = button.backgroundColor
        button.backgroundColor = highlightColor
    }
    
    func unhighlightButton(button: UIView) {
        if unhighlightColor != nil {
            button.backgroundColor = unhighlightColor!
        }
    }
    
    func testText(text: String) {
        print("textText")
        if isAlphaPracRunning() {
            if text.uppercaseString == currChar {
                goToNextButton()
                label.text = label.text! + text
            }
        } else {
            if currState != nil && currState?.requiredCharacters != nil {
                if currState!.requiredCharacters!.contains(text) {
                    loadNextState()
                }
            } else {
                loadNextState()
            }
        }
    }
    
    func isRunning() -> Bool {
        return isTutRunning
    }
    
    func isAlphaPracRunning() -> Bool {
        return nextAlphabetIndex != 0
    }
}
