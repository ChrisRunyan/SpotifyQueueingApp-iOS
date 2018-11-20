//
//  JoinRoomViewController.swift
//  Apollo
//
//  Created by Christopher Runyan on 11/6/18.
//  Copyright © 2018 Christopher Runyan. All rights reserved.
//

import UIKit

class JoinRoomViewController: UIViewController {
    // join room button grayed out until all valid data entered
    
    @IBOutlet weak var roomCodeTextField: UITextField!
    @IBOutlet weak var aliasTextField: UITextField!
    @IBOutlet weak var joinRoomButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func joinRoomButtonPressed(_ sender: Any) {
        // attempt to load room from firebase
        
        self.performSegue(withIdentifier: "roomGuestSegue", sender: nil)
    }
    
    private func loadRoomData() {
        
    }

    internal override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "roomGuestSegue"){
            let secondViewController = segue.destination as! PlaylistViewController
            secondViewController.setRoomType(roomType: "guest")
        }
    }
}
