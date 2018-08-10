//
//  ViewController.swift
//  m00d-tracker
//
//  Created by Meg on 8/9/18.
//  Copyright © 2018 meggrasse. All rights reserved.
//

import UIKit
// shouldn't i get this for free
import GoogleSignIn

class ViewController: UIViewController, GIDSignInUIDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        // Uncomment to automatically sign in the user.
//        GIDSignIn.sharedInstance().signInSilently()
        let signInButton = GIDSignInButton()
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(signInButton)
        
        let constraints = [
            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signInButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

