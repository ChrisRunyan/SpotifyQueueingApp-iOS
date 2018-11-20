//
//  CreateRoomViewController.swift
//  Apollo
//
//  Created by Christopher Runyan on 11/6/18.
//  Copyright © 2018 Christopher Runyan. All rights reserved.
//

import UIKit

class CreateRoomViewController: UIViewController {
    // create room button grayed out until all valid data entered
    
    @IBOutlet weak var roomNameTextField: UITextField!
    @IBOutlet weak var roomCodeTextField: UITextField!
    @IBOutlet weak var aliasTextField: UITextField!
    
    @IBOutlet weak var createRoomButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func createRoomButtonPressed(_ sender: Any) {
        // attempt to login to Spotify 
        // attempt to add room to Firebase
        
        self.performSegue(withIdentifier: "roomOwnerSegue", sender: nil)
    }

    internal override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "roomOwnerSegue"){
            let secondViewController = segue.destination as! PlaylistViewController
            secondViewController.setRoomType(roomType: "owner")
        }
    }
}
