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

    let service = GTLRSheetsService()

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
    
    func writeToSpreadsheet() {
        // eventually this will be dynamic
        let spreadsheetId = "1seWeHbq5MahbGNjzoxyKORr4Ib8xDoJFEPxVC-GhfF4"
        let sheetRange = "A1"
        let sheetValues = GTLRSheets_ValueRange()
        sheetValues.values = [["meggyG"]]
        let sheetsQuery = GTLRSheetsQuery_SpreadsheetsValuesUpdate.query(withObject: sheetValues, spreadsheetId: spreadsheetId, range: sheetRange)
        sheetsQuery.valueInputOption = "USER_ENTERED"
        service.executeQuery(sheetsQuery, completionHandler: {(handler) in
            if let error = handler.2 {
                print("We at a Error: \(error.localizedDescription)")
                return
            }
        })
    }
    
    // MARK: - GIDSignInDelegate
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            service.authorizer = user.authentication.fetcherAuthorizer()
            writeToSpreadsheet()
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
}

