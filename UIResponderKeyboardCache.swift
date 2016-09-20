//
//  UIResponder+KeyboardCache.swift
//  keyboard-201606220-01
//
//  Created by rocker on 20160920.
//  Copyright © 2016 rocker. All rights reserved.
//
/*
import UIKit

extension UIResponder {
    
    static var hasAlreadyCachedKeyboard: Bool = false
    
    static func cacheKeyboard() {
        cacheKeyboard(false)
    }
    
    static func cacheKeyboard(onNextRunLoop: Bool) {
        if !hasAlreadyCachedKeyboard {
            hasAlreadyCachedKeyboard = true
            if onNextRunLoop {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0), dispatch_get_main_queue(), __cacheKeyboard);
            } else {
                __cacheKeyboard()
            }
        }
    }
    
    static func __cacheKeyboard() {
        let field = UITextField()
        UIApplication.sharedApplication().windows.last?.addSubview(field)
        field.becomeFirstResponder()
        field.resignFirstResponder()
        field.removeFromSuperview()
    }
}
*/