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
//import FirebaseDatabase

class SpotifyLoginViewController: UIViewController, SPTAudioStreamingPlaybackDelegate, SPTAudioStreamingDelegate {
    var auth = SPTAuth.defaultInstance()!
    var session:SPTSession!
    
    var player: SPTAudioStreamingController?
    var loginUrl: URL?
    
    var room = Room()
    
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
        let clientID = "557e689d80c747afa78e8a9e34e0b854" // insert clientID here
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
        
//        writeToDB()
        
        let userDefaults = UserDefaults.standard
        
        // Place session key here
        if let sessionObj:AnyObject = userDefaults.object(forKey: "SpotifySession") as AnyObject? {
            let sessionDataObj = sessionObj as! Data
            let firstTimeSession = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as! SPTSession
            
            self.session = firstTimeSession
            initializaPlayer(authSession: session)
            self.loginButton.isHidden = true
        }
        
        print("**access token in Spotify: ", self.session.accessToken)
        print("**refresh token in Spotify: ", self.session.encryptedRefreshToken)
        
        self.performSegue(withIdentifier: "spotifyLoggedInSegue", sender: nil)
    }
    
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
       print("logged in")
            self.player?.playSpotifyURI("spotify:track:2aibwv5hGXSgw7Yru8IYTO", startingWith: 0, startingWithPosition: 0, callback: { (error) in
                if (error != nil) {
                    print("playing!")
                }
            })
    }
    
    public func setRoom(room: Room) {
        self.room = room
    }
    
    static func playSong(songID: String) {
        
    }
    
    private func playSong(_ audioStreaming: SPTAudioStreamingController!, songID: String) {
        self.player?.playSpotifyURI("spotify:track:" + songID, startingWith: 0, startingWithPosition: 0, callback: { (error) in
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
    
    internal override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "spotifyLoggedInSegue"){
            let secondViewController = segue.destination as! CreateRoomViewController
            secondViewController.setSpotifyAccessToken(spotifyAccessToken: session.accessToken as String)
            secondViewController.setRoom(room: room)
            secondViewController.backFromSpotify()
            print("set access token in Spotify to: ", session.accessToken)
//            secondViewController.setSpotifyRefreshToken(spotifyRefreshToken: session.encryptedRefreshToken)
        }
    }
}

