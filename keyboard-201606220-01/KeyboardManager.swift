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
    var lettersPageLabelsDisplayMode = 0
    var numbersPageLabelsDisplayMode = 0
    
    // constants
    // first scheme in array is low contrast. second is high
    let labelColorSchemes: [LabelColorScheme] = [LabelColorScheme(evenColumnWhite: 0.6, oddColumnWhite: 0.7), LabelColorScheme(evenColumnWhite: 1.0, oddColumnWhite: 0.0)]
    
    func loadStart() {
        changeLabelsText(letterPageChars)
        // put correct label on numbersKey
        numbersKeyLabel.text = "123"
        numbersPuncKeyLabel.hidden = true
        shiftKeyImageView.hidden = false
        
        // change tag
        shiftOrNumbersPuncTouchButton.tag = shiftKeyTag
        
        setLabelsColor()
    }
    
    func cycleLabelsDisplayMode() {
        if !isNumbersPage() {
            // change labels on letters page
            // increment lettersPageLabelDisplayMode and divide so it wraps
            lettersPageLabelsDisplayMode = (lettersPageLabelsDisplayMode + 1) % 3
            setLabelsColor()
        } else {
            // change labels on numbers page
            // increment numbersPageLabelDisplayMode and divide so it wraps
            // wrap at 2 to avoid 3 which = hidden
            numbersPageLabelsDisplayMode = (numbersPageLabelsDisplayMode + 1) % 2
            setLabelsColor()
        }
    }
    
    func setLabelsColor() {
        if !isNumbersPage() {
            // change labels on letters page
            for (i, label) in charTouchButtonLabels.enumerate() {
                if lettersPageLabelsDisplayMode != LabelsDisplayMode.hidden.rawValue {
                    label.hidden = false
                    
                    // set even and odd text row columns
                    // to labelColorSchemes values at labelDisplayMode
                    if i % 9 % 2 == 0 {
                        label.textColor = labelColorSchemes[lettersPageLabelsDisplayMode].evenColumn
                    } else {
                        label.textColor = labelColorSchemes[lettersPageLabelsDisplayMode].oddColumn
                    }
                } else {
                    // else hide label
                    label.hidden = true
                }
            }
        } else {
            // change labels on numbers page
            for (i, label) in charTouchButtonLabels.enumerate() {
                label.hidden = false
                
                // set even and odd text row columns
                // to labelColorSchemes values at numbersPageLabelsDisplayMode
                if i % 9 % 2 == 0 {
                    label.textColor = labelColorSchemes[numbersPageLabelsDisplayMode].evenColumn
                } else {
                    label.textColor = labelColorSchemes[numbersPageLabelsDisplayMode].oddColumn
                }
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
        setLabelsColor()
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
