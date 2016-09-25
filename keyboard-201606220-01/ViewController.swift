//
//  ViewController.swift
//  keyboard-201606220-01
//
//  Created by rocker on 20160622.
//  Copyright © 2016 rocker. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  dimensions
        let fontSize = CGFloat(16)
        let buttonFontSize = CGFloat(22)
        let versionFontSize = CGFloat(14)
        let textWidth = CGFloat(230)
        
        // colors
        let backgroundColor = UIColor.whiteColor()
        
        let textString = "Setup:\n\n" +
        "1. Go to Settings -> General -> Keyboard -> Keyboards -> Add New Keyboard.\n\n" +
        "2. Tap doug.\n\n" +
        "3. Tap Edit.\n\n" +
        "4. If you want doug to be the default keyboard, drag doug to the top of the keyboards list using the handle on the right.\n\n" +
        "5. Tap a text field in any app to bring up the keyboard.\n\n" +
        "6. Tap the globe icon in the lower-left corner of the keyboard until doug appears.\n"
        
        // setup
        view.backgroundColor = backgroundColor
        
        // LOGO
        
        let logo = UIImageView(image: UIImage(named: "appScreenLogo"))
        view.addSubview(logo)
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        logo.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor, constant: -200).active = true
        
        // TEXT
        
        let text = UILabel()
        view.addSubview(text)
        text.translatesAutoresizingMaskIntoConstraints = false
        text.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        text.topAnchor.constraintEqualToAnchor(logo.bottomAnchor).active = true
        text.widthAnchor.constraintEqualToConstant(textWidth).active = true
        text.text = textString
        text.font = text.font.fontWithSize(fontSize)
        text.textAlignment = NSTextAlignment.Left
        text.numberOfLines = 0
        
        // FEEDBACK BUTTON
        
        let feedbackButton = UIButton()
        view.addSubview(feedbackButton)
        feedbackButton.translatesAutoresizingMaskIntoConstraints = false
        feedbackButton.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        feedbackButton.topAnchor.constraintEqualToAnchor(text.bottomAnchor, constant: 10).active = true
        feedbackButton.widthAnchor.constraintEqualToConstant(textWidth).active = true
        feedbackButton.setTitle("Contact", forState: UIControlState.Normal)
        feedbackButton.setTitleColor(UIColor.init(white: 0.35, alpha: 1), forState: .Normal)
        let font = feedbackButton.titleLabel!.font
        feedbackButton.titleLabel!.font = font.fontWithSize(buttonFontSize)
        feedbackButton.layer.cornerRadius = 5
        feedbackButton.addTarget(self, action: #selector(sendFeedback), forControlEvents: .TouchUpInside)
        
        // VERSION
        
        let version = UILabel()
        view.addSubview(version)
        version.translatesAutoresizingMaskIntoConstraints = false
        version.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        version.topAnchor.constraintEqualToAnchor(feedbackButton.bottomAnchor).active = true
        version.widthAnchor.constraintEqualToConstant(textWidth).active = true
        version.font = text.font.fontWithSize(versionFontSize)
        version.textAlignment = NSTextAlignment.Center
        
        var versionString = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
        versionString = "Version: " + versionString
        version.text = versionString
        
    }
    
    func sendFeedback(button: UIButton) {
        let mailToURL = NSURL(string: "mailto:douglaslamb@douglaslamb.com?subject=Feedback")
        UIApplication.sharedApplication().openURL(mailToURL!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func loadView() {
        super.loadView()
        let fullScreenRect = UIScreen.mainScreen().bounds
        let scrollView = UIScrollView(frame: fullScreenRect)
        scrollView.contentSize = CGSize(width: 320, height: 750)
        self.view = scrollView
    }


}

