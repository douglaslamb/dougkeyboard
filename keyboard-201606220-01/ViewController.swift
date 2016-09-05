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
        
        let logo = UIImageView(image: UIImage(named: "spaceKeyLogo"))
        view.addSubview(logo)
        
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        logo.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor, constant: -200).active = true
        
        let text = UILabel()
        view.addSubview(text)
        text.translatesAutoresizingMaskIntoConstraints = false
        text.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        text.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
        text.text = "Hello"
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

