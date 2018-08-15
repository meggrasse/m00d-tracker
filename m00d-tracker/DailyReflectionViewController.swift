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
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        
        let dateLabel = UILabel()
        dateLabel.text = formatter.string(from: date)
        dateLabel.font = UIFont.systemFont(ofSize: 36)
        dateLabel.textAlignment = .center
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dateLabel)
        
        let constraints = [
            dateLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            dateLabel.rightAnchor.constraint(equalTo: view.rightAnchor),
            dateLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ]
        
        NSLayoutConstraint.activate(constraints)

        // Do any additional setup after loading the view.
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
