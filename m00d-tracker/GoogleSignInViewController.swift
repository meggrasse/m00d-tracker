//
//  GoogleSignInViewController.swift
//  m00d-tracker
//
//  Created by Meg on 8/9/18.
//  Copyright © 2018 meggrasse. All rights reserved.
//

import UIKit
import GoogleSignIn
import GoogleAPIClientForREST

class ViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scopes = [kGTLRAuthScopeSheetsSpreadsheets]
        
        // Initialize sign-in
        GIDSignIn.sharedInstance().clientID = kClientID
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().scopes = scopes
        // TODO: implement on UI side
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
    
    // MARK: - GIDSignInDelegate
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            let service = GTLRSheetsService()
            service.authorizer = user.authentication.fetcherAuthorizer()
            // eventually we want this to be dynamic
            let sheetID = "1seWeHbq5MahbGNjzoxyKORr4Ib8xDoJFEPxVC-GhfF4"
            let sheetController = GoogleSheetController(service: service, sheetID: sheetID)
            let nextVC = DailyReflectionViewController(sheetController: sheetController)
            self.present(nextVC, animated: true, completion: nil)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
}

