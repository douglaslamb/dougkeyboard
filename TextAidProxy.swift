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
    let documentProxy: UITextDocumentProxy
    var tutRunner: TutRunner!
    
    // global constants
    let maxWidth: CGFloat = 30
    
    init(documentProxy: UITextDocumentProxy) {
        self.documentProxy = documentProxy
    }
    
    @objc func insertText(text: String) {
        // send text to tut or docProxy
        if !(tutRunner!.isRunning()) {
            documentProxy.insertText(text)
            refresh()
        } else {
            tutRunner!.testText(text)
        }
    }
    
    @objc func deleteBackward() {
        documentProxy.deleteBackward()
        refresh()
    }

    @objc func hasText() -> Bool {
        return documentProxy.hasText()
    }
 
    func clear() {
        label.text = ""
    }
    
    func refresh() {
        let displayText = documentProxy.documentContextBeforeInput
        // short circuit eval
        if displayText == nil || displayText!.characters.last == "\n" {
            clear()
        } else {
            label.text = displayText!
        }
    }
}
