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
    
    func writeToSpreadsheet(range: String, sheetValues: GTLRSheets_ValueRange) {
        if let sheetID = spreadsheetID, let service = sheetsService {
            let sheetsQuery = GTLRSheetsQuery_SpreadsheetsValuesUpdate.query(withObject: sheetValues, spreadsheetId: sheetID, range: range)
            sheetsQuery.valueInputOption = "USER_ENTERED"
            service.executeQuery(sheetsQuery, completionHandler: { (ticket: GTLRServiceTicket, result: Any?, error: Error?) in
                if let error = error {
                    print("We at a Error: \(error.localizedDescription)")
                    return
                }
            } )
        } else {
            print("Something not configured correctly.")
        }
    }
    
    func readFromSpreadsheet(range: String, readRows: Bool, completion: @escaping(_ values: [[Any]]?) -> ()) {
        if let sheetID = spreadsheetID, let service = sheetsService {
            let sheetsQuery = GTLRSheetsQuery_SpreadsheetsValuesGet.query(withSpreadsheetId: sheetID, range: range)
            sheetsQuery.majorDimension = readRows ? "ROWS" : "COLUMNS"
            service.executeQuery(sheetsQuery, completionHandler: { (ticket: GTLRServiceTicket, result: Any?, error: Error?) in
                guard let queryResult = result as? GTLRSheets_ValueRange else {
                    // something more elegant here?
                    print("We at an error")
                    return
                }
                completion(queryResult.values)
            })
        } else {
            print("Something not configured correctly.")
        }
    }
    
    func writeToSpreadsheetColumn(range: String, values: [String]) {
        let sheetValues = GTLRSheets_ValueRange()
        sheetValues.majorDimension = "COLUMNS"
        sheetValues.values = [values]
        writeToSpreadsheet(range: range, sheetValues: sheetValues)
    }
    
    // Expects user to submit a range that comprises of only one column
    func readFromSpreadsheetColumn(range: String, completion: @escaping(_ columnValues: [Any]?) -> ()) {
        readFromSpreadsheet(range: range, readRows: false, completion: { (values) in
                completion(values?[0])
        })
    }
    
    // reads from the column A of the spreadsheet excluding the first cell
    func readEmojiRowTitles(completion: @escaping(_ columnValues: [String]?) -> ()) {
        // this is an assumption
        let range = "Sheet1!A2:A"
        readFromSpreadsheetColumn(range: range, completion: { (values) in
            var emojiValues : [String] = []
            if let vals = values {
                for val in vals {
                    // assumes emoji is a string of 1 char. make this more robust later
                    if let valString = val as? String {
                        if valString.count == 1 {
                            emojiValues.append(valString)
                        }
                    }
                }
            }
            completion(emojiValues)
        })
    }
    
    // Scans cells in the first row starting with the second column until it finds a blank, and returns in the column ID of that blank
    func findFirstBlankColumn(completion: @escaping (_ ColumnID: String?) -> ()) {
        // Search through all cells in the first row starting with the second column
        // assumption about sheet
        let range = "Sheet1!B1:1"
        readFromSpreadsheet(range: range, readRows: true, completion: { (values) in
            let entryCount = values?[0].count ?? 0
            let blankColumnIndex = entryCount + 1
            if let asciiInt = UnicodeScalar(blankColumnIndex + 65) {
                completion(String(asciiInt))
            }
        })
    }
}
