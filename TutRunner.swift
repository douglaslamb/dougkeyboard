//
//  TutRunner.swift
//  keyboard-201606220-01
//
//  Created by rocker on 20160915.
//  Copyright © 2016 rocker. All rights reserved.
//

import UIKit

class TutRunner {
    
    // outside objects
    let buttons: [UIView]
    let label: UILabel
    let manager: KeyboardManager
    let showCharsDoubleTapRecognizer: UIGestureRecognizer
    
    // constants
    let kbIndexes: [Int] = [9, 22, 20, 11, 2, 12, 13, 14, 7, 15, 16, 25, 24, 23, 8, 17, 0, 3, 10, 4, 6, 21, 1, 19, 5, 18]
    let highlightColor: UIColor = UIColor.init(white: 0.5, alpha: 1.0)
    let unhighlightColor: UIColor = UIColor.init(white: 0.1, alpha: 0)
    
    // stateful vars
    var currChar: String?
    var nextAlphabetIndex: Int = 0
    
    init(buttons: [UIView], label: UILabel, keyboardManager: KeyboardManager, showCharsDoubleTapRecognizer: UIGestureRecognizer) {
        self.buttons = buttons
        self.label = label
        manager = keyboardManager
        self.showCharsDoubleTapRecognizer = showCharsDoubleTapRecognizer
    }
    
    func run() {
        // constants
        let labelText = "Eyes here."
        label.text = labelText
        if manager.isNumbersPage() {
            manager.goToLettersPage()
        }
        if !(manager.userDidHideLabels) {
            manager.showHideLabels()
        }
        showCharsDoubleTapRecognizer.enabled = false
        goToNextButton()
    }
    
    func end() {
        unhighlightButton(buttons[kbIndexes[nextAlphabetIndex - 1]])
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
        if nextAlphabetIndex < 26 {
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
        //let label = button.subviews[0] as! UILabel
        //label.hidden = false
        button.backgroundColor = highlightColor
    }
    
    func unhighlightButton(button: UIView) {
        //let label = button.subviews[0] as! UILabel
        //label.hidden = true
        button.backgroundColor = unhighlightColor
    }
    
    func testText(text: String) {
        if text.uppercaseString == currChar {
            goToNextButton()
        }
    }
    
    func isRunning() -> Bool {
        return nextAlphabetIndex != 0
    }
}
