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
    
    var letterPageChars: [String]!
    var numberPageChars: [String]!
    var puncPageChars: [String]!
    
    var isShift: Bool = false
    var isNumbersPage: Bool = false
    var isPuncsPage: Bool = false
    
    var numbersKey: UIView!
    var numbersPuncKey: UIView!
    var shiftKey: UIImageView!
    
    var guides: [UIView]!
    
    func goToNumbersPage() {
        // set correct label on numbersPuncKey
        let label = self.numbersPuncKey.subviews[0] as! UILabel
        label.text = "#+="
        changeLabelsText(numberPageChars)
        if self.isPuncsPage {
            self.isPuncsPage = false
        } else {
            let label = self.numbersKey.subviews[0] as! UILabel
            // put correct label on numbersKey
            label.text = "ABC"
            self.isNumbersPage = true
        }
    }
    
    private func changeLabelsText(chars: [String]) {
        for (i, button) in charTouchButtons.enumerate() {
            let label = button.subviews[0] as! UILabel
            label.text = chars[i]
        }
    }
    
    func goToPuncsPage() {
        changeLabelsText(puncPageChars)
        // set correct label on numbersPuncKey
        let label = self.numbersPuncKey.subviews[0] as! UILabel
        label.text = "123"
        // modify global state
        self.isPuncsPage = true
    }
    
    func goToLettersPage() {
        shiftOff()
        loadStart()
    }
    
    func loadStart() {
        changeLabelsText(letterPageChars)
        if self.isPuncsPage {
            self.isPuncsPage = false
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
        self.shiftKey.backgroundColor = UIColor.whiteColor()
    }
    
    func shiftOff() {
        self.isShift = false
        self.shiftKey.image = UIImage(named: "shiftOff")
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
}

