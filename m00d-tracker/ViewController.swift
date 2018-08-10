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
import GoogleAPIClientForREST

class ViewController: UIViewController, GIDSignInUIDelegate {
    
    let service = GTLRSheetsService()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scopes = [kGTLRAuthScopeSheetsSpreadsheets]
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().scopes = scopes
        
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
    
    func readFromSpreadsheet() {
        // eventually this will be dynamic
        let spreadsheetId = "1seWeHbq5MahbGNjzoxyKORr4Ib8xDoJFEPxVC-GhfF4"
        // possible bug here
        let range = "A1"
        let query = GTLRSheetsQuery_SpreadsheetsValuesGet
            .query(withSpreadsheetId: spreadsheetId, range:range)
        // this method doesn't make a lot of sense to me
        service.executeQuery(query,
                             delegate: self,
                             didFinish: #selector(displayResultWithTicket(ticket:finishedWithObject:error:))
        )
    }
    
    // Process the response and display output
    @objc func displayResultWithTicket(ticket: GTLRServiceTicket,
                                 finishedWithObject result : GTLRSheets_ValueRange,
                                 error : NSError?) {
        
        if let error = error {
            print("We at a Error: \(error.localizedDescription)")
            return
        }
        
        let rows = result.values!
        
        if rows.isEmpty {
            print("No data found.")
            return
        }
        
        print(rows[0])
    }



}

