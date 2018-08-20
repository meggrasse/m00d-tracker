//
//  DailyReflectionViewController.swift
//  m00d-tracker
//
//  Created by Meg on 8/13/18.
//  Copyright © 2018 meggrasse. All rights reserved.
//

import UIKit

class DailyReflectionViewController: UIViewController {
    
    let sheetController : GoogleSheetController
    var toggles : [UISwitch]
    var currDate : String
    
    init(sheetController: GoogleSheetController) {
        self.sheetController = sheetController
        self.toggles = []
        self.currDate = "COULDN'T ACCESS DATE"
        super.init(nibName: nil, bundle: nil)
    }
    
    // I would like to not do this
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        var constraints: [NSLayoutConstraint] = []
        
        let dateLabelContstraints = layoutDateLabel()
        constraints += dateLabelContstraints
        
        // TODO: make this read data
        let emojis = ["🌿", "👟", "🧘🏻‍♀️"]
        let emojiToggleConstraints = self.layoutEmojiToggles(emojiToggleList: emojis)
        constraints += emojiToggleConstraints
        
        let doneButton = UIButton(type: UIButton.ButtonType.system)
        doneButton.setTitle("next", for: UIControl.State.normal)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.addTarget(self, action: #selector(doneButtonAction), for: UIControl.Event.touchUpInside)
        view.addSubview(doneButton)
        
        let doneButtonConstraints = [
            doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            doneButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100)
        ]
        
        constraints += doneButtonConstraints
        
        NSLayoutConstraint.activate(constraints)

        // Do any additional setup after loading the view.
    }
    
    func layoutDateLabel() -> [NSLayoutConstraint] {
        let date = Date()
        let formatter = DateFormatter()
        // TODO: make it a subtitle eventually
        formatter.dateFormat = "MM/dd/yyyy - HH:mm"
        
        let dateLabel = UILabel()
        let dateString = formatter.string(from: date)
        dateLabel.text = dateString
        currDate = dateString
        
        dateLabel.font = UIFont.systemFont(ofSize: 40)
        dateLabel.textAlignment = .center
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dateLabel)
        
        let constraints = [
            dateLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            dateLabel.rightAnchor.constraint(equalTo: view.rightAnchor),
            dateLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100)
        ]
        
        return constraints
    }
    
    func layoutEmojiToggles(emojiToggleList : [String]) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        
        // create each UI object
        // TODO: extend for more than 5 items
        for i in 0..<emojiToggleList.count {
            let emojiLabel = UILabel()
            emojiLabel.text = emojiToggleList[i]
            emojiLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(emojiLabel)
            
            let toggle = UISwitch()
            toggle.translatesAutoresizingMaskIntoConstraints = false
            // Add to `toggles` member so we can read data from the UI element later
            toggles.append(toggle)
            view.addSubview(toggle)
        
            // y position - index determines height
            let yConstant = (CGFloat(i) - 2) * 50
            constraints.append(emojiLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: yConstant))
            constraints.append(toggle.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: yConstant))
            
            // x position
            constraints.append(emojiLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -30.0))
            constraints.append(toggle.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 30.0))
        }
        
        return constraints
    }
    
    @objc func doneButtonAction() {
        
        // this will dynamically choose a column letter
        // maybe we'll be specific about range
        sheetController.findFirstBlankColumn(completion: { (id) in
            if let columnID = id {
                let range = "Sheet1!" + columnID + "1:" + columnID
                
                // Capture data and send it to sheet - (in case user doesn't fill out mood)
                var values = [self.currDate]
                values += self.toggles.map { $0.isOn ? "X" : "" }
                self.sheetController.writeToSpreadsheetColumn(range: range, values: values)
                
                // make sure we don't have async problems
                // present a DailyMoodViewController
                let nextVC = DailyMoodViewController()
                self.present(nextVC, animated: true, completion: nil)
            } else {
                print("couldn't write to spreadsheet.")
            }
            
        })
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
