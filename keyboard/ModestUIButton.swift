//
//  ModestUIButton.swift
//  keyboard-201606220-01
//
//  Created by rocker on 20160622.
//  Copyright © 2016 rocker. All rights reserved.
//

import UIKit

class ModestUIButton: UIButton {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        
        var boundsExtension: CGFloat = 0.0
        var outerBounds: CGRect = CGRectInset(self.bounds, -1 * boundsExtension, -1 * boundsExtension)
        
        var touchOutside: Bool = !CGRectContainsPoint(outerBounds, touch.locationInView(self))
        
        if (touchOutside) {
            var previousTouchInside: Bool = CGRectContainsPoint(outerBounds, touch.previousLocationInView(self))
            if(previousTouchInside) {
                self.sendActionsForControlEvents(UIControlEvents.TouchDragExit)
            } else {
                self.sendActionsForControlEvents(UIControlEvents.TouchDragOutside)
            }
        }
        
        return super.continueTrackingWithTouch(touch, withEvent: event)
    }

}
