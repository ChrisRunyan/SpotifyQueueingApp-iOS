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
    // login with Spotify popup message instead of segue
    // forward button once Spotify login that lets fast forward logging into Spotify account
    
    @IBOutlet weak var roomNameTextField: UITextField!
    @IBOutlet weak var roomCodeTextField: UITextField!
    @IBOutlet weak var aliasTextField: UITextField!
    
    @IBOutlet weak var createRoomButton: UIButton!
    
    var fHelper = FirebaseHelper()
    
    var myRoom = Room()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        buildRoomCodeArray()
    }

    @IBAction func createRoomButtonPressed(_ sender: Any) {
        var roomExists = false
        
        // verify room does not exist
        print("checking if room code ", self.roomCodeTextField.text!, " exists")
        self.fHelper.updateRoomCodeExists(roomCode: self.roomCodeTextField.text!)
        
        let sv = UIViewController.displaySpinner(onView: self.view)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            UIViewController.removeSpinner(spinner: sv)
            
            roomExists = self.fHelper.roomCodeExists
            
            if(roomExists) {
                self.roomCodeAlreadyExistsAlert()
            }
            else {
                // create room object
                self.myRoom = Room(roomName: self.roomNameTextField.text!, roomCode: self.roomCodeTextField.text!, roomOwner: self.aliasTextField!.text!)
                
                // attempt to add room to Firebase
                self.fHelper.addRoomToDB(roomToAdd: self.myRoom)
                
                // attempt to login to Spotify
    //            self.performSegue(withIdentifier: "spotifyLoginSegue", sender: nil)
                
                self.performSegue(withIdentifier: "roomOwnerSegue", sender: nil)
            }
        }
    }
    
    private func roomCodeAlreadyExistsAlert() {
        let storyModeLaunchAlert = UIAlertController(title: "Error", message: "Room code " + roomCodeTextField.text! + " already exists.", preferredStyle: UIAlertController.Style.alert)
        storyModeLaunchAlert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.cancel, handler:
            {action in
                // action
        }))
        self.present(storyModeLaunchAlert, animated: true, completion: nil)
    }
    
    internal override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "roomOwnerSegue"){
            let secondViewController = segue.destination as! PlaylistViewController
            secondViewController.setRoomType(roomType: "owner")
        }
    }
}

extension UIViewController {
    class func displaySpinner(onView : UIView) -> UIView {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        return spinnerView
    }
    
    class func removeSpinner(spinner :UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
}
