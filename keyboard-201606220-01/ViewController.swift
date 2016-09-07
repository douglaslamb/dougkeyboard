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
        let fontSize = CGFloat(17)
        let buttonFontSize = CGFloat(22)
        let textWidth = CGFloat(230)
        
        // colors
        let backgroundColor = UIColor.whiteColor()
        
        let introString = "Thank you! I welcome complaints and feature requests."
        let textString = "Features:\n\n" +
        "1. Spacebar Shift - Hold the spacebar and tap for a capitalized letter\n\n" +
        
        "Setup:\n\n" +
        "1. Go to Settings -> General -> Keyboard -> Keyboards -> Add New Keyboard\n" +
        "2. Tap Doug\n" +
        "3. Bring up the keyboard by tapping a text field in any app\n" +
        "4. Tap the globe icon in the lower-left corner until Doug appears\n\n" +
        "Please send me the email address of anyone interested in trying this, or have them email douglaslamb@douglaslamb.com."
        
        // setup
        view.backgroundColor = backgroundColor
        
        // LOGO
        
        let logo = UIImageView(image: UIImage(named: "appScreenLogo"))
        view.addSubview(logo)
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        logo.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor, constant: -200).active = true
        
        // INTRO
        
        let intro = UILabel()
        view.addSubview(intro)
        intro.translatesAutoresizingMaskIntoConstraints = false
        intro.font = intro.font.fontWithSize(fontSize)
        intro.text = introString
        intro.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        intro.widthAnchor.constraintEqualToConstant(textWidth).active = true
        intro.topAnchor.constraintEqualToAnchor(logo.bottomAnchor).active = true
        intro.numberOfLines = 0
        intro.textAlignment = NSTextAlignment.Center
        
        // FEEDBACK BUTTON
        
        let feedbackButton = UIButton()
        view.addSubview(feedbackButton)
        feedbackButton.translatesAutoresizingMaskIntoConstraints = false
        feedbackButton.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        feedbackButton.topAnchor.constraintEqualToAnchor(intro.bottomAnchor).active = true
        feedbackButton.setTitle("Contact", forState: UIControlState.Normal)
        feedbackButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        let font = feedbackButton.titleLabel!.font
        feedbackButton.titleLabel!.font = font.fontWithSize(buttonFontSize)
        feedbackButton.layer.cornerRadius = 5
        feedbackButton.addTarget(self, action: #selector(sendFeedback), forControlEvents: .TouchUpInside)
        
        // TEXT
        
        let text = UILabel()
        view.addSubview(text)
        text.translatesAutoresizingMaskIntoConstraints = false
        text.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        text.topAnchor.constraintEqualToAnchor(feedbackButton.bottomAnchor).active = true
        text.widthAnchor.constraintEqualToAnchor(intro.widthAnchor).active = true
        text.text = textString
        text.font = text.font.fontWithSize(fontSize)
        text.textAlignment = NSTextAlignment.Left
        text.numberOfLines = 0
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

