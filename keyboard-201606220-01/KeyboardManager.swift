//
//  KeyManager.swift
//  keyboard-201606220-01
//
//  Created by rocker on 20160729.
//  Copyright © 2016 rocker. All rights reserved.
//

import UIKit

class KeyboardManager {
    
    var lettersAndShift: [UIView]!
    var numbersAndPuncs: [UIView]!
    var lowerPuncsAndNumbersPuncKey: [UIView]!
    var puncs: [UIView]!
    
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
        unhide(self.numbersAndPuncs)
        if self.isPuncsPage {
            hide(self.puncs)
            self.isPuncsPage = false
        } else {
            unhide(self.lowerPuncsAndNumbersPuncKey)
            hide(self.lettersAndShift)
            hide(guides)
            let label = self.numbersKey.subviews[0] as! UILabel
            // put correct label on numbersKey
            label.text = "ABC"
            self.isNumbersPage = true
        }
    }
    
    func goToPuncsPage() {
        hide(self.numbersAndPuncs)
        unhide(self.puncs)
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
        unhide(self.lettersAndShift)
        unhide(guides)
        hide(self.lowerPuncsAndNumbersPuncKey)
        hide(self.puncs)
        if self.isPuncsPage {
            hide(self.puncs)
            self.isPuncsPage = false
        } else {
            hide(self.numbersAndPuncs)
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
        //!!!!! change back maybe 20160903
        //self.shiftKey.backgroundColor = UIColor.grayColor()
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

