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
    let textDocumentProxy: UITextDocumentProxy
    
    // constants
    let kbIndexes: [Int] = [9, 22, 20, 11, 2, 12, 13, 14, 7, 15, 16, 25, 24, 23, 8, 17, 0, 3, 10, 4, 6, 21, 1, 19, 5, 18]
    let highlightColor: UIColor = UIColor.init(white: 0.8, alpha: 1.0)
    let goodjobMessage: String = "Good job!"
    
    // stateful vars
    var currChar: String?
    var nextAlphabetIndex: Int = 0
    var unhighlightColor: UIColor?
    var tutStates: [TutState] = [TutState]()
    var buttonsToUnhighlight: [ButtonToUnhighlight]?
    var isTutRunning: Bool = false
    var currState: TutState?
    
    init(buttons: [UIView], label: UILabel, keyboardManager: KeyboardManager, showCharsDoubleTapRecognizer: UIGestureRecognizer, textDocumentProxy: UITextDocumentProxy) {
        self.buttons = buttons
        self.label = label
        manager = keyboardManager
        self.showCharsDoubleTapRecognizer = showCharsDoubleTapRecognizer
        self.textDocumentProxy = textDocumentProxy
    }
    
    func loadNextState() {
        if tutStates.count == 0 {
            end()
        } else {
            // delete previous message in textDocumentProxy
            if currState != nil {
                for i in 0..<currState!.message!.characters.count {
                    textDocumentProxy.deleteBackward()
                }
            }
            
            unhighlightButtons()
            
            // load next state into global
            let state = tutStates.removeFirst()
            currState = state
            
            // set message to user
            textDocumentProxy.insertText((state.message)!)
            
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
    }
    
    func unhighlightButtons() {
        if buttonsToUnhighlight != nil {
            for button in buttonsToUnhighlight! {
                button.button?.backgroundColor = button.unhighlightColor
            }
            buttonsToUnhighlight = nil
        }
    }
    
    func run() {
        isTutRunning = true
        // constants
        
        // clear label
        label.text = ""
        
        // create space in document proxy
        textDocumentProxy.insertText(" ")
        
        // define uppercase chars array
        var upperCaseChars = [String]()
        for i in 65..<91 {
            upperCaseChars.append(String(UnicodeScalar(i)))
        }
        
        // fill tutstate array
        tutStates = [
            TutState(requiredCharacters: nil, message: "Tutorial. Press any letter key.", highlightKeys: nil),
            TutState(requiredCharacters: upperCaseChars, message: "Hold space and type for caps.", highlightKeys: nil),
            TutState(requiredCharacters: nil, message: goodjobMessage, highlightKeys: nil),
            TutState(requiredCharacters: ["."], message: "Double tap space for period.", highlightKeys: nil),
            TutState(requiredCharacters: nil, message: goodjobMessage, highlightKeys: nil),
            TutState(requiredCharacters: [","], message: "Hold first row and double tap space for comma.", highlightKeys: Array(buttons[18..<26])),
            TutState(requiredCharacters: ["'"], message: "Hold second row and double tap space for apostrophe.", highlightKeys: Array(buttons[9..<18])),
            TutState(requiredCharacters: ["?"], message: "Hold third row and double tap space for question mark.", highlightKeys: Array(buttons[0..<9])),
            TutState(requiredCharacters: ["!"], message: "Hold top row and double tap space for exclamation point.", highlightKeys: nil),
            TutState(requiredCharacters: nil, message: goodjobMessage, highlightKeys: nil),
            TutState(requiredCharacters: nil, message: "I love you!", highlightKeys: nil)
        ]
        
        loadNextState()
        
        if manager.isNumbersPage() {
            manager.goToLettersPage()
        }
        
        showCharsDoubleTapRecognizer.enabled = false
    }
    
    func end() {
        // delete previous message in textDocumentProxy
        if currState != nil {
            for i in 0..<currState!.message!.characters.count {
                textDocumentProxy.deleteBackward()
            }
        }
        
        if isAlphaPracRunning() {
            unhighlightButton(buttons[kbIndexes[nextAlphabetIndex - 1]])
        } else {
            unhighlightButtons()
        }
        
        // reset label and vars
        label.text = ""
        currChar = nil
        currState = nil
        nextAlphabetIndex = 0
        isTutRunning = false
        
        // renable buttons
        showCharsDoubleTapRecognizer.enabled = true
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
    
    func insertTextInLabel(text: String) {
        if label.text != nil {
            label.text = label.text! + text
        } else {
            label.text = text
        }
    }
    
    func testText(text: String) {
        print("testText")
        insertTextInLabel(text)
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
