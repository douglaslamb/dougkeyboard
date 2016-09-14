//
//  KeyManager.swift
//  keyboard-201606220-01
//
//  Created by rocker on 20160729.
//  Copyright © 2016 rocker. All rights reserved.
//

import UIKit

class KeyboardManager {
    
    var charTouchButtons: [UIView]!
    var charTouchButtonLabels: [UIView]!
    
    var letterPageChars: [String]!
    var numberPageChars: [String]!
    var puncPageChars: [String]!
    
    var isShift: Bool = false
    
    var numbersKeyLabel: UILabel!
    var numbersPuncKeyLabel: UILabel!
    var shiftKeyImageView: UIImageView!
    
    var shiftOrNumbersPuncTouchButton: UIView!
    
    var shiftKeyTag: Int!
    var numbersPuncKeyTag: Int!
    
    var guides: [UIView]!
    
    func isNumbersPage() -> Bool {
        let label = charTouchButtons[0].subviews[0] as! UILabel
        return label.text != "Q"
    }
    
    func isPuncsPage() -> Bool {
        let label = charTouchButtons[0].subviews[0] as! UILabel
        return label.text == "["
    }
    
    func changeLabelsText(chars: [String]) {
        for (i, button) in charTouchButtons.enumerate() {
            let label = button.subviews[0] as! UILabel
            label.text = chars[i]
        }
    }
    
    func goToNumbersPage() {
        if !isPuncsPage() {
            numbersKeyLabel.text = "ABC"
        }
        numbersPuncKeyLabel.text = "#+="
        numbersPuncKeyLabel.hidden = false
        shiftKeyImageView.hidden = true
        shiftOff()
        changeLabelsText(numberPageChars)
        // change tag
        shiftOrNumbersPuncTouchButton.tag = numbersPuncKeyTag
    }
    
    func goToPuncsPage() {
        changeLabelsText(puncPageChars)
        // set correct label on numbersPuncKey
        numbersPuncKeyLabel.text = "123"
    }
    
    func goToLettersPage() {
        shiftOff()
        loadStart()
    }
    
    func loadStart() {
        changeLabelsText(letterPageChars)
        // put correct label on numbersKey
        numbersKeyLabel.text = "123"
        numbersPuncKeyLabel.hidden = true
        shiftKeyImageView.hidden = false
        // change tag
        shiftOrNumbersPuncTouchButton.tag = shiftKeyTag
    }
    
    func shiftOn() {
        isShift = true
        shiftKeyImageView.image = UIImage(named: "shiftOn")
    }
    
    func shiftOff() {
        isShift = false
        shiftKeyImageView.image = UIImage(named: "shiftOff")
    }
    
    func showHideLabels() {
        if charTouchButtonLabels[0].hidden == true {
            for label in charTouchButtonLabels {
                label.hidden = false
            }
        } else {
            for label in charTouchButtonLabels {
                label.hidden = true
            }
        }
    }
}

