//
//  MainViewController.swift
//  Apollo
//
//  Created by Christopher Runyan on 10/20/18.
//  Copyright © 2018 Christopher Runyan. All rights reserved.
//
//  Some code taken from tutorial created by Elon Rubin from https://medium.com/@elonrubin.
//

import UIKit
import SafariServices
import AVFoundation
import FirebaseDatabase

class SpotifyLoginViewController: UIViewController, SPTAudioStreamingPlaybackDelegate, SPTAudioStreamingDelegate {
    var auth = SPTAuth.defaultInstance()!
    var session:SPTSession!
    
    var player: SPTAudioStreamingController?
    var loginUrl: URL?
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        NotificationCenter.default.addObserver(self, selector: #selector(SpotifyLoginViewController.updateAfterFirstLogin), name: NSNotification.Name(rawValue: "loginSuccessfull"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func setup () {
        let redirectURL = "Apollo://returnAfterLogin"
        let clientID = "" // insert clientID here 
        auth.redirectURL     = URL(string: redirectURL)
        auth.clientID        = clientID
        auth.requestedScopes = [SPTAuthStreamingScope, SPTAuthPlaylistReadPrivateScope, SPTAuthPlaylistModifyPublicScope, SPTAuthPlaylistModifyPrivateScope]
        loginUrl = auth.spotifyWebAuthenticationURL()
    }
    
    func initializaPlayer(authSession:SPTSession) {
        if self.player == nil {
            self.player = SPTAudioStreamingController.sharedInstance()
            self.player!.playbackDelegate = self
            self.player!.delegate = self
            try! player?.start(withClientId: auth.clientID)
            self.player!.login(withAccessToken: authSession.accessToken)
        }
    }
    
    @objc func updateAfterFirstLogin () {
        loginButton.isHidden = true
        
        writeToDB()
        
        let userDefaults = UserDefaults.standard
        
        // Place session key here
        if let sessionObj:AnyObject = userDefaults.object(forKey: "SpotifySession") as AnyObject? {
            let sessionDataObj = sessionObj as! Data
            let firstTimeSession = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as! SPTSession
            
            self.session = firstTimeSession
            initializaPlayer(authSession: session)
            self.loginButton.isHidden = true
        }
    }
    
    func writeToDB() {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let timeStamp = String(hour) + ":" + String(minutes)
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        ref.child("song_3").setValue("snow")
        ref.child("time_3").setValue(timeStamp)
    }
    
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
       print("logged in")
            self.player?.playSpotifyURI("spotify:track:2aibwv5hGXSgw7Yru8IYTO", startingWith: 0, startingWithPosition: 0, callback: { (error) in
                if (error != nil) {
                    print("playing!")
                }
            })
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        if UIApplication.shared.openURL(loginUrl!) {
            if auth.canHandle(auth.redirectURL) {
                // error
            }
        }
    }
}

