//
//  GoogleSheetController.swift
//  
//
//  Created by Meg on 8/10/18.
//

import UIKit
import GoogleAPIClientForREST

// the idea here is an instance of this controller is associated with a specific spreadsheet, and handles all of the writing, etc
class GoogleSheetController: NSObject {
    var sheetsService : GTLRSheetsService? = nil
    var spreadsheetID : String? = nil
    
    init(service: GTLRSheetsService?, sheetID: String?) {
        self.sheetsService = service
        self.spreadsheetID = sheetID
    }
    
    func writeToSpreadsheet(range: String, values: [[String]]) {
        let sheetValues = GTLRSheets_ValueRange()
        sheetValues.values = values
        if let sheetID = spreadsheetID, let service = sheetsService {
            let sheetsQuery = GTLRSheetsQuery_SpreadsheetsValuesUpdate.query(withObject: sheetValues, spreadsheetId: sheetID, range: range)
            sheetsQuery.valueInputOption = "USER_ENTERED"
            service.executeQuery(sheetsQuery, completionHandler: {(handler) in
                if let error = handler.2 {
                    print("We at a Error: \(error.localizedDescription)")
                    return
                }
            })
        } else {
            print("Something not configured correctly.")
        }
    }

}
