//
//  TextAidProxy.swift
//  keyboard-201606220-01
//
//  Created by rocker on 20160903.
//  Copyright © 2016 rocker. All rights reserved.
//

import UIKit

class TextAidProxy: NSObject, UIKeyInput {
    
    // global vars and refs
    var label: UILabel!
    var prevChar: String?
    let documentProxy: UITextDocumentProxy
    
    // global constants
    // ERASE IF NO LONGER NEEDED
    let wordLimit = 5
    let charLimit = 19
    
    init(inDocumentProxy: UITextDocumentProxy) {
        documentProxy = inDocumentProxy
    }
    
    @objc func insertText(text: String) {
        documentProxy.insertText(text)
        if text != "\n" {
            if label.text != nil {
                label.text = label.text! + text
            } else {
                label.text = text
            }
            // short circuit eval
            if label.text != nil && label.text!.characters.count > charLimit {
                label.text = String(label.text!.characters.dropFirst())
            }
            prevChar = text
        } else {
            clear()
            prevChar = nil
        }
    }
    
    @objc func deleteBackward() {
        documentProxy.deleteBackward()
        let oldText = label.text
        if oldText != nil && oldText!.characters.count != 0 {
            label.text = String(oldText!.characters.dropLast())
        }
        prevChar = nil
    }
    
    @objc func hasText() -> Bool {
        return false
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
}
