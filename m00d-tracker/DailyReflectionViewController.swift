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
    
    init(sheetController: GoogleSheetController) {
        self.sheetController = sheetController
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
        let emojiToggleConstraints = self.layoutEmojiToggles(emojiToggleList: ["🌿", "👟", "🧘🏻‍♀️"])
        constraints += emojiToggleConstraints
        
        let doneButton = UIButton(type: UIButton.ButtonType.system)
        doneButton.setTitle("Done", for: UIControl.State.normal)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
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
        formatter.dateFormat = "MM/dd/yyyy"
        
        let dateLabel = UILabel()
        dateLabel.text = formatter.string(from: date)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
