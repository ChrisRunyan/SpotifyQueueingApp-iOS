//
//  CreateRoomViewController.swift
//  Apollo
//
//  Created by Christopher Runyan on 11/6/18.
//  Copyright © 2018 Christopher Runyan. All rights reserved.
//

import UIKit

class CreateRoomViewController: UIViewController {
    // TODO?: login with Spotify popup message instead of segue
    
    @IBOutlet weak var roomNameTextField: UITextField!
    @IBOutlet weak var roomCodeTextField: UITextField!
    @IBOutlet weak var aliasTextField: UITextField!
    
    @IBOutlet weak var createRoomButton: UIButton!
    
    var fHelper = FirebaseHelper()
    var sHelper = SpotifyHelper()
    var myRoom = Room()
    var spotifyAccessToken = "spotifyAccessToken"
//    var spotifyRefreshToken = "spotifyRefreshToken"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        buildRoomCodeArray()
        
        roomNameTextField.autocorrectionType = UITextAutocorrectionType.no
        roomCodeTextField.autocorrectionType = UITextAutocorrectionType.no
        aliasTextField.autocorrectionType = UITextAutocorrectionType.no
        
        spotifyAccessToken = "spotifyAccessToken"
    }

    public func setSpotifyAccessToken(spotifyAccessToken: String) {
        self.spotifyAccessToken = spotifyAccessToken
        
        print("setter used, set to: ", spotifyAccessToken)
    }
    
    public func allFieldsFilledOut() -> Bool {
        if(roomNameTextField.text!.count > 0 && roomCodeTextField.text!.count > 0 && aliasTextField.text!.count > 0) {
            return true
        }
        else {
            return false
        }
    }
    
    @IBAction func createRoomButtonPressed(_ sender: Any) {
        var roomExists = false
        
        // verify all fields are filled out
        if(allFieldsFilledOut()) {
            // verify room does not exist
            print("checking if room code ", self.roomCodeTextField.text!, " exists")
            self.fHelper.updateRoomCodeExists(roomCode: self.roomCodeTextField.text!)
            
            let sv = UIViewController.displaySpinner(onView: self.view)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                UIViewController.removeSpinner(spinner: sv)
                
                roomExists = self.fHelper.roomCodeExists
                
                if(roomExists) {
                    self.roomCodeAlreadyExistsAlert()
                    self.clearRoomCodeTextField()
                }
                else {
                    // create room object
                    print("creating room object")
                    self.myRoom = Room(roomName: self.roomNameTextField.text!, roomCode: self.roomCodeTextField.text!, roomOwner: self.aliasTextField!.text!)
                    
                    // attempt to login to Spotify
//                    self.performSegue(withIdentifier: "spotifyLoginSegue", sender: nil)
                    print("about to login to Spotify")
                    self.sHelper.loginToSpotify()
                    
//                    print("attempting to set access token")
//                    self.myRoom.setSpotifyRefreshToken(refreshToken: self.sHelper.getSpotifyAccessToken())
                    print("setting access token to: ", self.sHelper.getSpotifyAccessToken())
                    self.spotifyAccessToken = self.sHelper.getSpotifyAccessToken()
                    
                    self.backFromSpotify()
                    
//                    self.fHelper.addRoomToDB(roomToAdd: self.myRoom)
//                    self.backFromSpotify()
//                    self.performSegue(withIdentifier: "roomOwnerSegue", sender: nil)
                }
            }
        }
        else {
            notAllFieldsFilledOutAlert()
        }
        
    }
    
    // success! need another for failure? Call from Spotify, error catching there, just not call this method
    public func backFromSpotify() {
        print("about to set access token to: ", self.spotifyAccessToken)
        myRoom.setSpotifyAccessRoken(accessToken: self.spotifyAccessToken)
        
        // attempt to add room to Firebase
        print("about to add room to db")
//        self.fHelper.addRoomToDB(roomToAdd: self.myRoom)
        
        DispatchQueue.main.async(){
            print("about to perform segue")
            self.performSegue(withIdentifier: "roomOwnerSegue", sender: self)
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
            print("preparing for segue")
            secondViewController.setRoomType(roomType: "owner")
            secondViewController.setFirebaseHelper(fHelper: fHelper)
            secondViewController.setRoom(myRoom: myRoom)
            secondViewController.setSpotifyHelper(helper: sHelper)
        }
        else if(segue.identifier == "spotifyLoginSegue") {
            let secondViewController = segue.destination as! SpotifyLoginViewController
            secondViewController.setRoom(room: myRoom)
        }
    }
    
    public func setRoom(room: Room) {
        myRoom = room
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
