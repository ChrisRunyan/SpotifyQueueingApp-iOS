//
//  JoinRoomViewController.swift
//  Apollo
//
//  Created by Christopher Runyan on 11/6/18.
//  Copyright © 2018 Christopher Runyan. All rights reserved.
//

import UIKit

class JoinRoomViewController: UIViewController {
    @IBOutlet weak var roomCodeTextField: UITextField!
    @IBOutlet weak var aliasTextField: UITextField!
    @IBOutlet weak var joinRoomButton: UIButton!
    
    var fHelper = FirebaseHelper()
    var myRoom = Room()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roomCodeTextField.autocorrectionType = UITextAutocorrectionType.no
        aliasTextField.autocorrectionType = UITextAutocorrectionType.no
    }
    
    public func allFieldsFilledOut() -> Bool {
        if(roomCodeTextField.text!.count > 0 && aliasTextField.text!.count > 0) {
            return true
        }
        else {
            return false
        }
    }
    
    @IBAction func joinRoomButtonPressed(_ sender: Any) {
        var roomExists = false
        
        if(allFieldsFilledOut()) {
            // verify room does not exist
            print("checking if room code ", self.roomCodeTextField.text!, " exists")
            self.fHelper.updateRoomCodeExists(roomCode: self.roomCodeTextField.text!)
            
            let sv = UIViewController.displaySpinner(onView: self.view)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                UIViewController.removeSpinner(spinner: sv)
                
                roomExists = self.fHelper.roomCodeExists
                
                if(!roomExists) {
                    self.roomCodeDoesNotExistAlert()
                    self.clearRoomCodeTextField()
                }
                else {
                    // load room from Firebase and place into Room object
                    self.fHelper.loadSongsFromRoomCode(roomCode: self.roomCodeTextField.text!)
                    print("songs initially: ", self.fHelper.getSongArray())
                    
                    // attempt to login to Spotify????????
                    //            self.performSegue(withIdentifier: "spotifyLoginSegue", sender: nil)
                    self.myRoom.setRoomCode(roomCode: self.roomCodeTextField.text!)
                    self.performSegue(withIdentifier: "roomGuestSegue", sender: nil)
                }
            }
        }
        else {
            notAllFieldsFilledOutAlert()
        }
        
    }
    
    private func clearRoomCodeTextField() {
        roomCodeTextField.text! = ""
    }
    
    private func notAllFieldsFilledOutAlert() {
        let storyModeLaunchAlert = UIAlertController(title: "Error", message: "All fields must be filled out.", preferredStyle: UIAlertController.Style.alert)
        storyModeLaunchAlert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.cancel, handler:
            {action in
                // action
        }))
        self.present(storyModeLaunchAlert, animated: true, completion: nil)
    }
    
    private func roomCodeDoesNotExistAlert() {
        let storyModeLaunchAlert = UIAlertController(title: "Error", message: "Room code " + roomCodeTextField.text! + " does not exist.", preferredStyle: UIAlertController.Style.alert)
        storyModeLaunchAlert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.cancel, handler:
            {action in
                // action
        }))
        self.present(storyModeLaunchAlert, animated: true, completion: nil)
    }
    
    private func loadRoomData() {
        
    }

    internal override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "roomGuestSegue"){
            let secondViewController = segue.destination as! PlaylistViewController
            secondViewController.setRoomType(roomType: "guest")
            secondViewController.setFirebaseHelper(fHelper: fHelper)
            secondViewController.setRoom(myRoom: myRoom)
        }
    }
}
