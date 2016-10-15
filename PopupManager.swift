//
//  PopupManager.swift
//  keyboard-201606220-01
//
//  Created by rocker on 20161013.
//  Copyright © 2016 rocker. All rights reserved.
//

import UIKit

class PopupManager {
    
    let charTouchButtonPopups: [UILabel]
    var currPopup: UILabel?
    
    init (charTouchButtonPopups: [UILabel]) {
        self.charTouchButtonPopups = charTouchButtonPopups
        hideAll()
    }
    
    func showPopup(popup: UILabel) {
        popup.hidden = false
        currPopup = popup
    }
    
    func hidePopup() {
        if currPopup != nil {
            currPopup!.hidden = true
        }
    }
    
    func hideAll() {
        for popup in charTouchButtonPopups {
            popup.hidden = true
        }
        
    }

}
