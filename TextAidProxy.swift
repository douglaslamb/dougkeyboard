//
//  TextAidProxy.swift
//  keyboard-201606220-01
//
//  Created by rocker on 20160903.
//  Copyright © 2016 rocker. All rights reserved.
//

import UIKit

class TextAidProxy {
    
    // global vars and refs
    var label: UILabel
    var prevChar: String? = nil
    let documentProxy: UITextDocumentProxy!
    
    // global constants
    // ERASE IF NO LONGER NEEDED
    let wordLimit = 5
    let charLimit = 19
    
    init(inLabel: UILabel, inDocumentProxy: UITextDocumentProxy) {
        label = inLabel
        label.textAlignment = NSTextAlignment.Justified
        documentProxy = inDocumentProxy
    }
    
    func insertText(text: String) {
        if label.text != nil {
            label.text = label.text! + text
        } else {
            label.text = text
        }
        // short circuit eval
        if label.text != nil && label.text!.characters.count > charLimit {
            label.text = String(label.text!.characters.dropFirst())
        }
        /*
        // from dropping the first word of string
        // erase if desired and no longer needed
        if text == " " && prevChar != " " && prevChar != nil {
            dropFirstWordIfNeeded()
        }
        */
        prevChar = text
    }
    
    func deleteBackward() {
        let oldText = label.text
        if oldText != nil && oldText!.characters.count != 0 {
            label.text = String(oldText!.characters.dropLast())
        }
        prevChar = nil
    }
    
    func clear() {
        label.text = ""
    }
    
    private func prependCharFromField() {
        if documentProxy.documentContextBeforeInput != nil {
            let char = String(documentProxy.documentContextBeforeInput!.characters.dropLast())
            if label.text != nil {
                label.text = char + label.text!
            } else {
                label.text = char
            }
        }
    }
    
    private func dropFirstWordIfNeeded() {
        if label.text != nil {
            var textArray = label.text!.componentsSeparatedByString(" ")
            if textArray.count > wordLimit {
                textArray.removeAtIndex(0)
                label.text = textArray.joinWithSeparator(" ")
            }
        }
    }
}
