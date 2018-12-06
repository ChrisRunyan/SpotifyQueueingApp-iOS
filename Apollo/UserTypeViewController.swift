//
//  UserTypeViewController.swift
//  Apollo
//
//  Created by Christopher Runyan on 11/4/18.
//  Copyright © 2018 Christopher Runyan. All rights reserved.
//

import UIKit

class UserTypeViewController: UIViewController {
    private let userTypePickerDelegate = UserTypePickerDelegate()
    @IBOutlet weak var userTypePickerView: UIPickerView!
    @IBOutlet weak var selectButton: UIButton!
    
    private var chosenState = "Join Room"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userTypePickerView.delegate = userTypePickerDelegate
    }

    private func returnRowForChosenState() -> Int {
        var toReturn = 0
        
        if(chosenState == "Join Room") {toReturn = 0}
        else if(chosenState == "Create Room") {toReturn = 1}
        
        return toReturn
    }
    
    @IBAction func selectButtonPressed(_ sender: Any) {
        chosenState = (userTypePickerView.delegate?.pickerView!(userTypePickerView, titleForRow: userTypePickerView.selectedRow(inComponent: 0), forComponent: 0))!
        
        if(chosenState == "Create Room") {
            self.performSegue(withIdentifier: "createRoomSegue", sender: nil)
        }
        else if(chosenState == "Join Room") {
            self.performSegue(withIdentifier: "joinRoomSegue", sender: nil)
        }
    }
}
