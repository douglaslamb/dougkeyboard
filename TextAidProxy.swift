//
//  TextAidProxy.swift
//  keyboard-201606220-01
//
//  Created by rocker on 20160903.
//  Copyright © 2016 rocker. All rights reserved.
//

import UIKit

class TextAidProxy {
    
    var label: UILabel
    
    init(inLabel: UILabel) {
        label = inLabel
    }
    
    func insertText(text: String) {
        if label.text != nil {
            label.text = label.text! + text
        } else {
            label.text = text
        }
    }
    
    func deleteBackward() {
        let oldText = label.text
        if oldText != nil && oldText!.characters.count != 0 {
            label.text = String(oldText!.characters.dropLast())
        }
    }
    
    func clear() {
        label.text = ""
    }
}
