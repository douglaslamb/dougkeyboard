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
        
        let evenColumnTopRow, evenColumnMidRow, evenColumnBottomRow, oddColumnTopRow, oddColumnMidRow, oddColumnBottomRow: UIColor
        
        init (evenColumnTopRow: CGFloat, oddColumnTopRow: CGFloat, evenColumnMidRow: CGFloat, oddColumnMidRow: CGFloat, evenColumnBottomRow: CGFloat, oddColumnBottomRow: CGFloat) {
            self.evenColumnTopRow = UIColor.init(white: evenColumnTopRow, alpha: 1)
            self.evenColumnMidRow = UIColor.init(white: evenColumnMidRow, alpha: 1)
            self.evenColumnBottomRow = UIColor.init(white: evenColumnBottomRow, alpha: 1)
            self.oddColumnTopRow = UIColor.init(white: oddColumnTopRow, alpha: 1)
            self.oddColumnMidRow = UIColor.init(white: oddColumnMidRow, alpha: 1)
            self.oddColumnBottomRow = UIColor.init(white: oddColumnBottomRow, alpha: 1)
        }
    }
    
    var charTouchButtons: [UIView]!
    var charTouchButtonLabels: [UILabel]!
    var charTouchButtonPopups: [UILabel]!
    
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
    //let labelColorSchemes: [LabelColorScheme] = [LabelColorScheme(evenColumnWhite: 0.6, oddColumnWhite: 0.7), LabelColorScheme(evenColumnWhite: 1.0, oddColumnWhite: 0.0)]
    // old this is with a low contrast page let labelColorSchemes: [LabelColorScheme] = [LabelColorScheme(evenColumnTopRow: 0.6, oddColumnTopRow: 0.7, evenColumnMidRow: 0.6, oddColumnMidRow: 0.7, evenColumnBottomRow: 0.6, oddColumnBottomRow: 0.7), LabelColorScheme(evenColumnTopRow: 0.6, oddColumnTopRow: 0.7, evenColumnMidRow: 0.7, oddColumnMidRow: 0.4, evenColumnBottomRow: 1.0, oddColumnBottomRow: 0.0)]
    let labelColorSchemes: [LabelColorScheme] = [LabelColorScheme(evenColumnTopRow: 1.0, oddColumnTopRow: 0.0, evenColumnMidRow: 1.0, oddColumnMidRow: 0.0, evenColumnBottomRow: 1.0, oddColumnBottomRow: 0.0), LabelColorScheme(evenColumnTopRow: 0.6, oddColumnTopRow: 0.7, evenColumnMidRow: 0.7, oddColumnMidRow: 0.4, evenColumnBottomRow: 1.0, oddColumnBottomRow: 0.0)]
    
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
                        switch i / 9 {
                            case 0:
                                label.textColor = labelColorSchemes[lettersPageLabelsDisplayMode].evenColumnTopRow
                            case 1:
                                label.textColor = labelColorSchemes[lettersPageLabelsDisplayMode].evenColumnMidRow
                            case 2:
                                label.textColor = labelColorSchemes[lettersPageLabelsDisplayMode].evenColumnBottomRow
                            default: break
                        }
                    } else {
                        switch i / 9 {
                            case 0:
                                label.textColor = labelColorSchemes[lettersPageLabelsDisplayMode].oddColumnTopRow
                            case 1:
                                label.textColor = labelColorSchemes[lettersPageLabelsDisplayMode].oddColumnMidRow
                            case 2:
                                label.textColor = labelColorSchemes[lettersPageLabelsDisplayMode].oddColumnBottomRow
                            default: break
                        }
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
                    switch (i / 9) {
                        case 0:
                            label.textColor = labelColorSchemes[numbersPageLabelsDisplayMode].evenColumnTopRow
                        case 1:
                            label.textColor = labelColorSchemes[numbersPageLabelsDisplayMode].evenColumnMidRow
                        case 2:
                            label.textColor = labelColorSchemes[numbersPageLabelsDisplayMode].evenColumnBottomRow
                        default: break 
                    }
                } else {
                    switch i / 9 {
                        case 0:
                            label.textColor = labelColorSchemes[numbersPageLabelsDisplayMode].oddColumnTopRow
                        case 1:
                            label.textColor = labelColorSchemes[numbersPageLabelsDisplayMode].oddColumnMidRow
                        case 2:
                            label.textColor = labelColorSchemes[numbersPageLabelsDisplayMode].oddColumnBottomRow
                        default: break 
                    }
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
            charTouchButtonPopups[i].text = chars[i]
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
