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
    
    // constants
    let alphaIndexes: [Int]
    
    // vars stateful
    var didHideLabels: Bool = false
    
    init(buttons: [UIView], label: UILabel, keyboardManager: KeyboardManager) {
        self.buttons = buttons
        self.label = label
        manager = keyboardManager
        alphaIndexes = [9, 22, 20, 11, 2, 12, 13, 14, 7, 15, 16, 25, 24, 23, 8, 17, 0, 3, 10, 4, 6, 21, 1, 19, 5, 18]
    }
    
    func run() {
        // constants
        let labelText = "Keep your eyes here and tap the buttons"
        
        label.text = labelText
        if !manager.isLabelsHidden() {
            manager.showHideLabels()
            didHideLabels = true
        }
        
        nextKey(buttons[alphaIndexes[0]])
    }
    
    func nextKey(key: UIView) {
        
    }
}
