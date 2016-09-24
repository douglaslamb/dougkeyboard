//
//  KeyManager.swift
//  keyboard-201606220-01
//
//  Created by rocker on 20160729.
//  Copyright © 2016 rocker. All rights reserved.
//

import UIKit

class KeyboardManager {
    
    enum LabelsDisplayMode: Int {
        case lowContrast = 0, highContrast, hidden
    }
    
    struct LabelColorScheme {
        
        let evenColumn, oddColumn: UIColor
        
        init (evenColumnWhite: CGFloat, oddColumnWhite: CGFloat) {
            self.evenColumn = UIColor.init(white: evenColumnWhite, alpha: 1)
            self.oddColumn = UIColor.init(white: oddColumnWhite, alpha: 1)
        }
    }
    
    var charTouchButtons: [UIView]!
    var charTouchButtonLabels: [UILabel]!
    
    var letterPageChars: [String]!
    var numberPageChars: [String]!
    var puncPageChars: [String]!
    
    
    var numbersKeyLabel: UILabel!
    var numbersPuncKeyLabel: UILabel!
    var shiftKeyImageView: UIImageView!
    
    var shiftOrNumbersPuncTouchButton: UIView!
    
    var shiftKeyTag: Int!
    var numbersPuncKeyTag: Int!
    
    var guides: [UIView]!
    
    // stateful vars
    var isShift: Bool = false
    var userDidHideLabels = false
    var labelsDisplayMode = 0
    
    // constants
    let labelColorSchemes: [LabelColorScheme] = [LabelColorScheme(evenColumnWhite: 0.4, oddColumnWhite: 0.7), LabelColorScheme(evenColumnWhite: 0.9, oddColumnWhite: 0.2)]
    
    func loadStart() {
        changeLabelsText(letterPageChars)
        // put correct label on numbersKey
        numbersKeyLabel.text = "123"
        numbersPuncKeyLabel.hidden = true
        shiftKeyImageView.hidden = false
        
        // change tag
        shiftOrNumbersPuncTouchButton.tag = shiftKeyTag
        
        /* LEGACY
        // hide labels if needed
        if userDidHideLabels {
            showHideLabels()
        }
        */
        
        setLabelsColor()
    }
    
    func cycleLabelsDisplayMode() {
        // increment labelDisplayMode and divide so it wraps
        labelsDisplayMode = (labelsDisplayMode + 1) % 3
        setLabelsColor()
    }
    
    func setLabelsColor() {
        for (i, label) in charTouchButtonLabels.enumerate() {
            
            // if labelsDisplay mode is not hidden
            if labelsDisplayMode != LabelsDisplayMode.hidden.rawValue {
                
                // set even and odd text row columns
                // to labelColorSchemes values at labelDisplayMode
                if i % 9 % 2 == 0 {
                    label.textColor = labelColorSchemes[labelsDisplayMode].evenColumn
                } else {
                    label.textColor = labelColorSchemes[labelsDisplayMode].oddColumn
                }
            } else {
                // else hide label
                label.hidden = true
            }
        } 
    }
    
    func isNumbersPage() -> Bool {
        let label = charTouchButtonLabels[0]
        return label.text != "Q"
    }
    
    func isPuncsPage() -> Bool {
        let label = charTouchButtonLabels[0]
        return label.text == "["
    }
    
    func changeLabelsText(chars: [String]) {
        for (i, label) in charTouchButtonLabels.enumerate() {
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
        if isLabelsHidden() {
            showHideLabels()
        }
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
   
    
    func shiftOn() {
        isShift = true
        shiftKeyImageView.image = UIImage(named: "shiftOn")
    }
    
    func shiftOff() {
        isShift = false
        shiftKeyImageView.image = UIImage(named: "shiftOff")
    }
    
    func showHideLabels() {
        if charTouchButtonLabels[0].hidden {
            for label in charTouchButtonLabels {
                label.hidden = false
            }
        } else {
            for label in charTouchButtonLabels {
                label.hidden = true
            }
        }
    }
    
    func isLabelsHidden() -> Bool {
        return charTouchButtonLabels[0].hidden
    }
}

