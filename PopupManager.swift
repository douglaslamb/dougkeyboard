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
        let popup = currPopup
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.2 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
            if popup != nil {
                popup!.hidden = true
            }
        });
    }
    
    func slideHidePopup() {
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
